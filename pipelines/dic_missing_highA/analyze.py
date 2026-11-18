from pathlib import Path
import json,sys,re,csv,math
import numpy as np
ROOT=Path(__file__).resolve().parents[2];WORK=Path(__file__).parent;PUB=ROOT/'outputs/Circuit_Labs_Release/DIC';STAGE=WORK/'staging'
sys.path.insert(0,str(ROOT/'work/aic_next'))
from extract_next import table,measurement,save_csv,isnum
INDEX=json.loads((WORK/'deck_index.json').read_text())
def crossing(t,v,threshold=.5,rise=True,start=0,stop=math.inf):
 for i in range(1,len(t)):
  if t[i]<start or t[i]>stop:continue
  if (v[i-1]<threshold<=v[i])if rise else(v[i-1]>threshold>=v[i]):return float(t[i-1]+(threshold-v[i-1])/(v[i]-v[i-1])*(t[i]-t[i-1]))
 return None
def parse(lab,stem):
 p=STAGE/f'DIC_Lab{lab:02d}_{stem}.lis';s=p.read_text(errors='replace')
 assert 'job concluded'in s.lower()and'**error**'not in s.lower()
 cs=re.split(r'\*{6}  option summary',s)[1:];out=[]
 for idx,c in enumerate(cs):
  r={'case':idx,'measurements':{},'tran':[],'dc':[]}
  for typ in 'st':r['measurements'].update(measurement(p.with_suffix(f'.m{typ}{idx}')))
  for kind,marker,axis in [('dc','dc transfer curves','sweep'),('tran','transient analysis','time_s')]:
   mat=re.search(r'\*{6} '+marker+r'[^\n]*\n',c)
   if mat:
    section=c[mat.end():].split('******')[0]
    r[kind]=data_table(section) if kind=='dc' else table(section,axis)
  out.append(r)
 assert len(out)==len(INDEX[f'Lab{lab:02d}/{stem}']['cases']),(lab,stem,len(out))
 return out
def data_table(s):
 # DATA sweeps may repeat their first parameter; merge table columns by row index,
 # never by that first parameter's value. Every code must remain a distinct row.
 rows=[]
 for mat in re.finditer(r'(?:^|\n)x\s*\n(.*?)\ny(?=\s*\n|$)',s,re.S):
  lines=[l.strip()for l in mat.group(1).splitlines()if l.strip()]
  j=next((j for j,l in enumerate(lines)if all(isnum(t)for t in l.split())),None)
  if j is None:continue
  n=len(lines[j].split())-1;names=lines[1].split()
  if len(names)==n+1:names=names[1:]
  assert len(names)==n
  idx=0
  for line in lines[j:]:
   ts=line.split()
   if len(ts)!=n+1 or not all(isnum(t)for t in ts):continue
   vals=list(map(float,ts))
   if idx>=len(rows):rows.append({'row':idx,'sweep':vals[0]})
   assert rows[idx]['sweep']==vals[0]
   rows[idx].update(zip(['v_'+x for x in names],vals[1:]));idx+=1
 return rows
