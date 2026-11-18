from pathlib import Path
import re,json,csv,sys
ROOT=Path('outputs/Circuit_Labs_Release/DIC')
RUN=Path('work/dic_high_next/runs')
NUM=re.compile(r'^[+-]?(?:\d+\.?\d*|\.\d+)(?:[eE][+-]?\d+)?$')
def measure(path):
    if not path.exists(): return {}
    t=' '.join(l for l in path.read_text().splitlines() if not l.startswith(('$','.'))).split()
    k=next((i for i,x in enumerate(t) if NUM.fullmatch(x)),len(t))
    return {a:float(b) if NUM.fullmatch(b) else None for a,b in zip(t[:k],t[k:])}
def cases(stem):
    text=(RUN/(stem+'.lis')).read_text(errors='replace')
    starts=[m.start() for m in re.finditer(r' \*{6} (?:transient analysis|dc transfer curves)',text)]
    out=[]
    for idx,(a,b) in enumerate(zip(starts,starts[1:]+[len(text)])):
        chunk=text[a:b];rows={};isdc='dc transfer curves' in chunk[:80]
        axis='sweep_V' if isdc else 'time_s'
        for m in re.finditer(r'\nx\s*\n(.*?)\ny(?=\s*\n|$)',chunk,re.S):
            lines=[l.strip() for l in m.group(1).splitlines() if l.strip()]
            j=next((i for i,l in enumerate(lines) if all(NUM.fullmatch(x) for x in l.split())),None)
            if j is None: continue
            cols=lines[j-1].split();n=len(lines[j].split())-1
            if len(cols)==n+1 and cols[0] in ['time','volt','freq']:cols=cols[1:]
            if len(cols)!=n:raise ValueError((stem,idx,cols,n))
            for l in lines[j:]:
                vals=l.split()
                if len(vals)!=n+1 or not all(NUM.fullmatch(x) for x in vals):continue
                v=list(map(float,vals));r=rows.setdefault(v[0],{axis:v[0]});r.update(zip(cols,v[1:]))
        out.append(dict(index=idx,axis=axis,rows=list(rows.values()),measurements=measure(RUN/f'{stem}.m{"s" if isdc else "t"}{idx}')))
    return out

all_data={}
for lab in ([int(x) for x in sys.argv[1:]] or [15,16,17,21,25,27,28]):
    resultdir=ROOT/f'Lab{lab:02d}'/'results';resultdir.mkdir(exist_ok=True)
    summary=[]
    for source in sorted((ROOT/f'Lab{lab:02d}').glob('*.sp')):
        stem=f'Lab{lab:02d}_'+source.stem
        statusp=RUN/(stem+'_status.json')
        if not statusp.exists():continue
        status=json.loads(statusp.read_text())
        if not status['completed'] or status['errors']:continue
        data=cases(stem);all_data[stem]=data
        source_cases=re.split(r'(?im)^\.alter[^\n]*\n',source.read_text())
        for case in data:
            fields=list(dict.fromkeys(k for r in case['rows'] for k in r))
            if not fields:raise ValueError(('no rows',stem,case['index']))
            p=resultdir/f'{source.stem}_case{case["index"]}.csv'
            with p.open('w',newline='',encoding='utf-8') as f:
                w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(case['rows'])
            changed=re.findall(r'(?im)^\.(?:param|temp)[^\n]*',source_cases[case['index']]) if case['index']<len(source_cases) else []
            summary.append(dict(deck=source.name,case_index=case['index'],case_directives=changed,measurements=case['measurements'],execution='completed',warning_status='Encrypted-block warning details remain suppressed; harmlessness is not established.'))
    (resultdir/'measurements.json').write_text(json.dumps(summary,indent=2),encoding='utf-8')
    flat=[dict(deck=s['deck'],case_index=s['case_index'],metric=k,value=v) for s in summary for k,v in s['measurements'].items()]
    with (resultdir/'measurements.csv').open('w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=['deck','case_index','metric','value']);w.writeheader();w.writerows(flat)
    print(f'Lab{lab}: {len(summary)} cases, {len(flat)} measurements',flush=True)
Path('work/dic_high_next/data.json').write_text(json.dumps(all_data),encoding='utf-8')
