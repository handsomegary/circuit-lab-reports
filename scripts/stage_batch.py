"""Stage the lab netlists in a new directory for simulation.

Public netlists contain a MODEL_SETUP_REQUIRED comment instead of model paths.
Supply a local model file at execution time. Circuit statements are preserved.
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
parser.add_argument("--labs", nargs="+", help="Limit selection, e.g. DIC/Lab05 AIC/Lab02")
parser.add_argument("--model", type=Path, required=True, help="Local flat model library")
parser.add_argument("--corner-model", type=Path, help="Local library with named sections for the corner lab")
args = parser.parse_args()
root = args.root.resolve()
dest = args.destination.resolve()
model = args.model.resolve() if args.model else None
corner_model = args.corner_model.resolve() if args.corner_model else None
if model is not None and not model.is_file():
    raise SystemExit("The supplied local model library does not exist.")
available = {f"{group}/{lab.name}": lab for group in ("DIC", "AIC")
             for lab in sorted((root / group).glob("Lab[0-9][0-9]")) if lab.is_dir()}
selected = args.labs or sorted(available)
unknown = sorted(set(selected) - available.keys())
if unknown:
    raise SystemExit("Unknown lab selection: " + ", ".join(unknown))
dest.mkdir(parents=True, exist_ok=True)
if any(dest.glob("*.sp")):
    raise SystemExit("Destination already contains .sp files; use a fresh staging directory.")

marker = re.compile(r"^\* MODEL_SETUP_REQUIRED(?:[ \t]+([A-Za-z0-9_]+))?[ \t]*$", re.I | re.M)
records = []
pending = []
for selection in dict.fromkeys(selected):
    group, lab = selection.split("/")
    for source in sorted(available[selection].glob("*.sp")):
        text = source.read_text(encoding="utf-8-sig")
        def resolve(match):
            section = match[1]
            dependency = corner_model if section else model
            if dependency is None or not dependency.is_file():
                raise FileNotFoundError("A required local model library was not supplied.")
            if "'" in str(dependency):
                raise ValueError("A model path cannot contain a single quote.")
            directive = ".lib" if section else ".include"
            suffix = " " + section if section else ""
            return directive + " '" + dependency.as_posix() + "'" + suffix
        staged_text, marker_count = marker.subn(resolve, text)
        if marker_count == 0:
            raise ValueError(f"No model setup marker: {source.relative_to(root)}")
        target = dest / f"{group}_{lab}_{source.name}"
        staged_text.encode("ascii")
        pending.append((target, staged_text))
        records.append({
            "source": str(source.relative_to(root)).replace("\\", "/"),
            "staged": target.name,
            "source_sha256": hashlib.sha256(source.read_bytes()).hexdigest(),
            "transformation": "insert local model configuration at marked comments",
        })
if not records:
    raise SystemExit("No lab testbenches found.")
for (target, staged_text), record in zip(pending, records):
    target.write_text(staged_text, encoding="ascii")
    record["staged_sha256"] = hashlib.sha256(target.read_bytes()).hexdigest()
(dest / "staging_manifest.json").write_text(json.dumps(records, indent=2), encoding="utf-8")
print(f"Staged {len(records)} netlists in {dest}")
