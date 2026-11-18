from pathlib import Path
import re,json,csv,sys,math
ROOT=Path(__file__).resolve().parents[2]
STAGE=ROOT/'work/aic_next/staging'
PUB=ROOT/'outputs/Circuit_Labs_Release/AIC'
NUM=r'[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?'
def isnum(s):return re.fullmatch(NUM,s) is not None
def measurement(p):
    if not p.exists():return {}
    tokens=' '.join(s for s in p.read_text().splitlines() if not s.startswith(('$','.'))).split()
    n=next((i for i,x in enumerate(tokens) if isnum(x) or x=='failed'),len(tokens))
    return {k:(float(v) if isnum(v) else None) for k,v in zip(tokens[:n],tokens[n:])}
def table(s,axis):
    rows={}
    for mat in re.finditer(r'(?:^|\n)x\s*\n(.*?)\ny(?=\s*\n|$)',s,re.S):
        lines=[l.strip() for l in mat.group(1).splitlines() if l.strip()]
        j=next((j for j,l in enumerate(lines) if all(isnum(t) for t in l.split())),None)
        if j is None:continue
        n=len(lines[j].split())-1
        names=lines[1].split();types=re.split(r'\s{2,}',lines[0])[1:]
        if len(names)==n+1:names=names[1:]
        if len(names)!=n:raise ValueError(('table columns',names,n))
        if len(types)!=n:types=['value']*n
        prefixes={'voltage':'v','current':'i','volt db':'db','volt phase':'phase','voltage m':'mag','current m':'imag','i mag':'imag','current db':'idb','current phase':'iphase'}
        cols=[prefixes.get(t,'value')+'_'+name for t,name in zip(types,names)]
        for l in lines[j:]:
            ts=l.split()
            if len(ts)!=n+1 or not all(isnum(t) for t in ts):continue
            vs=list(map(float,ts));row=rows.setdefault(vs[0],{axis:vs[0]});row.update(zip(cols,vs[1:]))
    return list(rows.values())
def parse(lab,stem):
    p=STAGE/f'AIC_Lab{lab:02d}_{stem}.lis';s=p.read_text(errors='replace')
    if '**error**' in s.lower() or 'job concluded' not in s.lower():raise ValueError('Run not successful: '+stem)
    chunks=re.split(r'\*{6}  option summary',s)[1:]
    data=[]
    for idx,c in enumerate(chunks):
        result={'case':idx,'dc':[],'ac':[],'tran':[],'op':{},'nodes':{},'measurements':{}}
        for kind,marker,axis in [('dc','dc transfer curves','sweep'),('ac','ac analysis','frequency_Hz'),('tran','transient analysis','time_s')]:
            m=re.search(r'\*{6} '+marker+r'[^\n]*\n',c)
            if m:
                part=c[m.end():].split('******')[0]
                result[kind]=table(part,axis)
        op=c.split('****** operating point information')[-1].split('******')[1:] if False else c
        for m in re.finditer(r'\n element\s+([^\n]+)\n model\s+([^\n]+)\n region\s+([^\n]+)\n(.*?)(?=\n\s*\n|$)',op,re.S):
            names=[x.split(':',1)[-1] for x in m.group(1).split()]
            for name,reg in zip(names,m.group(3).split()):result['op'][name]={'region':reg}
            for line in m.group(4).splitlines():
                ts=line.split()
                if len(ts)==len(names)+1 and all(isnum(v) for v in ts[1:]):
                    for name,v in zip(names,ts[1:]):result['op'][name][ts[0]]=float(v)
        for m in re.finditer(r'\b\d+:([\w.]+)\s*=\s*('+NUM+')',c):result['nodes'][m.group(1)]=float(m.group(2))
        for typ in ('s','a','t'):
            result['measurements'].update(measurement(p.with_suffix(f'.m{typ}{idx}')))
        m=re.search(r'output resistance at[^\n=]*=\s*('+NUM+')',c)
        if m:result['rout_tf_ohm']=float(m.group(1))
        data.append(result)
    return data
def save_csv(p,rows):
    if not rows:return
    with p.open('w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=list(dict.fromkeys(k for r in rows for k in r)));w.writeheader();w.writerows(rows)
def export(lab):
    folder=PUB/f'Lab{lab:02d}';out=folder/'results';out.mkdir(exist_ok=True)
    all_data={};summary=[];ops=[]
    for deck in sorted(folder.glob('*.sp')):
        cases=parse(lab,deck.stem);all_data[deck.stem]=cases
        for c in cases:
            for kind in ('dc','ac','tran'):save_csv(out/f'{deck.stem}_case{c["case"]}_{kind}.csv',c[kind])
            summary.append({'deck':deck.stem,'case':c['case'],**c['measurements']})
            for name,values in c['op'].items():ops.append({'deck':deck.stem,'case':c['case'],'device':name,**values})
    save_csv(out/'measurements.csv',summary);save_csv(out/'operating_points.csv',ops)
    (out/'simulation_data.json').write_text(json.dumps(all_data,indent=2),encoding='utf-8')
    print(f'Lab{lab:02d}: {len(all_data)} decks, {sum(len(v) for v in all_data.values())} cases')
    return all_data
if __name__=='__main__':
    for lab in sys.argv[1:]:export(int(lab))
