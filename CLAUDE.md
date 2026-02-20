# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Repo Is

A skill and configuration pack that adapts **Everything Claude Code (ECC)** concepts into **Crush CLI** format. It installs:
- System prompt rules (tool-guard, ECC context discipline, workflow modes) into `.crush.json`
- Curated skills into `~/.config/crush/skills/`
- Optional MCP server configs into `.crush.json`

Upstream sources: [affaan-m/everything-claude-code](https://github.com/affaan-m/everything-claude-code) (MIT) and [obra/superpowers](https://github.com/obra/superpowers) (MIT).

---

## Common Commands

### Using Make (recommended)

```bash
make install            # 安装核心 ECC 技能和规则
make install-guard      # 安装 ECC + 工具守卫（推荐）
make install-full       # 完整安装（ECC + 守卫 + Superpowers + MCP）
make dry-run            # 预览安装内容（不修改文件）
make uninstall          # 安全卸载

make list-mcp           # 列出所有可用 MCP 服务器
make mcp-common         # 安装常用 MCP（github/supabase/vercel/context7/filesystem）
make mcp-github         # 安装 GitHub MCP

make setup-litellm      # 配置连接本地 LiteLLM 网关（交互式）
make setup-litellm-dry  # 预览 LiteLLM 网关配置
make unset-litellm      # 移除 LiteLLM 网关配置
```

### Direct Script Invocation

User-facing scripts are in `deploy/` with numbered prefixes:

```bash
# 001 Install
bash deploy/client-run-001-install.sh --ecc
bash deploy/client-run-001-install.sh --ecc --tool-guard
bash deploy/client-run-001-install.sh --ecc --tool-guard --superpowers --mcp-common
bash deploy/client-run-001-install.sh --ecc --tool-guard --dry-run
bash deploy/client-run-001-install.sh --mcp-github
bash deploy/client-run-001-install.sh --mcp-supabase

# 002 Uninstall
bash deploy/client-run-002-uninstall.sh
bash deploy/client-run-002-uninstall.sh --mcp-common

# 003 LiteLLM Gateway
bash deploy/client-run-003-setup-litellm.sh
bash deploy/client-run-003-setup-litellm.sh --ip 192.168.x.x
bash deploy/client-run-003-setup-litellm.sh --tailscale
bash deploy/client-run-003-setup-litellm.sh --dry-run
bash deploy/client-run-003-setup-litellm.sh --unset

# 004 List MCP servers
bash deploy/client-run-004-list-mcp.sh
```

---

## Architecture

### Install/Uninstall System (`deploy/`)

User-facing scripts use the `client-run-NNN-` prefix for ordered discoverability:

| Script | Purpose |
|--------|---------|
| `deploy/client-run-001-install.sh` | Main installer (Bash wrapper → Python helpers) |
| `deploy/client-run-002-uninstall.sh` | Safe removal script |
| `deploy/client-run-003-setup-litellm.sh` | Configure local LiteLLM gateway |
| `deploy/client-run-004-list-mcp.sh` | List available MCP server names |

Internal helpers (not run directly):

- **`deploy/lib/crush_merge.py`** — Manages `.crush.json` system prompt blocks using sentinel strings. `append_system()` is idempotent: it skips appending if the sentinel already exists. Key sentinels:
  - `"There is NO tool named \`read\`."` — tool-guard marker
  - `"ECC-style context discipline (compact):"` — ECC rules marker

- **`deploy/lib/crush_mcp_edit.py`** — Manages MCP entries in `.crush.json`. `add_mcp_if_absent()` never overwrites existing entries; `remove_mcp()` cleans them up on uninstall.

**client-run-001-install.sh flow:**
1. Parse flags → set environment variables passed to Python
2. Walk up to 200 dirs to find `.git` (repo root detection)
3. Create timestamped backup under `.backup_crush_ecc_v4/<timestamp>/`
4. Load or create `.crush.json` (schema: `https://charm.land/crush.json`)
5. Append system blocks (tool-guard → ECC rules → workflow modes → superpowers) using sentinels
6. Add MCP entries (non-destructive)
7. Write `.crush.json` only if content changed
8. Copy skill directories to `~/.config/crush/skills/` (or `$CRUSH_SKILLS_DIR`)

**client-run-002-uninstall.sh flow:** backup → remove MCPs via Python → rename skill dirs with `.removed_by_crush_ecc_v4.<timestamp>` suffix (never deletes).

### Skills (`crush/skills/`)

All skills are single `SKILL.md` files in their own directories. Two groups:

| Group | Prefix | Count | Focus |
|-------|--------|-------|-------|
| ECC | `ecc-` | 8 | Engineering practices (plan, TDD, code-review, security, deployment, docker, api-design, cost-aware-llm) |
| Superpowers | `sp-` | 8 | Workflow orchestration (brainstorming, writing-plans, executing-plans, subagent-dev, git-worktrees, tdd, request-code-review, finish-branch) |

### Templates (`crush/templates/`)

Plain text files appended verbatim into the `system` field of `.crush.json`:
- `ecc_context_rules.txt` — context discipline (read before acting, small steps, etc.)
- `tool_guard.txt` — valid Crush tools list; explicitly bans `read` (use `view`)
- `workflow_modes.txt` — Plan / Build / Review implicit modes

### MCP Configs (`mcp-configs/`)

`ecc-mcp-servers.crush.json` contains 14 pre-configured MCP server definitions. `--mcp-common` installs: `github`, `supabase`, `vercel`, `context7`, `filesystem`. Secrets use placeholder values (e.g. `YOUR_GITHUB_PAT_HERE`); see `mcp-configs/ENV.template` for what needs to be set.

### LiteLLM Gateway (`litellm-configs/`)

`client-run-003-setup-litellm.sh` configures Crush to connect to a local LiteLLM gateway (OpenAI-compatible `/v1` endpoint). Writes to `~/.config/crush/crush.json` and `~/.zshrc`. See `litellm-configs/README.md` for details.

---

## Key Invariants

- **Non-destructive**: Every operation creates a backup before modifying `.crush.json`. Skills are moved aside (not deleted) on uninstall.
- **Idempotent**: Sentinel strings prevent duplicate system blocks. MCP entries are only added if absent. Running install twice is safe.
- **No hardcoded secrets**: MCP templates use placeholder strings. Real tokens must be set by the user.
- **Crush ≠ Claude Code**: Crush uses `view` (not `read`) to open files. The tool-guard system block exists specifically to prevent Claude from hallucinating `read` as a valid tool.
