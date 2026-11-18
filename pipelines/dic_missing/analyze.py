from pathlib import Path
import re,json,csv,sys,hashlib
import numpy as np
ROOT=Path(__file__).resolve().parents[2]
SIM=ROOT/'work'/'dic_missing'/'sim'
OUT=ROOT/'outputs'/'Circuit_Labs_Release'/'DIC'
NUM=re.compile(r'^[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?[a-zA-Z]?$')
def val(s):
 if isinstance(s,(int,float)):return float(s)
 scales=dict(t=1e12,g=1e9,x=1e6,k=1e3,m=1e-3,u=1e-6,n=1e-9,p=1e-12,f=1e-15,a=1e-18)
 return float(s[:-1])*scales[s[-1].lower()] if s[-1].isalpha() else float(s)
def meas(p):
 names=[];data=[];active=False
 for l in p.read_text().splitlines():
  if not l.strip() or l.lstrip().startswith(('$','.')):continue
  ts=l.split()
  if all(NUM.fullmatch(t) for t in ts):active=True
  (data if active else names).extend(ts)
 assert names and len(data)==len(names),(p,names,data)
 return dict(zip(names,map(val,data)))
def tables(p):
 ls=p.read_text(errors='replace').splitlines();res=[];i=0
 while i<len(ls):
  ts=ls[i].split()
  if ts and ts[0] in ['time','volt','freq'] and all(t in ['voltage','current','vth','imag'] for t in ts[1:]):
   typ=ts[0];names=ls[i+1].split();i+=2;rows=[]
   while i<len(ls):
    a=ls[i].split()
    if len(a)!=len(names)+1 or not all(NUM.fullmatch(t) for t in a):break
    rows.append(list(map(val,a)));i+=1
   if len(rows)>10:res.append(dict(kind=typ,names=names,values=np.array(rows)))
  else:i+=1
 groups=[]
 for t in res:
  a=t['values'];typ=t['kind'];names=t['names']
  if groups and groups[-1]['kind']==typ and not set(names)&set(groups[-1]['data']) and len(a)==len(groups[-1]['x']) and np.allclose(a[:,0],groups[-1]['x'],rtol=1e-8,atol=1e-20):g=groups[-1]
  else:g=dict(kind=typ,x=a[:,0],data={});groups.append(g)
  g['data'].update({n:a[:,k+1] for k,n in enumerate(names)})
 return groups
def save(p,rows):
 p.parent.mkdir(exist_ok=True,parents=True)
 if not rows:return
 with p.open('w',newline='',encoding='utf-8') as f:
  w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
def export(labs):
 for lab in labs:
  folder=OUT/f'Lab{lab:02d}';out=folder/'results';out.mkdir(exist_ok=True)
  manifest=json.loads((folder/'spec_manifest.json').read_text())
  summary={}
  for d in manifest['decks']:
   stem=Path(d['netlist']).stem;q=SIM/f'DIC_Lab{lab:02d}_{stem}'
   txt=q.with_suffix('.lis').read_text(errors='replace');n=txt.lower().count('job concluded')
   assert n==len(d['cases']) and '**error**' not in txt.lower() and 'failed' not in txt.lower(),(lab,stem,n)
   rows=[]
   for k,c in enumerate(d['cases']):
    candidates=[q.with_suffix(f'.{typ}{k}') for typ in ['mt','ms','ma']]
    available=[p for p in candidates if p.exists()];assert len(available)==1,(q,k,available)
    rows.append(dict(case_index=k,**c,**meas(available[0])))
   save(out/f'{stem}_measurements.csv',rows)
   groups=tables(q.with_suffix('.lis'))
   # Retain representative sampled waveforms; every case retains its direct measurements.
   if groups:
    assert len(groups)==len(d['cases']),(q,len(groups),len(d['cases']))
    chosen=sorted(set([0,len(groups)-1]+list(range(0,len(groups),max(1,len(groups)//5)))))
    for k in chosen:
     g=groups[k];indices=np.unique(np.linspace(0,len(g['x'])-1,min(2501,len(g['x']))).astype(int))
     xn={'time':'time_s','volt':'sweep_V','freq':'frequency_Hz'}[g['kind']]
     save(out/f'{stem}_waveform_{k:03d}.csv',[dict([(xn,float(g['x'][i]))]+[(n,float(v[i])) for n,v in g['data'].items()]) for i in indices])
   else:chosen=[]
   summary[stem]=dict(completed=n,errors=0,measurement_failures=0,source_sha256=hashlib.sha256((folder/d['netlist']).read_bytes()).hexdigest(),cases=rows,waveform_case_indices=chosen)
  (out/'metrics.json').write_text(json.dumps(summary,indent=2))
  print(lab,{k:v['completed'] for k,v in summary.items()})
if __name__=='__main__':export(list(map(int,sys.argv[1:])) or [4,7,10,11,13])
