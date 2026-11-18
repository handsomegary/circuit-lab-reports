from pathlib import Path
import json,csv,re
import numpy as np
ROOT=Path('outputs/Circuit_Labs_Release/DIC')
D=json.loads(Path('work/dic_high_next/data.json').read_text())
OUT={}
def case(lab,name,i=0):return D[f'Lab{lab:02d}_{name}'][i]
def m(lab,name,i=0):return case(lab,name,i)['measurements']
def v(c,node,t):
    r=c['rows'];return float(np.interp(t,[x[c['axis']] for x in r],[x[node] for x in r]))
def logic(value,expected):return value>=.8 if expected else value<=.2
def cross(c,node,t0,t1,rise=True,level=.5):
    r=c['rows'];ts=np.array([x['time_s'] for x in r]);ys=np.array([x[node] for x in r])
    mask=(ts[:-1]>=t0)&(ts[1:]<=t1)
    condition=(ys[:-1]<level)&(ys[1:]>=level) if rise else (ys[:-1]>level)&(ys[1:]<=level)
    idx=np.flatnonzero(mask&condition)
    if not len(idx):return None
    k=idx[0];return float(ts[k]+(level-ys[k])/(ys[k+1]-ys[k])*(ts[k+1]-ts[k]))
def table(lab,name,rows):
    out=ROOT/f'Lab{lab:02d}'/'results';fields=list(dict.fromkeys(k for r in rows for k in r))
    with (out/(name+'.csv')).open('w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)
    OUT.setdefault(str(lab),{})[name]=rows

rows=[]
for i,(vol,temp) in enumerate([(1,25),(1.1,0),(.9,115)]):
    q=m(15,'01_voltage_temperature',i);rows.append(dict(voltage_V=vol,temperature_C=temp,tphl_ps=q['tphl']*1e12,tplh_ps=q['tplh']*1e12,power_uW=q['pavg']*1e6))
table(15,'environment_comparison',rows)
table(15,'off_current',[dict(temperature_C=t,low_input_A=m(15,'02_off_state_current',i)['ileak_low'],high_input_A=m(15,'02_off_state_current',i)['ileak_high']) for i,t in enumerate([25,0,115])])
table(16,'charge_discharge',[dict(device=n,final_voltage_V=m(16,'01_charge_discharge')['final_'+n]) for n in ['pc','pd','nc','nd','tc','td']])
c=case(16,'02_six_delay_chains');rows=[]
for k in range(1,7):
    vals=[]
    for t,rise in [(2e-9,True),(22e-9,False)]:
        ti=cross(c,'in',t,t+1e-9,rise)
        to=cross(c,'out'+str(k),t,t+15e-9,rise if k%2 else not rise)
        vals.append((to-ti)*1e9 if ti is not None and to is not None else None)
    rows.append(dict(chain=k,delay_input_rise_ns=vals[0],delay_input_fall_ns=vals[1],output_at_15ns_V=v(c,'out'+str(k),15e-9),output_at_35ns_V=v(c,'out'+str(k),35e-9)))
table(16,'chain_comparison',rows)
q=m(16,'05_tg_full_adder');rows=[]
for i in range(8):
    a=(i>>2)&1;b=(i>>1)&1;cc=i&1;s=a^b^cc;co=int(a+b+cc>=2)
    rows.append(dict(A=a,B=b,C=cc,expected_sum=s,expected_carry=co,sum_V=q[f'sum{i}'],carry_V=q[f'carry{i}'],diagnostic_ok=logic(q[f'sum{i}'],s) and logic(q[f'carry{i}'],co)))
table(16,'adder_truth',rows)
c=case(16,'05_tg_full_adder');ti=cross(c,'c',30e-9,31e-9)
table(16,'adder_delay',[dict(path=n,delay_ps=(cross(c,n,30e-9,35e-9,r)-ti)*1e12) for n,r in [('sum',False),('carry',True)]])
table(16,'retention',[dict(temperature_C=t,initial_V=m(16,'04_hold_leakage',i)['initial_hold'],at_5us_V=m(16,'04_hold_leakage',i)['hold_5us'],at_20us_V=m(16,'04_hold_leakage',i)['hold_20us']) for i,t in enumerate([25,115])])

table(16,'refresh_diagnostic',[dict(temperature_C=t,hold_to_08_us=(cross(case(16,'04_hold_leakage',i),'hold',20e-9,20e-6,False,.8)-10e-9)*1e6) for i,t in enumerate([25,115])])
c=case(16,'03_dc_current_paths');table(16,'current_paths',[dict(output_V=z,n_charge_uA=v(c,'mn1',z)*1e6,n_discharge_uA=v(c,'mn2',z)*1e6,p_charge_uA=v(c,'mp1',z)*1e6,p_discharge_uA=v(c,'mp2',z)*1e6) for z in [0,.25,.5,.75,1]])

periods=[20,10,5,2,1,.5,.25,.1,1.2,1.4,1.6,1.8]
rows=[]
for i,p in enumerate(periods):
    q=m(17,'03_frequency_sweep',i)
    for kind,tag in [('static','s'),('dynamic','d')]:
        vals=[q[f'q{tag}{j}'] for j in range(2,10)]
        rows.append(dict(kind=kind,period_ns=p,frequency_GHz=1/p,correct_samples=sum(logic(x,j%2) for x,j in zip(vals,range(2,10))),sample_count=8,max_expected_low_V=max(vals[::2]),min_expected_high_V=min(vals[1::2])))
table(17,'frequency_check',rows)
table(17,'noise_comparison',[dict(coupling_fF=c,static_peak_V=m(17,'02_noise',i)['qs_noise'],dynamic_peak_V=m(17,'02_noise',i)['qd_noise'],keeper_peak_V=m(17,'02_noise',i)['qk_noise']) for i,c in enumerate([1,5,20])])
table(17,'reset_check',[dict(metric=k,voltage_V=x) for k,x in m(17,'04_async_reset').items() if k.startswith('q_')])

rows=[]
for i,(p,s) in enumerate([(20,.2),(20,1),(20,5),(10,.2),(10,1),(10,2),(4,.2),(4,1),(2,.2)]):
    q=m(21,'01_clock_slope',i)
    for kind in ['direct','buffer']:
        vals=[q[f'{kind}{j}'] for j in range(2,10)]
        rows.append(dict(clock=kind,period_ns=p,slew_ns=s,frequency_GHz=1/p,correct_samples=sum(logic(x,j%2) for x,j in zip(vals,range(2,10))),sample_count=8))
table(21,'slope_frequency_check',rows)
rows=[]
for i,sk in enumerate([0,-.2,-.5,-1,-2,.2,.5,1,2]):
    q=m(21,'02_three_stage_skew',i);vals=[q[f'q3_{j}'] for j in range(3,10)]
    rows.append(dict(skew_ns=sk,correct_samples=sum(logic(x,j%2) for x,j in zip(vals,range(3,10))),sample_count=7,first_V=vals[0],second_V=vals[1]))
table(21,'skew_check',rows)
table(21,'retention',[dict(temperature_C=t,x_hold_V=m(21,'03_low_frequency_retention',i)['x_hold'],z_hold_V=m(21,'03_low_frequency_retention',i)['z_hold']) for i,t in enumerate([25,115])])

q=m(25,'01_charge_sharing');table(25,'sharing',[dict(before_V=q['before'],after_V=q['after'],drop_V=q['before']-q['after'],internal_after_V=q['internal_after'])])
table(25,'coupling',[dict(coupling_fF=c,dynamic_V=m(25,'02_coupling_sweep',i)['dynamic_after'],inverter_V=m(25,'02_coupling_sweep',i)['inv_after'],driven_output_min_V=m(25,'02_coupling_sweep',i)['output_coupled_min'],driven_output_final_V=m(25,'02_coupling_sweep',i)['output_coupled_final']) for i,c in enumerate([5,10,15,20,30,50])])
q=m(25,'03_parasitic_coupling');table(25,'gate_position',[dict(position=s,before_V=q[s+'_before'],after_V=q[s+'_after'],drop_V=q[s+'_before']-q[s+'_after']) for s in ['upper','lower']])
table(25,'retention',[dict(temperature_C=t,mode=k,final_V=m(25,'04_leakage_and_restoration',i)[f'final{k}']) for i,t in enumerate([25,115]) for k in range(4)])
q=m(25,'05_sharing_remedies');table(25,'remedies',[dict(mode=k,before_V=q[f'before{k}'],after_V=q[f'after{k}'],drop_V=q[f'before{k}']-q[f'after{k}']) for k in range(4)])
table(25,'power',[dict(frequency_MHz=f,always_power_uW=m(25,'06_keeper_power',i)['always_power']*1e6,feedback_power_uW=m(25,'06_keeper_power',i)['feedback_power']*1e6,always_eval_uA=m(25,'06_keeper_power',i)['always_eval_current']*1e6,feedback_eval_uA=m(25,'06_keeper_power',i)['feedback_eval_current']*1e6) for i,f in enumerate([500,50])])

rows=[]
for idx,(sk,fix) in enumerate([(0,-1),(.5,-1),(-.5,-1),(0,0),(.5,0),(-.5,0),(0,1),(.5,1),(-.5,1)]):
    q=m(27,'01_four_topologies',idx)
    for k in range(1,5):
        vals=[q[f'q{k}_{j}'] for j in range(2,8)]
        expected=[int(not fix)]*6 if fix>=0 else [1-(j%2) for j in range(2,8)]
        rows.append(dict(case_index=idx,skew_ns=sk,input='dynamic' if fix<0 else str(fix),topology=chr(96+k),correct_samples=sum(logic(x,y) for x,y in zip(vals,expected)),sample_count=6,min_V=q[f'min{k}'],max_V=q[f'max{k}']))
table(27,'topology_check',rows)

c=case(28,'01_latch_equivalence');rows=[]
for a,b in [(1,3),(2,4)]:
    vals=[abs(v(c,f'out{a}',(j*4+2.5)*1e-9)-v(c,f'out{b}',(j*4+2.5)*1e-9)) for j in range(2,8)]
    rows.append(dict(pair=f'{a}-{b}',max_sample_difference_V=max(vals)))
table(28,'latch_equivalence',rows)
q=m(28,'02_doubled_clocked_inverters');table(28,'hold_check',[dict(kind=k,min_V=q[f'hold_{k}_min'],max_V=q[f'hold_{k}_max'],span_V=q[f'hold_{k}_max']-q[f'hold_{k}_min']) for k in ['n','p']])
rows=[]
for i,s in enumerate([.2,1]):
    q=m(28,'03_two_stage_dff',i)
    for tag in ['f1','f2','s1','s2']:
        expected=[(j%2 if tag=='f1' else 1-j%2) for j in range(2,8)]
        # Reduced-stage first output is inverted; its second stage restores polarity.
        if tag=='s2':expected=[1-j%2 for j in range(2,8)]
        vals=[q[f'{tag}_{j}'] for j in range(2,8)]
        rows.append(dict(slew_ns=s,output=tag,correct_samples=sum(logic(x,y) for x,y in zip(vals,expected)),sample_count=6,first_V=vals[0],second_V=vals[1]))
table(28,'cascade_check',rows)
q=m(28,'04_hold_phase_input_changes');table(28,'input_change_diagnostic',[dict(metric=k,voltage_V=x) for k,x in q.items() if k not in ['temper','alter#']])
Path('work/dic_high_next/derived.json').write_text(json.dumps(OUT,indent=2),encoding='utf-8')
print('Derived tables:', ', '.join(f'Lab{k}: {len(v)}' for k,v in OUT.items()))
