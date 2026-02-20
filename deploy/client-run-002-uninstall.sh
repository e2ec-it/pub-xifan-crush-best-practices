#!/usr/bin/env bash
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACK_ROOT="$(cd "$HERE/.." && pwd)"

# Determine repo root
ROOT="$(pwd)"
for i in {1..200}; do
  if [[ -d "${ROOT}/.git" ]]; then break; fi
  PARENT="$(dirname "${ROOT}")"
  if [[ "${PARENT}" == "${ROOT}" ]]; then break; fi
  ROOT="${PARENT}"
done

echo "[info] repo root: ${ROOT}"
CRUSH_JSON="${ROOT}/.crush.json"
if [[ ! -f "${CRUSH_JSON}" ]]; then
  echo "[info] no .crush.json found; nothing to do."
  exit 0
fi

STAMP="$(python3 - <<'PY'
import datetime;print(datetime.datetime.now().strftime('%Y%m%d_%H%M%S'))
PY)"
BACKUP_DIR="${ROOT}/.backup_crush_ecc_v4/${STAMP}/crush_project"
mkdir -p "${BACKUP_DIR}"
cp "${CRUSH_JSON}" "${BACKUP_DIR}/.crush.json"
echo "[info] backup written: ${BACKUP_DIR}/.crush.json"

MCP_SELECTED=()
MCP_COMMON=0
for arg in "$@"; do
  case "$arg" in
    --mcp-common) MCP_COMMON=1 ;;
    --mcp-*) MCP_SELECTED+=("${arg#--mcp-}") ;;
    *) ;;
  esac
done

if [[ "${#MCP_SELECTED[@]}" -gt 0 ]]; then
  export ECC_MCP_SELECTED="$(printf "%s
" "${MCP_SELECTED[@]}")"
else
  export ECC_MCP_SELECTED=""
fi
export ECC_MCP_COMMON="${MCP_COMMON}"

HERE="${HERE}" PACK_ROOT="${PACK_ROOT}" CRUSH_JSON="${CRUSH_JSON}" python3 - <<'PY'
import os, pathlib, sys

HERE = pathlib.Path(os.environ["HERE"])
PACK_ROOT = pathlib.Path(os.environ["PACK_ROOT"])
crush_json_path = pathlib.Path(os.environ["CRUSH_JSON"])

sys.path.insert(0, str(HERE / "lib"))
from crush_mcp_edit import load_or_new, dump, remove_mcp

common = os.environ.get("ECC_MCP_COMMON","0") == "1"
selected = [s for s in os.environ.get("ECC_MCP_SELECTED","").splitlines() if s.strip()]

obj = load_or_new(crush_json_path)
changed_any = False

def rm(name: str):
    global obj, changed_any
    obj, ch = remove_mcp(obj, name)
    changed_any = changed_any or ch
    if ch:
        print(f"[mcp] removed {name}")
    else:
        print(f"[mcp] {name} not present")

if common:
    for n in ["github","supabase","vercel","context7","filesystem"]:
        rm(n)
else:
    for n in selected:
        rm(n)

if changed_any:
    crush_json_path.write_text(dump(obj), encoding="utf-8")
    print("[crush] wrote .crush.json (MCP entries removed)")
else:
    print("[crush] no MCP changes")
PY

# Remove global skills installed by this pack by moving aside
SKILLS_DIR="${CRUSH_SKILLS_DIR:-$HOME/.config/crush/skills}"
STAMP2="$(date +%Y%m%d_%H%M%S)"
for s in ecc-planner ecc-tdd ecc-code-review ecc-security-review ecc-deployment ecc-docker ecc-api-design ecc-cost-aware-llm; do
  if [[ -d "${SKILLS_DIR}/${s}" ]]; then
    mv "${SKILLS_DIR}/${s}" "${SKILLS_DIR}/${s}.removed_by_crush_ecc_v4.${STAMP2}"
    echo "[skills] moved ${SKILLS_DIR}/${s} aside"
  fi
done


# Remove Superpowers skills installed by this pack by moving aside
for s in sp-brainstorming sp-git-worktrees sp-writing-plans sp-tdd sp-subagent-dev sp-executing-plans sp-request-code-review sp-finish-branch; do
  if [[ -d "${SKILLS_DIR}/${s}" ]]; then
    mv "${SKILLS_DIR}/${s}" "${SKILLS_DIR}/${s}.removed_by_crush_ecc_v4.${STAMP2}"
    echo "[skills] moved ${SKILLS_DIR}/${s} aside"
  fi
done

echo "Uninstall complete."
