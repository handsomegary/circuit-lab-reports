"""Stage the lab netlists in a new directory for simulation.

Relative .include/.inc paths are resolved to absolute paths. Circuit statements
are preserved. Supply the model library locally before running this utility.
Generated files belong in a local work directory, not the repository.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("destination", type=Path)
parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
args = parser.parse_args()
root = args.root.resolve()
dest = args.destination.resolve()
dest.mkdir(parents=True, exist_ok=True)
if any(dest.glob("*.sp")):
    raise SystemExit("Destination already contains .sp files; use a fresh staging directory.")

include = re.compile(r"^(\s*\.(?:include|inc)\s+)(['\"])([^'\"]+)\2", re.I | re.M)
records = []
for group, lab in [("DIC", "Lab01"), ("DIC", "Lab02"), ("AIC", "Lab01")]:
    for source in sorted((root / group / lab).glob("*.sp")):
        text = source.read_text(encoding="utf-8-sig")
        def resolve(match):
            dependency = Path(match[3])
            if not dependency.is_absolute():
                dependency = (source.parent / dependency).resolve()
            if not dependency.is_file():
                raise FileNotFoundError(f"{source}: {dependency}")
            return match[1] + match[2] + str(dependency) + match[2]
        staged_text = include.sub(resolve, text)
        target = dest / f"{group}_{lab}_{source.name}"
        target.write_text(staged_text, encoding="ascii")
        records.append({
            "source": str(source.relative_to(root)).replace("\\", "/"),
            "staged": target.name,
            "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
            "staged_sha256": hashlib.sha256(target.read_bytes()).hexdigest(),
            "transformation": "resolve include paths only",
        })
if not records:
    raise SystemExit("No preview testbenches found.")
(dest / "staging_manifest.json").write_text(json.dumps(records, indent=2), encoding="utf-8")
print(f"Staged {len(records)} netlists in {dest}")
