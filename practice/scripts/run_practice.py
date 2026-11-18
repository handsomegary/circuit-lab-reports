"""Stage and run the practice decks with a locally supplied model library.

    python run_practice.py RUN_DIRECTORY --model LOCAL_MODEL --simulator HSPICE_EXECUTABLE

Each deck's `* MODEL_SETUP_REQUIRED` comment is replaced by an `.include` of the
local model in the staged copy only. Outputs are written as RUN_DIRECTORY/<deck>.*
Keep RUN_DIRECTORY outside the repository; do not commit staged copies or waveforms.
"""
from pathlib import Path
import argparse
import hashlib
import json
import re
import subprocess

ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
ap.add_argument("destination", type=Path)
ap.add_argument("--model", type=Path, required=True)
ap.add_argument("--simulator", default="hspice")
ap.add_argument("--timeout", type=int, default=900)
a = ap.parse_args()

root = Path(__file__).resolve().parents[1]
dest = a.destination.resolve()
model = a.model.resolve()
if not model.is_file():
    raise SystemExit("The supplied local model library does not exist.")
if "'" in str(model):
    raise SystemExit("A model path cannot contain a single quote.")
dest.mkdir(parents=True, exist_ok=True)
if any(dest.glob("*.sp")):
    raise SystemExit("Destination already contains .sp files; use a fresh run directory.")

marker = re.compile(r"^\* MODEL_SETUP_REQUIRED[ \t]*$", re.M)
records = []
for deck in sorted(root.glob("0*/*.sp")):
    text = deck.read_text(encoding="utf-8")
    staged, count = marker.subn(".include '" + model.as_posix() + "'", text)
    if count != 1:
        raise SystemExit(f"Expected one model marker in {deck.name}")
    target = dest / deck.name
    target.write_text(staged, encoding="utf-8")
    proc = subprocess.run([a.simulator, "-i", target.name, "-o", target.stem], cwd=dest,
                          capture_output=True, text=True, timeout=a.timeout)
    lis = (dest / (target.stem + ".lis")).read_text(errors="replace")
    records.append({
        "deck": deck.relative_to(root).as_posix(),
        "source_sha256": hashlib.sha256(deck.read_bytes()).hexdigest(),
        "exit_code": proc.returncode,
        "concluded": "job concluded" in lis,
        "errors": lis.lower().count("**error**"),
    })
    print(f"{deck.name}: concluded={records[-1]['concluded']} errors={records[-1]['errors']}")
(dest / "run_manifest.json").write_text(json.dumps(records, indent=2), encoding="utf-8")
