#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_ROOT="$(cd "$HERE/.." && pwd)"

DO_ECC=0
DO_TOOL_GUARD=0
DO_SUPERPOWERS=0
DRY_RUN=0
PROJECT_ROOT=""

# MCP flags
MCP_SELECTED=()
MCP_COMMON=0

if [[ $# -eq 0 ]]; then
  DO_ECC=1
else
  for arg in "$@"; do
    case "$arg" in
      --ecc) DO_ECC=1 ;;
      --tool-guard) DO_TOOL_GUARD=1 ;;
      --superpowers) DO_SUPERPOWERS=1 ;;
      --dry-run) DRY_RUN=1 ;;
      --project-root=*) PROJECT_ROOT="${arg#*=}" ;;
      --mcp-common) MCP_COMMON=1 ;;
      --mcp-*) MCP_SELECTED+=("${arg#--mcp-}") ;;
      -h|--help)
        cat <<'HELP'
Usage: bash deploy/install.sh [options]
Core:
  --ecc                 Install ECC system blocks + curated skills
  --tool-guard          Append tool-guard system block
  --superpowers         Install Superpowers-inspired skills + system block
  --dry-run             Preview only; no writes
  --project-root=PATH   Force repo root

MCP (optional):
  --mcp-<name>          Install a specific MCP server into .crush.json (mcp section)
  --mcp-common          Install a common set: github, supabase, vercel, context7, filesystem

Examples:
  bash deploy/install.sh --ecc --tool-guard
  bash deploy/install.sh --mcp-github
  bash deploy/install.sh --mcp-common

List MCP names:
  bash deploy/tools/list_mcp.sh
HELP
        exit 0
        ;;
      *)
        echo "Unknown arg: $arg"
        exit 1
        ;;
    esac
  done
fi

# Pass selected MCP list via env (newline-delimited)
if [[ "${#MCP_SELECTED[@]}" -gt 0 ]]; then
  export ECC_MCP_SELECTED="$(printf "%s
" "${MCP_SELECTED[@]}")"
else
  export ECC_MCP_SELECTED=""
fi

export ECC_MCP_COMMON="${MCP_COMMON}"
export ECC_DO_ECC="${DO_ECC}"
export ECC_DO_TOOL_GUARD="${DO_TOOL_GUARD}"
export ECC_DO_SUPERPOWERS="${DO_SUPERPOWERS}"
export ECC_DRY_RUN="${DRY_RUN}"
export ECC_PROJECT_ROOT="${PROJECT_ROOT:-}"

HERE="${HERE}" PACK_ROOT="${PACK_ROOT}" python3 - <<'PY'
import os, pathlib, shutil, datetime, sys, json

HERE = pathlib.Path(os.environ["HERE"])
PACK_ROOT = pathlib.Path(os.environ["PACK_ROOT"])
sys.path.insert(0, str(HERE / "lib"))

from crush_merge import load_or_new, dump, append_system, add_pack_marker, SENTINEL, ECC_SENTINEL
from crush_mcp_edit import add_mcp_if_absent

def stamp():
    return datetime.datetime.now().strftime("%Y%m%d_%H%M%S")

def find_repo_root(start: pathlib.Path) -> pathlib.Path:
    cur = start.resolve()
    for _ in range(200):
        if (cur / ".git").exists():
            return cur
        if cur.parent == cur:
            return start.resolve()
        cur = cur.parent
    return start.resolve()

dry_run = os.environ.get("ECC_DRY_RUN","0") == "1"
start = pathlib.Path(os.getcwd())
forced = os.environ.get("ECC_PROJECT_ROOT","").strip()
project_root = pathlib.Path(forced).expanduser().resolve() if forced else find_repo_root(start)

stampv = stamp()
backup_root = project_root / ".backup_crush_ecc_v4" / stampv
(backup_root / "crush_project").mkdir(parents=True, exist_ok=True)

def info(msg): print(msg)

info(f"[info] project_root = {project_root}")
info(f"[info] dry_run      = {dry_run}")
info(f"[info] backups      = {backup_root}")

crush_json = project_root / ".crush.json"
obj = load_or_new(crush_json)

DO_ECC = os.environ.get("ECC_DO_ECC","0") == "1"
DO_TOOL_GUARD = os.environ.get("ECC_DO_TOOL_GUARD","0") == "1"
DO_SUPERPOWERS = os.environ.get("ECC_DO_SUPERPOWERS","0") == "1"
MCP_COMMON = os.environ.get("ECC_MCP_COMMON","0") == "1"
selected = [s for s in os.environ.get("ECC_MCP_SELECTED","").splitlines() if s.strip()]

