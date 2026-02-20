#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
python3 - <<PY
import json, pathlib
p = pathlib.Path("$ROOT") / "mcp-configs" / "ecc-mcp-servers.crush.json"
data = json.loads(p.read_text(encoding="utf-8"))
print("Available MCP names:")
for k in sorted(data.keys()):
    print(" -", k)
PY
