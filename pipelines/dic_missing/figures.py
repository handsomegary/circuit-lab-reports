from pathlib import Path
import json,csv
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from analyze import val,save
ROOT=Path(__file__).resolve().parents[2];OUT=ROOT/'outputs'/'Circuit_Labs_Release'/'DIC'
plt.rcParams.update({'font.size':10,'axes.spines.top':False,'axes.spines.right':False,'axes.grid':True,'grid.alpha':.2,'figure.constrained_layout.use':True,'savefig.dpi':160,'pdf.fonttype':42})
COLORS=['#245D86','#C66C38','#39846F','#85529B','#9B8B23','#555555']
plt.rcParams['axes.prop_cycle']=matplotlib.cycler(color=COLORS)
def metrics(lab):return json.loads((OUT/f'Lab{lab:02d}'/'results'/'metrics.json').read_text())
def wave(lab,stem,k):
 with (OUT/f'Lab{lab:02d}'/'results'/f'{stem}_waveform_{k:03d}.csv').open() as f:
  rows=list(csv.DictReader(f));return {n:np.array([float(r[n]) for r in rows]) for n in rows[0]}
def finish(fig,lab,name):
 p=OUT/f'Lab{lab:02d}'/'results'/'figures';p.mkdir(exist_ok=True)
 fig.savefig(p/f'{name}.pdf',metadata={'Title':f'DIC Lab {lab}: {name.replace("_"," ")}','Author':'Circuit laboratory'})
 fig.savefig(ROOT/'work'/'dic_missing'/f'{name}.png');plt.close(fig)
def derived(lab,d):
 (OUT/f'Lab{lab:02d}'/'results'/'analysis.json').write_text(json.dumps(d,indent=2))

m=metrics(4);a=m['01_geometry']['cases'][0];c=m['02_junction_capacitance']['cases'];f=m['03_constant_capacitance']['cases'][0]
fig,axs=plt.subplots(1,2,figsize=(10,3.5));w=wave(4,'01_geometry',0)
for k,label in [('y0','Model defaults'),('y2','Unshared geometry'),('y3','Shared geometry')]:axs[0].plot(w['time_s']*1e9,w[k],label=label)
axs[0].set(xlim=(1.9,2.6),xlabel='Time (ns)',ylabel='Output (V)',title='NAND3 falling transition');axs[0].legend(fontsize=8)
x=np.arange(3);axs[1].bar(x-.18,[a[f'g{k}_tphl']*1e12 for k in [0,2,3]],.36,label='High to low');axs[1].bar(x+.18,[a[f'g{k}_tplh']*1e12 for k in [0,2,3]],.36,label='Low to high');axs[1].set(xticks=x,xticklabels=['Default','Unshared','Shared'],ylabel='Propagation delay (ps)',title='Identical 10 fF external loads');axs[1].legend(fontsize=8)
finish(fig,4,'diffusion_geometry')
fig,axs=plt.subplots(1,2,figsize=(10,3.5))
for key,label in [('cn1','Unshared rectangular'),('cn2','Unshared terminal in shared row'),('cn3','Shared terminal')]:axs[0].plot([r['BV'] for r in c],[r[key]*1e15 for r in c],'-o',label=label)
axs[0].set(xlabel='Reverse junction bias (V)',ylabel='NMOS drain junction C (fF)',title='Measured junction contribution');axs[0].legend(fontsize=7)
w=wave(4,'03_constant_capacitance',0)
for k,label,style in [('d2','Unshared, voltage dependent','-'),('f2','Unshared, mean C','--'),('d3','Shared, voltage dependent','-'),('f3','Shared, mean C','--')]:axs[1].plot(w['time_s']*1e9,w[k],style,label=label)
axs[1].set(xlim=(10,11.1),xlabel='Time (ns)',ylabel='Output (V)',title='Fixed-C approximation');axs[1].legend(fontsize=7)
finish(fig,4,'junction_capacitance')
errors={g:{edge:100*(f[f'f{g}_{edge}']/f[f'd{g}_{edge}']-1) for edge in ['tphl','tplh']} for g in [2,3]};derived(4,dict(fixed_cap_delay_error_percent=errors))

