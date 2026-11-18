from pathlib import Path
import json,sys,math
import numpy as np
from extract_next import export,save_csv
ROOT=Path(__file__).resolve().parents[2]
PUB=ROOT/'outputs/Circuit_Labs_Release/AIC'

def crossing(x,y,level,descending=True):
    for i in range(1,len(x)):
        if (y[i-1]>=level>y[i]) if descending else (y[i-1]<=level<y[i]):
            t=(level-y[i-1])/(y[i]-y[i-1]);return x[i-1]+t*(x[i]-x[i-1])
    return None
def bode(rows,col='mag_out',phase='phase_out',loop=False):
    if not rows or col not in rows[0]:return {}
    f=np.array([r['frequency_Hz'] for r in rows]);g=np.array([r[col] for r in rows]);db=20*np.log10(np.maximum(g,1e-300));x=np.log10(f)
    bw=crossing(x,db,db[0]-3.01029995664);ug=crossing(x,db,0)
    result={'gain_V_per_V':float(g[0]),'gain_dB':float(db[0]),'f3dB_Hz':10**bw if bw is not None else None,'unity_Hz':10**ug if ug is not None else None}
    result['gain_bandwidth_Hz']=result['gain_V_per_V']*result['f3dB_Hz'] if result['f3dB_Hz'] is not None else None
    if phase in rows[0] and ug is not None:
        ph=np.unwrap(np.deg2rad([r[phase] for r in rows]))*180/math.pi
        result['phase_at_unity_deg']=float(np.interp(ug,x,ph))
        if loop:result['phase_margin_deg']=180+result['phase_at_unity_deg']
    return result
def saturated(op):return bool(op) and all(abs(o['vds'])+1e-6>=abs(o['vdsat']) for o in op.values())
def sat_fail(op):return ';'.join(n for n,o in op.items() if abs(o['vds'])+1e-6<abs(o['vdsat']))
def valid_interval(points,valid):
    best=[];part=[]
    for x,ok in zip(points,valid):
        if ok:part.append(x)
        else:
            if len(part)>len(best):best=part
            part=[]
    if len(part)>len(best):best=part
    return [min(best),max(best)] if best else [None,None]
def slew(c):
    rows=c['tran'];t=np.array([r['time_s'] for r in rows]);v=np.array([r['v_out'] for r in rows]);m=c['measurements'];ans={}
    for direction,start,end,lo,hi in [('rise',1e-6,2.99e-6,m['low_before'],m['high_final']),('fall',3.001e-6,5e-6,m['high_final'],m['low_final'])]:
        ix=(t>=start)&(t<=end);ts=t[ix];vs=v[ix];delta=hi-lo
        norm=(vs-lo)/delta if delta else vs*0
        a=crossing(ts,norm,.2,False);b=crossing(ts,norm,.8,False)
        ans[f'slew_{direction}_V_per_us']=abs(.6*delta/(b-a))*1e-6 if a is not None and b is not None and b>a else None
        valid=np.abs(vs-hi)<=abs(delta)*.01;bad=np.flatnonzero(~valid)
        ans[f'settle_{direction}_ns']=(ts[bad[-1]+1]-start)*1e9 if len(bad) and bad[-1]+1<len(ts) else (0 if not len(bad) else None)
        ans[f'overshoot_{direction}_pct']=max(0,float(np.max(norm))-1)*100
    return ans
