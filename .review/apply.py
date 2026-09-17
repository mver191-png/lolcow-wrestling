"""One-time verified source handoff; removed after successful branch materialization."""
import base64
import hashlib
import json
import lzma
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
EXPECTED = "3376825f0d2a52844560affbc71e38234f5b475954783c0b9d21a76eb4677f3b"
parts = [ROOT / ".review" / ("payload-%02d.b64" % i) for i in range(4)]
raw = base64.b64decode("".join(p.read_text().strip() for p in parts), validate=True)
if hashlib.sha256(raw).hexdigest() != EXPECTED:
    raise SystemExit("Transport checksum mismatch; no source was modified")
packet = json.loads(lzma.decompress(raw))
if packet["base"] != "2307d013405ed3388b404b1b9ff29a7fd2c99cfb":
    raise SystemExit("Unexpected source base")
allowed_roots = {"scripts", "scenes", "tests", "tools", "blender", "docs"}
allowed_files = {".gitignore", "CODEBASE_FOR_GPT_PRO.md", "KNOWN_ISSUES.md", "NEXT_TASK.md", "README.md", "REVIEW.md", "START_GAME.bat", "STATE.md"}
prepared = {}
for name, entry in packet["entries"].items():
    relative = Path(name)
    if relative.is_absolute() or ".." in relative.parts:
        raise SystemExit("Unsafe source path")
    if relative.parts[0] not in allowed_roots and name not in allowed_files:
        raise SystemExit("Unexpected source path: " + name)
    path = ROOT / relative
    if not path.resolve().is_relative_to(ROOT):
        raise SystemExit("Source path escaped checkout")
    if "text" in entry:
        text = entry["text"]
    else:
        old = path.read_text().replace("\r\n", "\n")
        if hashlib.sha256(old.encode()).hexdigest() != entry["base_sha256"]:
            raise SystemExit("Concurrent/baseline source change: " + name)
        lines = old.splitlines(keepends=True)
        for first, last, replacement in reversed(entry["edits"]):
            if not 0 <= first <= last <= len(lines):
                raise SystemExit("Invalid source patch range: " + name)
            lines[first:last] = [replacement]
        text = "".join(lines)
    if hashlib.sha256(text.encode()).hexdigest() != entry["sha256"]:
        raise SystemExit("Resulting source checksum mismatch: " + name)
    prepared[path] = text
for path, text in prepared.items():
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(text)
    print("VERIFIED_SOURCE", path.relative_to(ROOT), hashlib.sha256(text.encode()).hexdigest())
print("Verified and materialized", len(prepared), "source files")
