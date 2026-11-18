from pathlib import Path
import json,csv
import numpy as np
exec(Path('work/dic_high_next/extract.py').read_text().split('all_data={}')[0])
W=Path('work/dic_missing_highB');F=ROOT/'Lab24/results';F.mkdir(exist_ok=True)
D=cases('Lab24_01_counters');C=cases('Lab24_02_clock_loading')[0]
periods=[20,10,5,3,2,1.5,1]
try:
    extra=cases('Lab24_03_period_refinement')
    if len(D)==7:
        D+=extra;periods+=[6,2.5]
except FileNotFoundError:pass
def ideal():
    j1=j2=j3=g2=g5=0;out={}
    for k in range(2,275):
        b0=j3^(1-j2);en1=b0&j3;en2=en1&(g2==7)
        j1,j2,j3=1-j2,j1,j2;g2=(g2+en1)%8;g5=(g5+en2)%8
        out[k]=[j3^(1-j2),j3]+[(g2>>x)&1 for x in range(3)]+[(g5>>x)&1 for x in range(3)]
    return out
E=ideal();rows=[];samples=[]
for idx,c in enumerate(D):
    if idx>=len(periods) or not c['rows'] or not c['measurements']:continue
    per=periods[idx]*1e-9;data=c['rows'];ts=np.array([r['time_s'] for r in data]);tt=np.array([(k+.7)*per for k in range(10,270)])
    scores={}
    for kind,prefix,width in [('sync','b',8),('async','a',4)]:
        values=np.stack([np.interp(tt,ts,[r[f'{prefix}{i}'] for r in data]) for i in range(width)],axis=1)
        expected=np.array([E[k] if kind=='sync' else [((k-1)>>i)&1 for i in range(4)] for k in range(10,270)])
        good=np.where(expected,values>=.8,values<=.2).all(axis=1)
        scores[kind]=int(good.sum())
        for k,vs,es,ok in zip(range(10,270),values,expected,good):samples.append(dict(deck='01_counters.sp' if idx<7 else '03_period_refinement.sp',case_index=idx if idx<7 else idx-7,analysis_index=idx,period_ns=periods[idx],architecture=kind,clock_index=k,expected_word=sum(int(x)<<i for i,x in enumerate(es)),observed_word=sum(int(x>.5)<<i for i,x in enumerate(vs)),all_bits_meet_thresholds=bool(ok),**{f'bit{i}_V':float(x) for i,x in enumerate(vs)}))
    rows.append(dict(period_ns=periods[idx],frequency_MHz=1000/periods[idx],sync_correct=scores['sync'],async_correct=scores['async'],samples=260,sync_power_uW=c['measurements']['sync_power']*1e6,async_power_uW=c['measurements']['async_power']*1e6))
rows.sort(key=lambda x:x['frequency_MHz'])
for name,rr in [('frequency_comparison',rows),('sample_validation',samples)]:
 if rr:
  fields=list(dict.fromkeys(k for r in rr for k in r))
  with (F/(name+'.csv')).open('w',newline='') as f:
   wr=csv.DictWriter(f,fieldnames=fields);wr.writeheader();wr.writerows(rr)
# Measure edge crossing spread by interpolation in the 20 ns baseline.
def crossings(c,node,start,end):
    rr=c['rows'];ts=np.array([x['time_s'] for x in rr]);ys=np.array([x[node] for x in rr]);ix=np.flatnonzero((ts[:-1]>=start)&(ts[1:]<=end)&((ys[:-1]-.5)*(ys[1:]-.5)<0))
    return [float(ts[i]+(.5-ys[i])/(ys[i+1]-ys[i])*(ts[i+1]-ts[i])) for i in ix]
spread=[]
if D and D[0]['rows']:
 for arch,names,k in [('ripple',['a0','a1','a2','a3'],9),('synchronous',['b0','b1','b2','b3','b4'],33)]:
  vals=[]
  for node in names:
   xx=crossings(D[0],node,(k+.25)*20e-9,(k+.7)*20e-9)
   if xx:vals.append(dict(architecture=arch,clock_index=k,node=node,delay_from_source_edge_ps=(xx[0]-(k+.25)*20e-9)*1e12))
  spread+=vals
if spread:
 with (F/'transition_delays.csv').open('w',newline='') as f:
  wr=csv.DictWriter(f,fieldnames=list(spread[0]));wr.writeheader();wr.writerows(spread)
result=dict(frequency=rows,clock_loading=C['measurements'],transistor_counts=json.loads((W/'transistor_counts.json').read_text()),transition_delays=spread)
(W/'derived.json').write_text(json.dumps(result,indent=2))
print(json.dumps(result,indent=2))
