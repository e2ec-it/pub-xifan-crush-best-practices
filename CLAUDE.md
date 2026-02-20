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

### Install

```bash
# Core ECC skills + rules (recommended starting point)
bash deploy/install.sh --ecc

# Add tool-guard (prevents hallucinated tool names in Crush)
bash deploy/install.sh --ecc --tool-guard

# Full install: ECC + tool-guard + Superpowers + common MCP servers
bash deploy/install.sh --ecc --tool-guard --superpowers --mcp-common

# Preview without making changes
bash deploy/install.sh --ecc --tool-guard --dry-run

# Install a specific MCP server
bash deploy/install.sh --mcp-github
bash deploy/install.sh --mcp-supabase

# List all available MCP servers
bash deploy/tools/list_mcp.sh
```

### Uninstall

```bash
# Safe uninstall (creates backup first)
bash deploy/uninstall.sh

# Uninstall specific MCPs
bash deploy/uninstall.sh --mcp-common
```

---

## Architecture

### Install/Uninstall System (`deploy/`)

The installer is a Bash wrapper (`install.sh`) that delegates to two Python helpers:

- **`deploy/lib/crush_merge.py`** — Manages `.crush.json` system prompt blocks using sentinel strings. `append_system()` is idempotent: it skips appending if the sentinel already exists. Key sentinels:
  - `"There is NO tool named \`read\`."` — tool-guard marker
  - `"ECC-style context discipline (compact):"` — ECC rules marker

- **`deploy/lib/crush_mcp_edit.py`** — Manages MCP entries in `.crush.json`. `add_mcp_if_absent()` never overwrites existing entries; `remove_mcp()` cleans them up on uninstall.

**install.sh flow:**
1. Parse flags → set environment variables passed to Python
2. Walk up to 200 dirs to find `.git` (repo root detection)
3. Create timestamped backup under `.backup_crush_ecc_v4/<timestamp>/`
4. Load or create `.crush.json` (schema: `https://charm.land/crush.json`)
5. Append system blocks (tool-guard → ECC rules → workflow modes → superpowers) using sentinels
6. Add MCP entries (non-destructive)
7. Write `.crush.json` only if content changed
8. Copy skill directories to `~/.config/crush/skills/` (or `$CRUSH_SKILLS_DIR`)

**uninstall.sh flow:** backup → remove MCPs via Python → rename skill dirs with `.removed_by_crush_ecc_v4.<timestamp>` suffix (never deletes).

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

---

## Key Invariants

- **Non-destructive**: Every operation creates a backup before modifying `.crush.json`. Skills are moved aside (not deleted) on uninstall.
- **Idempotent**: Sentinel strings prevent duplicate system blocks. MCP entries are only added if absent. Running install twice is safe.
- **No hardcoded secrets**: MCP templates use placeholder strings. Real tokens must be set by the user.
- **Crush ≠ Claude Code**: Crush uses `view` (not `read`) to open files. The tool-guard system block exists specifically to prevent Claude from hallucinating `read` as a valid tool.