m=metrics(7);r=m['01_ring_oscillators']['cases'];th=m['02_body_threshold']['cases'][0]
fig,axs=plt.subplots(1,2,figsize=(10,3.5))
labels=['Nominal','PMOS reverse bias','NMOS reverse bias','Dual reverse bias']
for q,label in zip(r,labels):axs[0].plot([3,5,7],[q[f'freq{n}']/1e9 for n in [3,5,7]],'-o',label=label)
axs[0].set(xlabel='Number of inverter stages',ylabel='Frequency (GHz)',xticks=[3,5,7],title='Stage count and body bias');axs[0].legend(fontsize=7)
w=wave(7,'01_ring_oscillators',0)
for n in [3,5,7]:axs[1].plot(w['time_s']*1e9,w[f'r{n}_0'],label=f'{n} stages')
axs[1].set(xlim=(10,13),xlabel='Time (ns)',ylabel='Output (V)',title='Settled nominal oscillation');axs[1].legend(fontsize=8)
finish(fig,7,'ring_body_bias')
w=wave(7,'02_body_threshold',0);fig,ax=plt.subplots(figsize=(7,3.7));ax.plot(w['sweep_V'],w['mn'],label='NMOS threshold');ax.plot(w['sweep_V'],np.abs(w['mp']),label='PMOS threshold magnitude');ax.set(xlabel='Reverse source-body bias (V)',ylabel='Threshold magnitude (V)',title='Body-effect sweep');ax.legend();finish(fig,7,'body_threshold')
derived(7,dict(frequency_drop_percent={str(n):100*(1-r[3][f'freq{n}']/r[0][f'freq{n}']) for n in [3,5,7]},thresholds=th))

m=metrics(10);r=m['01_size_load']['cases'];s=m['02_slew_load']['cases'];fits=[]
fig,axs=plt.subplots(1,2,figsize=(10,3.6))
for size in [1,2,3,4]:
 qs=[x for x in r if x['SIZE']==size];x=np.array([val(q['LOAD'])*1e12 for q in qs]);y=np.array([(q['tphl']+q['tplh'])*.5e9 for q in qs]);co=np.polyfit(x,y,1);res=y-np.polyval(co,x)
 fits.append(dict(size=size,A0_ns=float(co[1]),A1_ns_per_pF=float(co[0]),max_residual_ps=float(max(abs(res))*1e3)))
 axs[0].plot(x,y,'o-',label=f'Size {size}')
 axs[1].plot(x,[q['tr']*1e9 for q in qs],'-o',label=f'Size {size}, rise');axs[1].plot(x,[q['tf']*1e9 for q in qs],'--',color=COLORS[size-1],label=f'Size {size}, fall')
axs[0].set(xlabel='Output load (pF)',ylabel='Mean propagation delay (ns)',title='Fixed 0.2 ns input transitions');axs[0].legend(fontsize=8)
axs[1].set(xlabel='Output load (pF)',ylabel='Output 10-90% transition (ns)',title='Output slew versus size/load');axs[1].legend(fontsize=6.5,ncol=2)
finish(fig,10,'linear_delay')
x=np.array([val(q['LOAD'])*1e12 for q in s]);y=np.array([val(q['SLEW'])*1e9 for q in s]);z=np.array([(q['tphl']+q['tplh'])*.5e9 for q in s]);X=np.array([np.ones(len(x)),x,y,x*y]).T;coef=np.linalg.lstsq(X,z,rcond=None)[0];res=z-X@coef;XL=X[:,:2];cl=np.linalg.lstsq(XL,z,rcond=None)[0];rl=z-XL@cl
fig,axs=plt.subplots(1,2,figsize=(10,3.6))
for sle in [.2,.4,.6,.8]:
 mask=np.isclose(y,sle);axs[0].plot(x[mask],z[mask],'-o',label=f'{sle:g} ns input slew');axs[1].plot(x[mask],res[mask]*1e3,'-o',label=f'{sle:g} ns')
