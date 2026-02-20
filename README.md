# Crush + Everything Claude Code (ECC) Integration Pack v4.0

**Languages:** [简体中文](README_zh-CN.md) | [繁體中文](README_zh-HK.md) | [日本語](README_ja-JP.md) | [한국어](README_ko-KR.md)

This pack adapts **affaan-m/everything-claude-code** concepts (agents/skills/rules/hooks/MCP configs)
into a **Crush-friendly** setup.

Because Crush and Claude Code have different extension formats, this pack focuses on what Crush can
use directly today:
- **Project `.crush.json` system guard + context rules** (merged, non-destructive)
- **Crush skills** (curated ECC skills converted into `~/.config/crush/skills/<name>/SKILL.md`)
- **Snippets** for optional per-project docs (`AGENTS.md`, `CONVENTIONS.md`) you can copy in

## What you get

### A) Project-level `.crush.json` enhancements (merged safely)
- Tool whitelist + anti-hallucination notes (prevents `tool not found: read`)
- Context optimization checklist (small, high-signal)
- Optional "workflow modes" (plan / build / review)

### B) Global Crush skills (curated from ECC ideas)
Installed into your Crush skills directory (default `~/.config/crush/skills`):
- `ecc-planner` (implementation planning template)
- `ecc-tdd` (TDD workflow + test-first checklist)
- `ecc-code-review` (quality gates, style, security basics)
- `ecc-security-review` (OWASP-ish sanity checks + dependency checks)
- `ecc-deployment` (CI/CD, rollback, health checks, release checklist)
- `ecc-docker` (docker compose patterns, networking, volumes, security)
- `ecc-api-design` (REST pagination/errors/idempotency)
- `ecc-cost-aware-llm` (budget routing, cost logging, token discipline)

> These are intentionally compact. The upstream repo is huge; this pack focuses on the pieces that
translate well to Crush’s workflow.

### C) Optional snippets (no auto-edit)
- `.snippets/AGENTS.md.snippet.md`
- `.snippets/CONVENTIONS.md.snippet.md`

## Quick Start

### Using Make (recommended)

```bash
make install            # Core ECC skills + rules
make install-guard      # ECC + tool-guard (recommended)
make install-full       # ECC + tool-guard + Superpowers + common MCPs
make dry-run            # Preview only, no changes
make uninstall          # Safe uninstall (backs up first)
```

### Direct script invocation

Scripts in `deploy/` use numbered prefixes for easy discovery:

```bash
# Core install (auto-detects repo root)
bash deploy/client-run-001-install.sh --ecc
bash deploy/client-run-001-install.sh --ecc --tool-guard
bash deploy/client-run-001-install.sh --ecc --tool-guard --dry-run

# Uninstall
bash deploy/client-run-002-uninstall.sh
```

Uninstall removes only the specific keys/skills this pack added (backs up first).

---

## Notes on upstream ECC
- Upstream: https://github.com/affaan-m/everything-claude-code (MIT)
- This pack is **not** a full copy of upstream; it is a Crush-oriented adaptation.

---

## v4.1: Optional MCP installs (ECC mcp-configs → Crush MCP)

This pack now includes a curated port of `mcp-configs/mcp-servers.json` from Everything Claude Code into
Crush’s `.crush.json` `mcp` section.

Install examples:
```bash
make mcp-common         # github + supabase + vercel + context7 + filesystem
make mcp-github
make list-mcp           # show all available MCP names

# or directly:
bash deploy/client-run-001-install.sh --mcp-github
bash deploy/client-run-001-install.sh --mcp-common
bash deploy/client-run-004-list-mcp.sh
```

Non-destructive behavior:
- If `mcp.<name>` already exists in `.crush.json`, installer will **not overwrite** it.
- A backup of `.crush.json` is written before changes.

Templates:
- `mcp-configs/ecc-mcp-servers.crush.json`

---

## v4.2: Superpowers (obra/superpowers) skill port for Crush (optional)

This pack now includes an **optional** port of key Superpowers skills (MIT) adapted for Crush:
- sp-brainstorming
- sp-git-worktrees
- sp-writing-plans
- sp-tdd
- sp-subagent-dev
- sp-executing-plans
- sp-request-code-review
- sp-finish-branch

Install:
```bash
make install-superpowers

# or directly:
bash deploy/client-run-001-install.sh --superpowers
```

Combined:
```bash
make install-full

# or directly:
bash deploy/client-run-001-install.sh --ecc --tool-guard --superpowers --mcp-common
```

Attribution: see `superpowers/ATTRIBUTION.md`.
