from pathlib import Path
import json,sys
sys.path.insert(0,str(Path("work/dic_high_next/pydeps").resolve()))
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
D=json.loads(Path('work/dic_high_next/data.json').read_text())
R=json.loads(Path('work/dic_high_next/derived.json').read_text())
ROOT=Path('outputs/Circuit_Labs_Release/DIC')
plt.rcParams.update({'font.size':9,'axes.titlesize':10,'axes.labelsize':9,'legend.fontsize':8,'pdf.fonttype':42,'savefig.dpi':160})
count=0
def c(lab,name,i=0):return D[f'Lab{lab:02d}_{name}'][i]
def wave(ax,cc,nodes,labels=None,unit=1e-9,lim=None):
    rr=cc['rows'];t=np.array([r[cc['axis']] for r in rr])/unit
    for n,label in zip(nodes,labels or nodes):ax.plot(t,[r[n] for r in rr],label=label,lw=1.2)
    if lim:ax.set_xlim(*lim)
    ax.set_ylabel('Voltage (V)');ax.grid(alpha=.22);ax.legend(loc='best',ncol=min(4,len(nodes)))
def save(lab,name,fig):
    global count
    p=ROOT/f'Lab{lab:02d}'/'results'/'figures';p.mkdir(exist_ok=True)
    fig.savefig(p/(name+'.pdf'),bbox_inches='tight',metadata={'Title':f'DIC Lab {lab}: {name.replace("_"," ")}','Author':'','Subject':'Simulation results'})
    fig.savefig(p/(name+'.png'),bbox_inches='tight');plt.close(fig);count+=1
def sub(n=2,height=5):return plt.subplots(n,1,figsize=(7.2,height),constrained_layout=True,squeeze=False)[0:2]

f,a=sub(2);a=a[:,0]
for i,label in enumerate(['1.0 V, 25 C','1.1 V, 0 C','0.9 V, 115 C']):
    cc=c(15,'01_voltage_temperature',i);rr=cc['rows'];a[0].plot([r['time_s']*1e9 for r in rr],[r['out'] for r in rr],label=label)
a[0].set_xlim(4,8);a[0].set_ylabel('Output (V)');a[0].legend();a[0].grid(alpha=.2)
q=R['15']['environment_comparison'];x=np.arange(3);a[1].bar(x-.18,[r['tphl_ps'] for r in q],.36,label='High to low');a[1].bar(x+.18,[r['tplh_ps'] for r in q],.36,label='Low to high');a[1].set_xticks(x,['1.0 V / 25 C','1.1 V / 0 C','0.9 V / 115 C']);a[1].set_ylabel('Delay (ps)');a[1].legend();a[1].grid(axis='y',alpha=.2);save(15,'environment',f)

f,a=sub(2);a=a[:,0];cc=c(16,'01_charge_discharge');wave(a[0],cc,['pc','nc','tc'],['PMOS charge','NMOS charge','TG charge']);wave(a[1],cc,['pd','nd','td'],['PMOS discharge','NMOS discharge','TG discharge']);a[1].set_xlabel('Time (ns)');save(16,'pass_device_levels',f)
f,a=sub(3,6.3);a=a[:,0];cc=c(16,'02_six_delay_chains')
for ax,ns,title in zip(a,[['in','out1','out2'],['in','out3','out4'],['in','out5','out6']],['PMOS chains','NMOS chains','Transmission-gate chains']):wave(ax,cc,ns,lim=(0,40));ax.set_title(title)
a[-1].set_xlabel('Time (ns)');save(16,'six_chains',f)
f,a=sub(2);a=a[:,0];wave(a[0],c(16,'05_tg_full_adder'),['a','b','c'],['A','B','Cin']);wave(a[1],c(16,'05_tg_full_adder'),['sum','carry'],['Sum','Cout']);a[-1].set_xlabel('Time (ns)');save(16,'adder',f)
f,a=sub(1,3.4);a=a[0,0]
for i,t in enumerate([25,115]):wave(a,c(16,'04_hold_leakage',i),['hold'],[f'{t} C'],unit=1e-6)
a.set_xlabel('Time (us)');a.set_title('Transmission-gate floating-node retention');save(16,'retention',f)

