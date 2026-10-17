"""Run privately staged SPICE decks and save simulator output beside each deck."""
from pathlib import Path
import argparse
import concurrent.futures
import hashlib
import json
import re
import subprocess
import time

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument('directory',type=Path)
parser.add_argument('--simulator',default='hspice',help='Installed simulator executable')
parser.add_argument('--workers',type=int,default=2)
parser.add_argument('--timeout',type=int,default=600)
args=parser.parse_args()
directory=args.directory.resolve()
decks=sorted(directory.glob('*.sp'))
if not decks: raise SystemExit('No staged netlists found.')
if args.workers<1: raise SystemExit('Worker count must be positive.')
for deck in decks:
    if re.search(r'^\* MODEL_SETUP_REQUIRED',deck.read_text(),re.M):
        raise SystemExit('Stage local model configuration before running the batch.')

def run(deck):
    start=time.monotonic()
    prefix=deck.with_suffix('')
    try:
        process=subprocess.run([args.simulator,'-i',str(deck),'-o',str(prefix)],
            cwd=directory,capture_output=True,timeout=args.timeout,
            creationflags=getattr(subprocess,'CREATE_NO_WINDOW',0))
        prefix.with_suffix('.console.txt').write_bytes(process.stdout+process.stderr)
        code=process.returncode
    except subprocess.TimeoutExpired as error:
        prefix.with_suffix('.console.txt').write_bytes((error.stdout or b'')+(error.stderr or b''))
        code='timeout'
    listing=prefix.with_suffix('.lis')
    text=listing.read_text(errors='replace') if listing.exists() else ''
    errors=len(re.findall(r'\*\*\s*error\s*\*\*',text,re.I))
    failed=len(re.findall(r'(?im)^.*(?:=\s*failed|measure.*fail|job aborted).*$',text))
    cases=text.lower().count('job concluded')
    record={'deck':deck.name,'staged_sha256':hashlib.sha256(deck.read_bytes()).hexdigest(),
        'return_code':code,'seconds':round(time.monotonic()-start,2),
        'concluded_cases':cases,'visible_error_count':errors,'failed_measurement_count':failed,
        'completed':code==0 and cases>0 and not errors and not failed}
    prefix.with_suffix('.execution.json').write_text(json.dumps(record,indent=2)+'\n')
    print(json.dumps(record),flush=True)
    return record

with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:
    records=list(pool.map(run,decks))
(directory/'batch_execution.json').write_text(json.dumps(records,indent=2)+'\n')
if not all(r['completed'] for r in records): raise SystemExit(1)