# Load system blocks
tool_guard = (PACK_ROOT / "crush" / "templates" / "tool_guard.txt").read_text(encoding="utf-8")
ecc_rules  = (PACK_ROOT / "crush" / "templates" / "ecc_context_rules.txt").read_text(encoding="utf-8")
modes      = (PACK_ROOT / "crush" / "templates" / "workflow_modes.txt").read_text(encoding="utf-8")

changed_any = False

if DO_TOOL_GUARD:
    obj, ch = append_system(obj, tool_guard, SENTINEL)
    changed_any = changed_any or ch
    obj = add_pack_marker(obj, "tool-guard")
    info(f"[crush] appended tool-guard system (changed={ch})")

if DO_ECC:
    obj, ch1 = append_system(obj, ecc_rules, ECC_SENTINEL)
    obj, ch2 = append_system(obj, modes, "Workflow modes (choose implicitly):")
    changed_any = changed_any or ch1 or ch2
    obj = add_pack_marker(obj, "ecc")
    info(f"[crush] appended ECC rules (changed={ch1}) and modes (changed={ch2})")

if DO_SUPERPOWERS:
    sp_rules = (PACK_ROOT / "superpowers" / "superpowers_system.txt").read_text(encoding="utf-8")
    obj, chs = append_system(obj, sp_rules, "# Superpowers workflow (Crush)")
    changed_any = changed_any or chs
    obj = add_pack_marker(obj, "superpowers")
    info(f"[crush] appended Superpowers workflow system (changed={chs})")

# MCP installs
mcp_templates = json.loads((PACK_ROOT / "mcp-configs" / "ecc-mcp-servers.crush.json").read_text(encoding="utf-8"))

def ensure(name: str):
    nonlocal obj, changed_any
    if name not in mcp_templates:
        info(f"[warn] unknown mcp name: {name} (skipped)")
        return
    obj, ch = add_mcp_if_absent(obj, name, mcp_templates[name])
    changed_any = changed_any or ch
    if ch:
        info(f"[mcp] added {name}")
    else:
        info(f"[mcp] {name} already exists (no overwrite)")

if MCP_COMMON:
    for n in ["github","supabase","vercel","context7","filesystem"]:
        ensure(n)
else:
    for n in selected:
        ensure(n)

new_text = dump(obj)
old_text = crush_json.read_text(encoding="utf-8") if crush_json.exists() else None

if old_text != new_text:
    if crush_json.exists() and not dry_run:
        shutil.copy2(crush_json, backup_root / "crush_project" / ".crush.json")
    if not dry_run:
        crush_json.parent.mkdir(parents=True, exist_ok=True)
        crush_json.write_text(new_text, encoding="utf-8")
    info("[crush] wrote .crush.json (backup created if existed)")
else:
    info("[crush] .crush.json unchanged")

# Install global skills (ECC curated)
if DO_ECC:
    skills_dir = os.environ.get("CRUSH_SKILLS_DIR") or str(pathlib.Path.home() / ".config" / "crush" / "skills")
    skills_dir = pathlib.Path(os.path.expanduser(skills_dir))
    skills_dir.mkdir(parents=True, exist_ok=True)

    global_backup = skills_dir / ".backup_crush_ecc_v4" / stampv
    global_backup.mkdir(parents=True, exist_ok=True)

    def copy_skill(skill_name: str):
        src = PACK_ROOT / "crush" / "skills" / skill_name
        dst = skills_dir / skill_name
        for p in src.rglob("*"):
            rel = p.relative_to(src)
            out = dst / rel
            if p.is_dir():
                if not dry_run:
                    out.mkdir(parents=True, exist_ok=True)
                continue
            out.parent.mkdir(parents=True, exist_ok=True)
            if out.exists() and not dry_run:
                bak = global_backup / skill_name / rel
                bak.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(out, bak)
            if not dry_run:
                shutil.copy2(p, out)

    for s in ["ecc-planner","ecc-tdd","ecc-code-review","ecc-security-review","ecc-deployment","ecc-docker","ecc-api-design","ecc-cost-aware-llm"]:
        copy_skill(s)
    info(f"[skills] installed ECC skills -> {skills_dir} (collision backups -> {global_backup})")

    if DO_SUPERPOWERS:
        for s in ["sp-brainstorming","sp-git-worktrees","sp-writing-plans","sp-tdd","sp-subagent-dev","sp-executing-plans","sp-request-code-review","sp-finish-branch"]:
            copy_skill(s)
        info("[skills] installed Superpowers skills")

print("Done.")
PY
