from analyze import *
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
plt.rcParams.update({'font.size':9,'axes.titlesize':10,'axes.labelsize':9,'legend.fontsize':7,'axes.spines.top':False,'axes.spines.right':False})
def data(lab,stem,kind,case=0):
    return np.genfromtxt(OUT/f'Lab{lab:02d}'/'results'/f'{stem}_{kind}_{case}.csv',delimiter=',',names=True)
def m(lab,stem,case=0,typ='mt'):
    return meas(SIM/f'DIC_Lab{lab:02d}_{stem}.{typ}{case}')[0]
def fig(lab,name,f):
    d=OUT/f'Lab{lab:02d}'/'results'/'figures';d.mkdir(exist_ok=True)
    for ax in f.axes:ax.grid(alpha=.2)
    f.tight_layout();f.savefig(d/(name+'.pdf'),metadata={'Title':f'DIC {lab}: {name}','Author':'','Creator':'Scientific result plotting'})
    f.savefig(ROOT/'work'/'dic_next'/(name+'.png'),dpi=140);plt.close(f)
f,axs=plt.subplots(1,2,figsize=(7.3,3.1))
for k,cc in enumerate([0,2,5,10]):
    a=data(5,'01_miller','time',k)
    for ax,(lo,hi) in zip(axs,[(.9,1.8),(3,4)]):
        s=(a['time_s']*1e9>=lo)&(a['time_s']*1e9<=hi);ax.plot(a['time_s'][s]*1e9,a['y'][s],label=f'Cc={cc} fF')
for ax in axs:ax.set(xlabel='Time (ns)',ylabel='Stage 2 output (V)');ax.legend()
axs[0].set_title('Undershoot before rising output');axs[1].set_title('Overshoot before falling output');fig(5,'miller_waveforms',f)
f,axs=plt.subplots(1,2,figsize=(7.3,3.1))
for ax,ks,x,label in [(axs[0],range(4),[0,2,5,10],'Coupling capacitance (fF)'),(axs[1],[2,4,5],[0,10,40],'Added output load (fF)')]:
    for field,label2 in [('overshoot','Overshoot'),('undershoot','Undershoot')]:ax.plot(x,[m(5,'01_miller',k)[field]*1000 for k in ks],'o-',label=label2)
    ax.set(xlabel=label,ylabel='Peak beyond rail (mV)');ax.legend()
axs[1].set_title('Cc fixed at 5 fF');fig(5,'miller_load_comparison',f)
f,axs=plt.subplots(1,2,figsize=(7.3,3.1))
for ax,k in zip(axs,[0,3]):
    a=data(6,'01_gate_load','time',k);s=(a['time_s']>=.8e-9)&(a['time_s']<=4.5e-9)
    for n,label in [('in','Input'),('ymos','MOS load'),('ycap','Fixed capacitor')]:ax.plot(a['time_s'][s]*1e9,a[n][s],label=label)
    ax.set(title=f'{k+1} doubled inverter load(s)',xlabel='Time (ns)',ylabel='Voltage (V)');ax.legend()
fig(6,'gate_load_waveforms',f)
f,axs=plt.subplots(1,2,figsize=(7.3,3.1))
for ax,edge in zip(axs,['tphl','tplh']):
    for n,l in [('ymos','MOS load'),('ycap','8 fF per load')]:ax.plot(range(1,5),[m(6,'01_gate_load',k)[edge+'_'+n]*1e12 for k in range(4)],'o-',label=l)
    ax.set(title=edge,xlabel='Number of loads',ylabel='50% propagation delay (ps)',xticks=range(1,5));ax.legend()
fig(6,'gate_load_delays',f)
f,axs=plt.subplots(1,2,figsize=(7.3,3.1));a=data(8,'01_dc_transfer','volt')
for i,r in enumerate([.75,3,12]):
    axs[0].plot(a['in'],a[f'y{i}'],label=f'Wp/Wn={r}')
    axs[1].plot(a['in'],np.gradient(a[f'y{i}'],a['in']),label=f'{r}')
axs[0].set(xlabel='Input (V)',ylabel='Output (V)');axs[0].legend()
axs[1].axhline(-1,color='k',ls='--',lw=.8);axs[1].set(xlabel='Input (V)',ylabel='dVout/dVin',ylim=(-5,0),xlim=(.25,.7));axs[1].legend(title='Wp/Wn')
fig(8,'inverter_transfer',f)
f,axs=plt.subplots(2,1,figsize=(7.3,4.4),sharex=True);a=data(8,'02_noise_cascade','time')
for ax,prefix,title in zip(axs,['y','z'],['First inverter output','Second inverter output']):
    ax.plot(a['time_s']*1e9,a['in'],'k--',lw=.8,label='Input')
    for i,r in enumerate([.75,3,12]):ax.plot(a['time_s']*1e9,a[f'{prefix}{i}'],label=f'Wp/Wn={r}')
    ax.set(ylabel='Voltage (V)',title=title);ax.legend(ncol=4)
axs[-1].set_xlabel('Time (ns)');fig(8,'noise_regeneration',f)
f,axs=plt.subplots(1,2,figsize=(7.3,3.1))
for ax,stem in zip(axs,['02_nand','03_nor']):
    a=data(9,stem,'volt')
    for n,l in [('yboth','A=B'),('ya','A switched'),('yb','B switched')]:ax.plot(a['in'],a[n],label=l)
    ax.set(title=stem[3:].upper()+', stack factor 2',xlabel='Input (V)',ylabel='Output (V)');ax.legend()
