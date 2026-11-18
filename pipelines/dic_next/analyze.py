from pathlib import Path
import re,json,csv,sys
import numpy as np
ROOT=Path(__file__).resolve().parents[2]
SIM=ROOT/'work'/'dic_next'/'sim'
OUT=ROOT/'outputs'/'Circuit_Labs_Release'/'DIC'
NUM=re.compile(r'^[+-]?(?:\d+(?:\.\d*)?|\.\d+)(?:[eE][+-]?\d+)?[a-zA-Z]?$')
def val(s):
    scales=dict(t=1e12,g=1e9,x=1e6,k=1e3,m=1e-3,u=1e-6,n=1e-9,p=1e-12,f=1e-15,a=1e-18)
    return float(s[:-1])*scales[s[-1].lower()] if s[-1].isalpha() else float(s)
def meas(p):
    names=[];data=[];active=False
    for l in p.read_text().splitlines():
        if not l.strip() or l.lstrip().startswith(('$','.')):continue
        ts=l.split()
        if all(NUM.fullmatch(t) for t in ts):active=True
        (data if active else names).extend(ts)
    assert names and len(data)%len(names)==0,p
    return [dict(zip(names,map(val,data[i:i+len(names)]))) for i in range(0,len(data),len(names))]
def tables(p):
    ls=p.read_text(errors='replace').splitlines();res=[];i=0
    while i<len(ls):
        ts=ls[i].split()
        if ts and ts[0] in ['time','volt'] and all(t=='voltage' for t in ts[1:]):
            typ=ts[0];names=ls[i+1].split();i+=2;rows=[]
            while i<len(ls):
                a=ls[i].split()
                if len(a)!=len(names)+1 or not all(NUM.fullmatch(t) for t in a):break
                rows.append(list(map(val,a)));i+=1
            if len(rows)>10:res.append(dict(kind=typ,names=names,values=np.array(rows)))
        else:i+=1
    # Each print group may wrap into blocks. Recombine by repeated variable/case.
    groups=[]
    for t in res:
        a=t['values']; typ=t['kind']; names=t['names']
        if groups and groups[-1]['kind']==typ and not set(names)&set(groups[-1]['data']) and len(a)==len(groups[-1]['x']) and np.allclose(a[:,0],groups[-1]['x'],rtol=1e-8,atol=1e-20):
            g=groups[-1]
        else:
            g=dict(kind=typ,x=a[:,0],data={});groups.append(g)
        g['data'].update({n:a[:,k+1] for k,n in enumerate(names)})
    return groups
def save(path,rows):
    path.parent.mkdir(exist_ok=True,parents=True)
    if not rows:return
    with path.open('w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
def crossing(x,y,target):
    ii=np.where((y[:-1]-target)*(y[1:]-target)<=0)[0]
    return [float(x[i]+(target-y[i])*(x[i+1]-x[i])/(y[i+1]-y[i])) for i in ii if y[i+1]!=y[i]]
def vtc(x,y):
    if x[-1]<x[0]:x=x[::-1];y=y[::-1]
    slope=np.gradient(y,x)
    pts=crossing(x,slope,-1); vm=crossing(x,y,.5)
    if len(pts)!=2: return dict(VM_V=vm[0] if vm else None,unity_gain_crossings=len(pts))
    vl,vh=pts;voh=float(np.interp(vl,x,y));vol=float(np.interp(vh,x,y))
    return dict(VM_V=vm[0],VIL_V=vl,VIH_V=vh,VOH_boundary_V=voh,VOL_boundary_V=vol,NML_boundary_V=vl-vol,NMH_boundary_V=voh-vh,NML_rail_V=vl,NMH_rail_V=1-vh)
def export(labs):
    for lab in labs:
        out=OUT/f'Lab{lab:02d}'/'results';out.mkdir(exist_ok=True,parents=True)
        summary={};vtcs=[]
        for deck in sorted((out.parent).glob('*.sp')):
            stem=SIM/f'DIC_Lab{lab:02d}_{deck.stem}'
            if not stem.with_suffix('.lis').exists():continue
            text=stem.with_suffix('.lis').read_text(errors='replace')
            info=dict(completed=text.lower().count('job concluded'),errors=text.lower().count('**error**'),failed=text.lower().count('failed'))
            assert info['completed'] and not(info['errors'] or info['failed']), (deck,info)
            groups=tables(stem.with_suffix('.lis'));counts={}
            for g in groups:
                k=g['kind'];case=counts.get(k,0);counts[k]=case+1
                xname='time_s' if k=='time' else 'sweep_V'
                rows=[dict([(xname,float(g['x'][i]))]+[(n,float(v[i])) for n,v in g['data'].items()]) for i in range(len(g['x']))]
                save(out/f'{deck.stem}_{k}_{case}.csv',rows)
                if k=='volt' and lab in [8,9]:
                    for n,y in g['data'].items():
                        if n!='in':vtcs.append(dict(deck=deck.stem,case=case,node=n,**vtc(g['x'],y)))
            info['measurements']={}
            for typ in ['mt','ms']:
                for p in sorted(SIM.glob(stem.name+'.'+typ+'*')):
                    rs=meas(p); info['measurements'][p.suffix[1:]]=rs
                    save(out/f'{deck.stem}_{p.suffix[1:]}.csv',rs)
            summary[deck.stem]=info
        if vtcs:save(out/'noise_margins.csv',vtcs)
        (out/'metrics.json').write_text(json.dumps(summary,indent=2))
        print(lab,{k:(v['completed'],list(v['measurements'])) for k,v in summary.items()})
if __name__=='__main__':export(list(map(int,sys.argv[1:])) or [5,6,8,9,12,14])
