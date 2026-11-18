from pathlib import Path
import subprocess,concurrent.futures,json,sys
root=Path('outputs/Circuit_Labs_Release/reports').resolve()
import os
exe=os.environ.get('XELATEX','xelatex')
projects=[p.parent for p in root.glob('*/*/main.tex') if (p.parent/'body.tex').exists()]
if len(sys.argv)>1:
 projects=[p for p in projects if p.parent.name in sys.argv[1:]]
def compile(p):
 pdf=p/'main.pdf'
 inputs=[q for q in p.rglob('*') if q.is_file() and (q.suffix=='.tex' or q.parent.name=='figures')]
 if pdf.exists() and all(q.stat().st_mtime<=pdf.stat().st_mtime for q in inputs):
  return {'project':str(p.relative_to(root)),'code':0,'status':'already_current','bytes':pdf.stat().st_size}
 for i in range(2):
  r=subprocess.run([exe,'--disable-installer','-no-shell-escape','-interaction=nonstopmode','-halt-on-error','main.tex'],cwd=p,capture_output=True,timeout=120)
  (p/'build.log').write_bytes(r.stdout+r.stderr)
  if r.returncode: return {'project':str(p.relative_to(root)),'code':r.returncode,'tail':(r.stdout+r.stderr).decode('utf8',errors='replace')[-2500:]}
 return {'project':str(p.relative_to(root)),'code':0,'bytes':(p/'main.pdf').stat().st_size}
with concurrent.futures.ThreadPoolExecutor(max_workers=2) as pool:
 for result in pool.map(compile,projects): print(json.dumps(result,ensure_ascii=False),flush=True)