fig(9,'gate_transfer',f)
f,axs=plt.subplots(1,2,figsize=(7.3,3.3))
order=[1,0,2,3];xx=[1.5,2,2.5,3]
for stem,color in [('02_nand','C0'),('03_nor','C1')]:
    for edge,style in [('tr','-'),('tf','--')]:
        yy=[max(m(9,stem,k)[edge+'_a'],m(9,stem,k)[edge+'_b'])*1e12 for k in order]
        axs[0].plot(xx,yy,'o'+style,color=color,label=stem[3:].upper()+' '+edge)
axs[0].set(xlabel='Stack width factor',ylabel='Worst single-input slew (ps)');axs[0].legend()
mm=m(9,'04_sizing_refinement',2);ys=['yr','yna','ynb','yoa','yob'];x=np.arange(5)
axs[1].bar(x-.17,[mm['tr_'+y]*1e12 for y in ys],.34,label='Rise');axs[1].bar(x+.17,[mm['tf_'+y]*1e12 for y in ys],.34,label='Fall')
axs[1].set(xticks=x,xticklabels=['INV','NAND A','NAND B','NOR A','NOR B'],ylabel='Slew (ps)',title='Selected refined sizes');axs[1].tick_params(axis='x',rotation=25);axs[1].legend();fig(9,'gate_sizing',f)
f,axs=plt.subplots(1,2,figsize=(7.3,3.1));a=data(12,'01_delay_elements','time');s=(a['time_s']>=.8e-9)&(a['time_s']<=3e-9)
for k in range(1,5):axs[0].plot(a['time_s'][s]*1e9,a[f'n{k}_5'][s],label=f'Case {k}')
axs[0].set(xlabel='Time (ns)',ylabel='Stage 5 output (V)');axs[0].legend()
mm=m(12,'01_delay_elements');x=np.arange(1,5)
for edge,off in [('tphl',-.17),('tplh',.17)]:axs[1].bar(x+off,[mm[f'{edge}_case{k}']*1e9 for k in x],.34,label=edge)
axs[1].set(xlabel='Handout case',ylabel='Input-to-stage-5 delay (ns)',xticks=x);axs[1].legend();fig(12,'delay_elements',f)
f,axs=plt.subplots(1,2,figsize=(7.3,3.1))
for edge in ['tphl','tplh']:
    axs[0].plot([2,3,4,5],[m(12,'02_taper_buffer',k)[edge+'_n5']*1e9 for k in range(4)],'o-',label=edge)
axs[0].set(xlabel='Taper factor n',ylabel='Propagation delay (ns)',xticks=[2,3,4,5]);axs[0].legend()
for k,n in enumerate([2,3,4,5]):
    a=data(12,'02_taper_buffer','time',k);s=(a['time_s']>=1.8e-9)&(a['time_s']<=6e-9)
    axs[1].plot(a['time_s'][s]*1e9,a['n5'][s],label=f'n={n}')
axs[1].set(xlabel='Time (ns)',ylabel='Stage 5 output (V)');axs[1].legend();fig(12,'taper_buffer',f)
f,axs=plt.subplots(1,2,figsize=(7.3,3.2))
for k in range(6):
    a=data(14,'01_hysteresis','volt',k);axs[0].plot(a['in'],a['ys1'],color=f'C{k%3}',ls='-' if k<3 else '--',label=f'Feedback {k+1}' if k<3 else None)
axs[0].plot(a['in'],a['yi'],'k:',label='Inverter');axs[0].set(xlabel='Input (V)',ylabel='Output (V)',title='Independent DC branches');axs[0].legend()
for k in range(2):
    a=data(14,'05_alternative_dc','volt',k);axs[1].plot(a['in'],a['ya'],label='Up' if k==0 else 'Down')
axs[1].set(title='Alternative architecture',xlabel='Input (V)',ylabel='Output (V)');axs[1].legend();fig(14,'schmitt_hysteresis',f)
f,axs=plt.subplots(1,2,figsize=(7.3,3.4));a=data(14,'02_noise_immunity','time')
for n,label in [('in','Input'),('yi','INV'),('ys1','SCH 1'),('ys3','SCH 3'),('ya','Alternative')]:axs[0].plot(a['time_s']*1e9,a[n],label=label,lw=.9)
axs[0].set(xlabel='Time (ns)',ylabel='Voltage (V)',xlim=(4.7,8.4));axs[0].legend()
ys=['yi','ys1','ys2','ys3','ya'];x=np.arange(5);mm=m(14,'03_delay_comparison')
for edge,off in [('tphl',-.17),('tplh',.17)]:axs[1].bar(x+off,[mm[edge+'_'+y]*1e12 for y in ys],.34,label=edge)
axs[1].set(xticks=x,xticklabels=['INV','SCH 1','SCH 2','SCH 3','Alt'],ylabel='Propagation delay (ps)');axs[1].tick_params(axis='x',rotation=20);axs[1].legend();fig(14,'schmitt_noise_delay',f)
print('Wrote 12 figures')