f,a=sub(1,3.6);a=a[0,0];cc=c(16,'03_dc_current_paths');rr=cc['rows']
for n,label in [('mn1','NMOS charge'),('mn2','NMOS discharge'),('mp1','PMOS charge'),('mp2','PMOS discharge')]:a.plot([r['sweep_V'] for r in rr],[r[n]*1e6 for r in rr],label=label)
a.set_xlabel('Forced output voltage (V)');a.set_ylabel('Device current magnitude (uA)');a.legend();a.grid(alpha=.2);save(16,'current_trajectories',f)

f,a=sub(3,6.5);a=a[:,0]
for i,ccf in enumerate([1,5,20]):wave(a[i],c(17,'02_noise',i),['qs','qd','qk'],['Static','Dynamic','Weak keeper'],lim=(5,26));a[i].set_title(f'Equal coupling capacitance: {ccf} fF')
a[-1].set_xlabel('Time (ns)');save(17,'noise',f)
f,a=sub(1,3.5);a=a[0,0]
for typ in ['static','dynamic']:
    rr=sorted([r for r in R['17']['frequency_check'] if r['kind']==typ],key=lambda r:r['frequency_GHz']);a.semilogx([r['frequency_GHz'] for r in rr],[r['correct_samples'] for r in rr],'-o',label=typ)
a.set_xlabel('Clock frequency (GHz)');a.set_ylabel('Correct samples / 8');a.set_yticks([0,2,4,6,8]);a.grid(alpha=.2);a.legend();save(17,'frequency',f)
f,a=sub(3,6.3);a=a[:,0];wave(a[0],c(17,'01_hazards'),['clk','d'],['Clock','Input']);wave(a[1],c(17,'01_hazards'),['qs','qd','qk'],['Static','Dynamic','Weak keeper']);wave(a[2],c(17,'04_async_reset'),['clk','rst','q'],['Clock','Reset','Q']);a[-1].set_xlabel('Time (ns)');save(17,'hazards_and_reset',f)

f,a=sub(2);a=a[:,0]
for ax,i,title in [(a[0],7,'Period 4 ns; source edge 1 ns'),(a[1],8,'Period 2 ns; source edge 0.2 ns')]:wave(ax,c(21,'01_clock_slope',i),['d','qdirect','qbuffer'],['Data','Direct clock','Buffered clock']);ax.set_title(title);ax.set_xlim(2*([4,2][i-7]),6*([4,2][i-7]))
a[-1].set_xlabel('Time (ns)');save(21,'clock_slope',f)
f,a=sub(3,6.3);a=a[:,0]
for ax,i,title in [(a[0],0,'Skew 0 ns'),(a[1],2,'Third clock leads by 0.5 ns'),(a[2],6,'Third clock lags by 0.5 ns')]:wave(ax,c(21,'02_three_stage_skew',i),['d','q2','q3'],['Data','Stage 2','Stage 3'],lim=(20,60));ax.set_title(title)
a[-1].set_xlabel('Time (ns)');save(21,'clock_skew',f)
f,a=sub(2);a=a[:,0]
for ax,i,title in [(a[0],0,'25 C'),(a[1],1,'115 C')]:wave(ax,c(21,'03_low_frequency_retention',i),['clk','x','z','q'],['Clock','Master storage','Slave storage','Q'],unit=1e-6);ax.set_title(title)
a[-1].set_xlabel('Time (us)');save(21,'slow_clock',f)