def analyze(lab):
    data=export(lab);out=PUB/f'Lab{lab:02d}'/'results';summary={};rows=[]
    if lab==2:
        for stem,cases in data.items():
            for c in cases:
                m=c['measurements'];r={'deck':stem,'case':c['case'],**m}
                if c['op']:
                    r['all_abs_vds_ge_vdsat']=saturated(c['op']);r['failed_devices']=sat_fail(c['op'])
                if c['tran'] and 'v_vref' in c['tran'][0]:
                    final=m['ref_final'];ts=[x['time_s'] for x in c['tran']];last=max((i for i,x in enumerate(c['tran']) if abs(x['v_vref']-final)>.01*abs(final)),default=-1)
                    r['settled_from_power_start_us']=ts[last+1]*1e6 if last+1<len(ts) else None
                rows.append(r)
    elif lab==3:
        for stem,cases in data.items():
            for c in cases:
                r={'deck':stem,'case':c['case'],**c['measurements']}
                if c['ac']:
                    r.update(bode(c['ac']));r['rout_tf_ohm']=c.get('rout_tf_ohm')
                    r['all_abs_vds_ge_vdsat']=saturated(c['op']);r['failed_devices']=sat_fail(c['op']);r['output_V']=c['nodes'].get('out');r['input_V']=c['nodes'].get('in')
                    r['subthreshold_devices']=';'.join(n for n,o in c['op'].items() if o['region'].lower().startswith('sub'))
                    op=c['op']
                    if stem.startswith('01'):
                        den=op['m1']['gds']+op['mp']['gm']+op['mp']['gds'];r['gain_derivative_estimate']=op['m1']['gm']/den
                    if stem.startswith('02'):
                        den=op['m1']['gds']+op['ml']['gm']+op['ml']['gmb']+op['ml']['gds'];r['gain_derivative_estimate']=op['m1']['gm']/den
                    if stem.startswith('03'):
                        den=op['mn']['gds']+op['mp']['gds'];r['gain_derivative_estimate']=op['mn']['gm']/den
                        r['mirror_error_pct']=(abs(op['mp']['id'])/abs(op['mref']['id'])-1)*100
                if stem=='04_source_followers':
                    for p in ['n','p']:
                        bm=bode(c['ac'],'mag_o'+p,'phase_o'+p)
                        r.update({k+'_'+p:v for k,v in bm.items()})
                rows.append(r)
    elif lab==4:
        for stem,cases in data.items():
            if stem[:2] in ['01','02','03']:
                base=cases[0]['measurements']['gain_db'];summary[stem]={'cmrr_dB':base-cases[1]['measurements']['gain_db'],'psrr_plus_dB':base-cases[2]['measurements']['gain_db'],'psrr_minus_dB':base-cases[3]['measurements']['gain_db']}
                for c in cases:
                    rows.append({'deck':stem,'case':c['case'],**bode(c['ac']),'output_V':c['nodes']['out'],'all_abs_vds_ge_vdsat':saturated(c['op']),'failed_devices':sat_fail(c['op'])})
            if stem.startswith('04'):
                for p in ['b','c','f']:
                    valid=[]
                    for c in cases:
                        op={n:o for n,o in c['op'].items() if n.startswith('m'+p)}
                        v=saturated(op);valid.append(v)
                        rows.append({'deck':stem,'case':c['case'],'topology':p,'common_mode_V':c['measurements']['common_mode'],'all_abs_vds_ge_vdsat':v,'failed_devices':sat_fail(op)})
                    summary['icmr_'+p]=valid_interval([c['measurements']['common_mode'] for c in cases],valid)
            if stem.startswith('05'):
                for i in [0,1,2,3,7,8,9,13]:
                    if i>=len(cases):continue
                    c=cases[i]
                    for p in 'scd':
                        r={'deck':stem,'case':i,'topology':p,'gain_A_per_A':c['measurements']['gain_'+p],'rin_ohm':c['measurements']['rin_'+p],'output_V':c['nodes'][p+'out']}
                        bm=bode(c['ac'],'imag_imag_'+p,'none');r.update({k:v for k,v in bm.items() if k in ['f3dB_Hz','unity_Hz','gain_bandwidth_Hz']})
                        ri=i+3 if i in [1,2,3,7,8,9] else None
                        if ri is not None:r['rout_ohm']=cases[ri]['ac'][0]['mag_vout_'+p]
                        op={n:o for n,o in c['op'].items() if n.startswith('m'+p)};r['all_abs_vds_ge_vdsat']=saturated(op);r['failed_devices']=sat_fail(op)
                        rows.append(r)
    elif lab==5:
        for stem,cases in data.items():
            for c in cases:
                r={'deck':stem,'case':c['case'],**c['measurements']}
                if c['ac']:
                    r.update(bode(c['ac'],loop=(stem.startswith('01') or (stem.startswith('02') and c['case']==0))));r['output_V']=c['nodes'].get('out');r['all_abs_vds_ge_vdsat']=saturated(c['op']);r['failed_devices']=sat_fail(c['op'])
                    op=c['op'];r['stage1_gain_estimate']=op['m2']['gm']/(op['m2']['gds']+op['m4']['gds']);r['stage2_gain_estimate']=op['m7']['gm']/(op['m7']['gds']+op['m8']['gds']);r['inverse_gm7_ohm']=1/op['m7']['gm'];r['supply_power_uW']=(1e-5+sum(abs(op[k]['id']) for k in ['m3','m4','m7']))*1e6
                if stem.startswith('03'):
                    low,high=valid_interval([x['sweep'] for x in c['dc']],[abs(x['v_out']-x['sweep'])<=.01 for x in c['dc']]);r['tracking_min_V']=low;r['tracking_max_V']=high
                if stem.startswith('04'):
                    valid=[abs(x['v_out']-(7.15-10*x['sweep']))<=.01 for x in c['dc']]
                    interval=valid_interval([x['sweep'] for x in c['dc']],valid);r['input_min_V'],r['input_max_V']=interval
                    subset=[x['v_out'] for x in c['dc'] if interval[0] is not None and interval[0]<=x['sweep']<=interval[1]]
                    r['output_min_V']=min(subset) if subset else None;r['output_max_V']=max(subset) if subset else None
                if stem.startswith('05'):r.update(slew(c))
                rows.append(r)
        fam=data['02_rejection_families'];base=fam[0]['measurements']['gain_db'];summary['rejection']={'cmrr_dB':base-fam[1]['measurements']['gain_db'],'psrr_plus_dB':base-fam[2]['measurements']['gain_db'],'psrr_minus_dB':base-fam[3]['measurements']['gain_db']}
    summary['metrics']=rows;save_csv(out/'summary.csv',rows);(out/'summary.json').write_text(json.dumps(summary,indent=2),encoding='utf-8')
    print('Summary',lab,len(rows));return data,summary
if __name__=='__main__':
    for x in sys.argv[1:]:analyze(int(x))
