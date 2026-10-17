"""Summarize actual HSPICE listings without treating execution as spec pass."""
from pathlib import Path
import argparse
import hashlib
import json
import re

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("directory", type=Path)
parser.add_argument("--output", type=Path, required=True)
args = parser.parse_args()
records = []
for deck in sorted(args.directory.glob("*.sp")):
    listing = deck.with_suffix(".lis")
    text = listing.read_text(encoding="utf-8", errors="replace") if listing.is_file() else ""
    errors = re.findall(r"(?im)^.*\*\*\s*error\s*\*\*.*$", text)
    warnings = re.findall(r"(?im)^.*\*\*\s*warning\s*\*\*.*$", text)
    failed = re.findall(r"(?im)^.*(?:measure.*fail|=\s*failed|job aborted).*$", text)
    ended = bool(re.search(r"job concluded|job ended", text, re.I))
    status = "missing" if not text else "error" if errors or "job aborted" in text.lower() else "completed" if ended else "incomplete"
    records.append({
        "deck": deck.name,
        "deck_sha256": hashlib.sha256(deck.read_bytes()).hexdigest(),
        "execution_status": status,
        "errors": errors,
        "warnings": warnings,
        "failed_measurements": failed,
        "specification_status": "See per-lab spec matrix; execution success alone is insufficient.",
    })
args.output.parent.mkdir(parents=True, exist_ok=True)
args.output.write_text(json.dumps(records, ensure_ascii=False, indent=2), encoding="utf-8")
print(json.dumps({"total": len(records), "completed": sum(r["execution_status"] == "completed" for r in records), "failed_measurement_decks": sum(bool(r["failed_measurements"]) for r in records)}))
