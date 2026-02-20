# ECC MCP Configs (ported for Crush)

Upstream (Claude Code format):
- `mcp-configs/mcp-servers.json`

This pack stores **Crush-ready templates** in:
- `ecc-mcp-servers.crush.json`

## Install into a repo
```bash
bash deploy/install.sh --mcp-github
bash deploy/install.sh --mcp-supabase
bash deploy/install.sh --mcp-vercel
bash deploy/install.sh --mcp-common
```

## Important
- Installer will NOT overwrite existing `mcp.<name>` entries in `.crush.json`.
- Replace placeholder values like `YOUR_*_HERE`.
- Keep MCP count low (<= 10) to reduce tool-description token overhead.