axs[0].set(xlabel='Output load (pF)',ylabel='Mean propagation delay (ns)',title='Two-variable delay surface');axs[0].legend(fontsize=8)
axs[1].axhline(0,color='black',lw=.6);axs[1].set(xlabel='Output load (pF)',ylabel='Measured - fitted delay (ps)',title='Bilinear model residual');axs[1].legend(fontsize=8)
finish(fig,10,'nonlinear_delay')
derived(10,dict(linear_fits=fits,bilinear=dict(A_ns=float(coef[0]),B_ns_per_pF=float(coef[1]),C=float(coef[2]),D_per_pF=float(coef[3]),rmse_ps=float(np.sqrt(np.mean(res**2))*1e3),max_residual_ps=float(max(abs(res))*1e3)),load_only_rmse_ps=float(np.sqrt(np.mean(rl**2))*1e3)))
save(OUT/'Lab10'/'results'/'linear_fits.csv',fits)

m=metrics(11);r=m['01_driver_sizing']['cases'];length=m['02_wire_length']['cases'];coupled=m['03_coupled_wires']['cases'];sets=[.17,.238,.339];labels=['Set A (0.35 um geometry)','Set B (0.25 um geometry)','Set C (0.18 um geometry)']
fig,axs=plt.subplots(1,3,figsize=(11,3.5),sharey=True)
for ax,ru,label in zip(axs,sets,labels):
 qs=[q for q in r if q['RUNIT']==ru]
 for name,key in [('Driver output','t1_tphl'),('Receiver input','t2_tphl'),('Receiver output','t3_r')]:ax.plot([q['SIZE'] for q in qs],[q[key]*1e9 for q in qs],'-o',ms=3,label=name)
 ax.set(xlabel='Driver size multiplier',title=label);ax.legend(fontsize=6.5)
axs[0].set_ylabel('Delay from rising input (ns)');finish(fig,11,'wire_driver_sizing')
fig,axs=plt.subplots(1,2,figsize=(10,3.6))
for ru,label in zip(sets,labels):
 qs=[q for q in length if q['RUNIT']==ru];axs[0].plot([q['LEN']/1000 for q in qs],[q['t3_r']*1e9 for q in qs],'-o',label=label);axs[1].plot([q['LEN']/1000 for q in qs],[q['t3_f']*1e9 for q in qs],'-o',label=label)
for ax,edge in zip(axs,['Rising','Falling']):ax.set(xlabel='Wire length (mm)',ylabel='Input-to-output delay (ns)',title=edge+' transition; driver scale 5');ax.legend(fontsize=7)
finish(fig,11,'wire_length')
fig,axs=plt.subplots(2,3,figsize=(11,6),sharex=True)
pats=[(1,1),(1,2),(1,-1),(2,2),(2,-1),(-1,-1)];pn=['R,R','R,static','R,F','static,static','static,F','F,F']
for col,ru in enumerate([.17,.24,.34]):
 for row,cen in enumerate([1,-1]):
  ax=axs[row,col]
  for (left,right),label in zip(pats,pn):
   qs=[q for q in coupled if q['RUNIT']==ru and q['CEN']==cen and q['LEFT']==left and q['RIGHT']==right]
   ax.plot([q['LEN']/1000 for q in qs],[q['delay']*1e9 for q in qs],'-o',ms=3,label=label)
  ax.set(title=f'Set {"ABC"[col]}; victim {"rises" if cen==1 else "falls"}',xlabel='Wire length (mm)',ylabel='Delay (ns)')
axs[0,0].legend(fontsize=6,ncol=2);finish(fig,11,'wire_coupling')
endpoints=[]
for ru,label in zip([.17,.24,.34],['A','B','C']):
 for cen in [1,-1]:
  same=next(q for q in coupled if q['RUNIT']==ru and q['CEN']==cen and q['LEFT']==cen and q['RIGHT']==cen and q['LEN']==10000)
  opposite=next(q for q in coupled if q['RUNIT']==ru and q['CEN']==cen and q['LEFT']==-cen and q['RIGHT']==-cen and q['LEN']==10000)
  endpoints.append(dict(set=label,victim=cen,same_ns=same['delay']*1e9,opposite_ns=opposite['delay']*1e9,ratio=opposite['delay']/same['delay']))
