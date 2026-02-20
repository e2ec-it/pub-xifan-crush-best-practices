import json
import pathlib
from typing import Any, Dict, Tuple

SENTINEL = "There is NO tool named `read`."
ECC_SENTINEL = "ECC-style context discipline (compact):"

def load_or_new(path: pathlib.Path) -> Dict[str, Any]:
    if path.exists():
        return json.loads(path.read_text(encoding="utf-8"))
    return {"$schema": "https://charm.land/crush.json"}

def dump(obj: Dict[str, Any]) -> str:
    return json.dumps(obj, ensure_ascii=False, indent=2) + "\n"

def append_system(obj: Dict[str, Any], block: str, sentinel: str) -> Tuple[Dict[str, Any], bool]:
    sysv = obj.get("system", "")
    if isinstance(sysv, str) and sentinel in sysv:
        return obj, False
    if isinstance(sysv, str) and sysv.strip():
        obj["system"] = sysv.rstrip() + "\n\n" + block.strip() + "\n"
        return obj, True
    obj["system"] = block.strip() + "\n"
    return obj, True

def ensure_meta(obj: Dict[str, Any]) -> Dict[str, Any]:
    # Lightweight marker so uninstall can remove only what we add (in-place safe removal is hard for system blocks)
    meta = obj.get("_pack")
    if not isinstance(meta, dict):
        obj["_pack"] = {}
        meta = obj["_pack"]
    meta.setdefault("installed", [])
    return obj

def add_pack_marker(obj: Dict[str, Any], marker: str) -> Dict[str, Any]:
    obj = ensure_meta(obj)
    installed = obj["_pack"]["installed"]
    if marker not in installed:
        installed.append(marker)
    return obj