def values(c,node):return np.array([r['v_'+node]for r in c['tran']])
def times(c):return np.array([r['time_s']for r in c['tran']])
def snapshot(c,t):return min(c['tran'],key=lambda r:abs(r['time_s']-t))
def good(v,expect):return v>=.9 if expect else v<=.1
def run(lab):
 folder=PUB/f'Lab{lab:02d}';dest=folder/'results';dest.mkdir(exist_ok=True);data={};summary={'metrics':[]}
 for deck in sorted(folder.glob('*.sp')):
  cs=parse(lab,deck.stem);data[deck.stem]=cs
  for c in cs:
   rec={'deck':deck.stem,'case':c['case'],**c['measurements']}
   for kind in ['tran','dc']:save_csv(dest/f'{deck.stem}_case{c["case"]}_{kind}.csv',c[kind])
   if lab==20 and deck.stem.startswith('01'):
    t=times(c);vi=values(c,'in');vo=values(c,'n4')
    ri=crossing(t,vi,start=1e-9);fi=crossing(t,vi,rise=False,start=1e-9);ro=crossing(t,vo,start=1e-9);fo=crossing(t,vo,rise=False,start=1e-9)
    rec['rise_delay_ps']=(ro-ri)*1e12 if ri is not None and ro is not None else None;rec['fall_delay_ps']=(fo-fi)*1e12 if fi is not None and fo is not None else None
    for edge,rising in [('rise',True),('fall',False)]:
     a=crossing(t,vo,.1 if rising else .9,rising,1e-9);b=crossing(t,vo,.9 if rising else .1,rising,1e-9);rec[f'{edge}_time_ps']=(b-a)*1e12 if a is not None and b is not None and b>a else None
   if lab==20 and not deck.stem.startswith('01'):
    kind='setup'if deck.stem.startswith('02')else'hold';m=c['measurements'];target=int(m['final_level']if kind=='setup'else m['initial_level'])
    rec['kind']=kind;rec['target']=target;rec['offset_ps']=m['data_offset']*1e12;rec['capture_pass']=good(m['q_capture'],target)and good(m['q_held'],target)
   if lab==22 and deck.stem.startswith('01'):
    checks=[]
    for code in range(64):
     row=snapshot(c,(code+.8)*2e-9);sel=(code>>4)&3;expected=(code>>sel)&1
     checks.append({'code':code,'select':sel,'expected':expected,**{f'output_{p}':row['v_o'+p]for p in 'gcf'},**{f'pass_{p}':good(row['v_o'+p],expected)for p in 'gcf'}})
    save_csv(dest/'truth_table.csv',checks);rec['truth_rows']=len(checks);rec['truth_failures']={p:sum(not x[f'pass_{p}']for x in checks)for p in'gcf'}
   if lab==23 and deck.stem.startswith('01'):
    checks=[]
    for slot,code in enumerate([0,1,2,3,0,1,2,3,0]):
     row=snapshot(c,(slot+.8)*2e-9)
     for p in'nr':checks.append({'slot':slot,'code':code,'type':p,'pass':all(good(row[f'v_{p}{j}'],int(j==code))for j in range(4)),**{f'output{j}':row[f'v_{p}{j}']for j in range(4)}})
    save_csv(dest/f'truth_case{c["case"]}.csv',checks);rec['truth_failures']=sum(not x['pass']for x in checks)
   if lab==23 and deck.stem[:2]in ['02','03']:
    bits=3 if deck.stem.startswith('02') else 8
    prefixes=['o']if bits==3 else['t','h'];checks=[]
    for row in c['dc']:
     code=sum(round(row[f'v_a{b}'])*(1<<b)for b in range(bits))
     for p in prefixes:
      vs=[row[f'v_{p}{j}']for j in range(1<<bits)];checks.append({'code':code,'type':p,'active_V':vs[code],'largest_inactive_V':max(v for j,v in enumerate(vs)if j!=code),'pass':all(good(v,int(j==code))for j,v in enumerate(vs))})
    assert len(c['dc'])==1<<bits,(deck,len(c['dc']))
    assert sorted(set(x['code']for x in checks))==list(range(1<<bits))
    save_csv(dest/f'{deck.stem}_truth.csv',checks);rec['truth_rows']=len(checks);rec['truth_failures']=sum(not x['pass']for x in checks)
   summary['metrics'].append(rec)
 if lab==20:
  bounds=[]
  for kind in ['setup','hold']:
   for target in [0,1]:
    rr=sorted([r for r in summary['metrics']if r.get('kind')==kind and r['target']==target],key=lambda r:r['offset_ps'])
    # First passing point whose entire larger-offset suffix also passes.
    idx=next((i for i in range(len(rr))if all(x['capture_pass']for x in rr[i:])),None)
    bounds.append({'kind':kind,'target':target,'minimum_passing_ps':rr[idx]['offset_ps']if idx is not None else None,'preceding_failing_ps':rr[idx-1]['offset_ps']if idx is not None and idx>0 else None})
  summary['timing_bounds']=bounds
 save_csv(dest/'summary.csv',summary['metrics']);(dest/'summary.json').write_text(json.dumps(summary,indent=2))
 files={}
 for stem,cases in data.items():
  name=stem+'_data.json';(dest/name).write_text(json.dumps(cases,separators=(',',':')));files[stem]=name
 (dest/'simulation_data.json').write_text(json.dumps({'format':'per-deck-json-v1','files':files},indent=2))
 print(lab,json.dumps(summary.get('timing_bounds',{})),[(r['deck'],r.get('truth_failures'))for r in summary['metrics']if'truth_failures'in r]);return data,summary
if __name__=='__main__':
 for lab in [int(x)for x in sys.argv[1:]]or[19,20,22,23]:run(lab)