derived(11,dict(coupling_10mm=endpoints,rc_products_ns=[1.7*2.11,2.38*2.39,3.39*2.46]));save(OUT/'Lab11'/'results'/'coupling_summary.csv',endpoints)

m=metrics(13);r=m['01_ratio']['cases'];allf=m['02_frequency']['cases']+m['04_frequency_refinement']['cases'];fmax=[]
for size,cl in [(1,'7f'),(2,'7f'),(1,'14f'),(2,'14f')]:
 qs=sorted([q for q in allf if q['SIZE']==size and q['CLVAL']==cl],key=lambda q:1/val(q['PERIOD']))
 for typ in ['c','p']:
  good=[q for q in qs if q[typ+'_low']<=.3 and q[typ+'_high']>=.7];best=max(good,key=lambda q:1/val(q['PERIOD']));fl=1/val(best['PERIOD']);bad=next(q for q in qs if 1/val(q['PERIOD'])>fl)
  fmax.append(dict(size=size,load_fF=val(cl)*1e15,logic='CMOS' if typ=='c' else 'Pseudo NMOS',pass_GHz=fl/1e9,fail_GHz=1/val(bad['PERIOD'])/1e9,power_at_pass_uW=best[typ+'_power']*1e6,VOL_V=best[typ+'_low'],VOH_V=best[typ+'_high']))
fig,axs=plt.subplots(1,2,figsize=(10,3.5));xs=[q['RATIO'] for q in r]
axs[0].plot(xs,[q['p_low'] for q in r],'-o',label='Pseudo output low');axs[0].plot(xs,[q['p_high'] for q in r],'-s',label='Pseudo output high');axs[0].axhline(.3,ls='--',color='gray',label='Low threshold 0.3 V');axs[0].set(xlabel='PMOS / NMOS width ratio',ylabel='Sampled output level (V)',title='Ratioed logic at 500 MHz');axs[0].legend(fontsize=7)
axs[1].plot(xs,[q['c_power']*1e6 for q in r],'-o',label='CMOS');axs[1].plot(xs,[q['p_power']*1e6 for q in r],'-o',label='Pseudo NMOS');axs[1].set(xlabel='PMOS / NMOS width ratio',ylabel='Average supply power (uW)',title='Identical sizes and 7 fF load');axs[1].legend(fontsize=8);finish(fig,13,'pseudo_ratio')
fig,axs=plt.subplots(1,2,figsize=(10,3.5))
qs=sorted([q for q in allf if q['SIZE']==1 and q['CLVAL']=='7f'],key=lambda q:1/val(q['PERIOD']))
for typ,label in [('c','CMOS'),('p','Pseudo NMOS')]:
 axs[0].plot([1e-9/val(q['PERIOD']) for q in qs],[q[typ+'_high'] for q in qs],'-o',ms=3,label=label)
 axs[1].plot([1e-9/val(q['PERIOD']) for q in qs],[q[typ+'_power']*1e6 for q in qs],'-o',ms=3,label=label)
axs[0].axhline(.7,color='gray',ls='--');axs[0].set(xlabel='Input frequency (GHz)',ylabel='Sampled high level (V)',title='High-level timing limit, size 1 / 7 fF');axs[0].legend(fontsize=8)
axs[1].set(xlabel='Input frequency (GHz)',ylabel='Average supply power (uW)',title='Power includes both dynamic and static loss');axs[1].legend(fontsize=8);finish(fig,13,'pseudo_frequency')
derived(13,dict(frequency_brackets=fmax));save(OUT/'Lab13'/'results'/'frequency_brackets.csv',fmax)
print('11 figures and derived metrics generated')
