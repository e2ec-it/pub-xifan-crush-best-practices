import json
import pathlib
from typing import Any, Dict, Tuple

def load_or_new(path: pathlib.Path) -> Dict[str, Any]:
    if path.exists():
        return json.loads(path.read_text(encoding="utf-8"))
    return {"$schema": "https://charm.land/crush.json"}

def dump(obj: Dict[str, Any]) -> str:
    return json.dumps(obj, ensure_ascii=False, indent=2) + "\n"

def ensure_mcp_dict(obj: Dict[str, Any]) -> Dict[str, Any]:
    if not isinstance(obj.get("mcp"), dict):
        obj["mcp"] = {}
    return obj

def add_mcp_if_absent(obj: Dict[str, Any], name: str, entry: Dict[str, Any]) -> Tuple[Dict[str, Any], bool]:
    ensure_mcp_dict(obj)
    if name in obj["mcp"] and isinstance(obj["mcp"][name], dict):
        return obj, False
    obj["mcp"][name] = entry
    return obj, True

def remove_mcp(obj: Dict[str, Any], name: str) -> Tuple[Dict[str, Any], bool]:
    mcp = obj.get("mcp")
    if not isinstance(mcp, dict) or name not in mcp:
        return obj, False
    del mcp[name]
    return obj, True