f,a=sub(2);a=a[:,0];wave(a[0],c(25,'01_charge_sharing'),['a','x','y'],['Input A','Internal node','Dynamic node']);a[0].set_title('Unbuffered dynamic NAND')
wave(a[1],c(25,'05_sharing_remedies'),['y0','y1','y2','y3'],['No keeper','Always on','Feedback','Internal precharge']);a[1].set_title('Matched loaded circuits');a[-1].set_xlabel('Time (ns)');save(25,'charge_sharing',f)
f,a=sub(2);a=a[:,0];rr=R['25']['coupling'];a[0].plot([r['coupling_fF'] for r in rr],[r['dynamic_V'] for r in rr],'-o',label='Dynamic node');a[0].plot([r['coupling_fF'] for r in rr],[r['inverter_V'] for r in rr],'-s',label='Following inverter');a[0].set_xlabel('Coupling capacitance (fF)');a[0].set_ylabel('Voltage at 6 ns (V)');a[0].legend();a[0].grid(alpha=.2)
wave(a[1],c(25,'02_coupling_sweep',4),['noise','y','out','out2'],['Aggressor','Dynamic node','Inverter after dynamic node','Directly coupled inverter output'],lim=(3.8,6.5));a[1].set_title('30 fF coupling: sustained state error versus recovering transient');a[-1].set_xlabel('Time (ns)');save(25,'coupling',f)
f,a=sub(2);a=a[:,0];wave(a[0],c(25,'03_parasitic_coupling'),['y1','y2'],['Upper NMOS gate','Lower NMOS gate']);a[0].set_xlabel('Time (ns)');a[0].set_title('Intrinsic gate coupling without an explicit coupling capacitor')
wave(a[1],c(25,'04_leakage_and_restoration',1),['y0','y1','y2','y3'],['No keeper','Always on','Feedback','Internal precharge'],unit=1e-6);a[1].set_title('Long evaluation at 115 C');a[1].set_xlabel('Time (us)');save(25,'coupling_and_retention',f)
f,a=sub(2);a=a[:,0]
for ax,i,title in [(a[0],0,'500 MHz'),(a[1],1,'50 MHz')]:wave(ax,c(25,'06_keeper_power',i),['clk','y1','y2'],['Clock','Always-on keeper','Feedback keeper']);ax.set_title(title)
a[-1].set_xlabel('Time (ns)');save(25,'keeper_power',f)

f,a=sub(3,6.3);a=a[:,0]
for ax,i,title in [(a[0],0,'Complementary clock skew 0 ns'),(a[1],1,'Complementary clock skew +0.5 ns'),(a[2],2,'Complementary clock skew -0.5 ns')]:wave(ax,c(27,'01_four_topologies',i),['out1','out2','out3','out4'],['(a)','(b)','(c)','(d)'],lim=(8,24));ax.set_title(title)
a[-1].set_xlabel('Time (ns)');save(27,'four_topologies',f)
f,a=sub(3,6.3);a=a[:,0]
for ax,i,title in [(a[0],6,'Input 1, skew 0 ns'),(a[1],7,'Input 1, skew +0.5 ns'),(a[2],8,'Input 1, skew -0.5 ns')]:wave(ax,c(27,'01_four_topologies',i),['out1','out2','out3','out4'],['(a)','(b)','(c)','(d)'],lim=(8,16));ax.set_title(title);ax.axhline(.5,color='grey',ls=':',lw=.8)
a[-1].set_xlabel('Time (ns)');save(27,'fixed_input_glitches',f)

f,a=sub(3,6.3);a=a[:,0];cc=c(28,'01_latch_equivalence');wave(a[0],cc,['clk','d'],['Clock','Input']);wave(a[1],cc,['out1','out3'],['Full N section','Reduced N section']);wave(a[2],cc,['out2','out4'],['Full P section','Reduced P section']);a[-1].set_xlabel('Time (ns)');save(28,'latch_equivalence',f)
f,a=sub(3,6.3);a=a[:,0];cc=c(28,'02_doubled_clocked_inverters');wave(a[0],cc,['clk','d'],['Clock','Input'],lim=(0,16));wave(a[1],cc,['xn','outn'],['First N inverter','N output'],lim=(0,16));wave(a[2],cc,['xp','outp'],['First P inverter','P output'],lim=(0,16));a[-1].set_xlabel('Time (ns)');save(28,'doubled_inverters',f)
f,a=sub(3,6.3);a=a[:,0];cc=c(28,'03_two_stage_dff');wave(a[0],cc,['clk','d'],['Clock','Input']);wave(a[1],cc,['f1','f2'],['Full stage 1','Full stage 2']);wave(a[2],cc,['s1','s2'],['Reduced stage 1','Reduced stage 2']);a[-1].set_xlabel('Time (ns)');save(28,'cascade',f)
f,a=sub(4,7.7);a=a[:,0];cc=c(28,'04_hold_phase_input_changes');wave(a[0],cc,['clk','d'],['Clock','Input']);wave(a[1],cc,['fm1','sm1'],['Full first-latch output','Reduced first-inverter output']);wave(a[2],cc,['f1','s1'],['Full Q1','Reduced Q1']);wave(a[3],cc,['f2','s2'],['Full Q2','Reduced Q2']);a[-1].set_xlabel('Time (ns)');save(28,'input_timing_limit',f)
print(f'Created {count} PDF plots and matching PNG previews')
