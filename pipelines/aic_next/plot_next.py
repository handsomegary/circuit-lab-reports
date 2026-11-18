from pathlib import Path
import json,sys
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
ROOT=Path(__file__).resolve().parents[2]
BASE=ROOT/'outputs/Circuit_Labs_Release/AIC'
plt.rcParams.update({'font.size':9,'axes.spines.top':False,'axes.spines.right':False,'axes.grid':True,'grid.alpha':.22,'savefig.bbox':'tight','legend.fontsize':7.5})
def plot(ax,rows,x,y,label,scale=1,**kw):
    ax.plot([r[x]*scale for r in rows],[r[y] for r in rows],label=label,**kw)
def ac(ax,c,label,col='mag_out',**kw):
    ax.semilogx([r['frequency_Hz'] for r in c['ac']],20*np.log10(np.maximum([r[col] for r in c['ac']],1e-30)),label=label,**kw)
def finish(fig,folder,name):
    for ax in fig.axes:
        if ax.get_legend_handles_labels()[0]:ax.legend()
    fig.tight_layout();fig.savefig(folder/(name+'.pdf'),metadata={'Title':name.replace('_',' '),'Author':'Circuit lab report'});fig.savefig(folder/(name+'.png'),dpi=160);plt.close(fig)
def draw(lab):
    folder=BASE/f'Lab{lab:02d}'/'results';d=json.loads((folder/'simulation_data.json').read_text());out=folder/'figures';out.mkdir(exist_ok=True)
    if lab==2:
        f,a=plt.subplots(1,2,figsize=(7.2,3.1))
        for i,c in enumerate(d['01_two_device_divider']):plot(a[0],c['dc'],'sweep','v_vref',['Baseline','PMOS width x2','NMOS width x2'][i])
        for i,c in enumerate(d['02_three_device_divider']):
            plot(a[1],c['dc'],'sweep','v_low',f'Case {i}, lower',ls='-');plot(a[1],c['dc'],'sweep','v_high',f'Case {i}, upper',ls='--')
        for ax in a:ax.set(xlabel='Supply voltage (V)',ylabel='Reference voltage (V)')
        a[0].set_title('Two-device divider');a[1].set_title('Three-device divider');finish(f,out,'reference_dividers')
        f,a=plt.subplots(1,2,figsize=(7.2,3.2))
        for i in range(3):plot(a[0],d['05_complete_reference'][i]['dc'],'sweep','v_vref',['27 C','-20 C','85 C'][i])
        for i,c in enumerate(d['06_complete_startup']):plot(a[1],c['tran'],'time_s','v_vref',['1 us ramp, 27 C','30 us ramp, 27 C','1 us ramp, -20 C','1 us ramp, 85 C','Startup disconnected'][i],scale=1e6)
        a[0].set(xlabel='Supply voltage (V)',ylabel='Reference voltage (V)',title='Supply and temperature dependence');a[1].set(xlabel='Time (us)',ylabel='Reference voltage (V)',xlim=(0,40),title='Power-up from zero charge');finish(f,out,'reference_startup')
    if lab==3:
        f,a=plt.subplots(2,2,figsize=(7.2,5.3))
        for i,c in enumerate(d['01_p_diode_load']):ac(a[0,0],c,f'W1={[100,200,300][i]} um')
        for i,c in enumerate(d['02_n_diode_load']):ac(a[0,1],c,f'W1={[150,200,300][i]} um')
        for i in [0,1,2]:ac(a[1,0],d['03_current_source_load'][i],f'W1={[10,18,26][i]} um')
        for i,label in [(0,'100 uA'),(3,'166 uA'),(4,'333 uA'),(7,'10 uA adapted')]:ac(a[1,1],d['03_current_source_load'][i],label)
        for ax in a.flat:ax.set(xlabel='Frequency (Hz)',ylabel='Gain magnitude (dB)',xlim=(1,1e9));ax.axhline(0,color='gray',lw=.6)
        for ax,title in zip(a.flat,['PMOS diode load','NMOS diode load','Current load: width sweep','Current load: current sweep']):ax.set_title(title)
        finish(f,out,'gain_comparison')
        f,a=plt.subplots(1,2,figsize=(7.2,3.2))
        for i in [0,1]:
            for p in ['n','p']:ac(a[0],d['04_source_followers'][i],f'{p.upper()}MOS, {[100,10][i]} uA','mag_o'+p)
        for i,c in enumerate(d['05_small_signal_transient']):plot(a[1],c['tran'],'time_s','v_out',['0.1 mV input','1 mV input','3 mV input'][i],scale=1e3)
        a[0].set(xlabel='Frequency (Hz)',ylabel='Follower gain (dB)',xlim=(1,1e9),ylim=(-30,2));a[1].set(xlabel='Time (ms)',ylabel='CS output (V)',xlim=(4,5));finish(f,out,'followers_transient')
    if lab==4:
        f,a=plt.subplots(1,2,figsize=(7.2,3.2))
        for k,i,label in [('01_basic_differential',6,'Basic'),('02_load_cascode',0,'Load cascode'),('03_full_cascode',0,'Full cascode')]:ac(a[0],d[k][i],label)
        cs=d['01_basic_differential'];freq=[r['frequency_Hz'] for r in cs[0]['ac']];g=np.array([r['db_out'] for r in cs[0]['ac']])
        for i,label in [(1,'CMRR'),(2,'PSRR+'),(3,'PSRR-')]:a[1].semilogx(freq,g-np.array([r['db_out'] for r in cs[i]['ac']]),label=label)
        a[0].set(xlabel='Frequency (Hz)',ylabel='Differential gain (dB)',title='Matched 0.5 uA reference');a[1].set(xlabel='Frequency (Hz)',ylabel='Rejection (dB)',title='Basic amplifier, 50 uA reference');finish(f,out,'voltage_amplifiers')
        f,a=plt.subplots(1,2,figsize=(7.2,3.2));cs=d['05_current_amplifiers']
        for p,label in [('s','Simple'),('c','Cascode'),('d','Differential')]:ac(a[0],cs[1],label,'imag_imag_'+p)
        for i,label in [(1,'Output W=100 um'),(2,'Output W=1000 um'),(3,'Output W=10000 um')]:ac(a[1],cs[i],label,'imag_imag_s')
        for ax in a:ax.set(xlabel='Frequency (Hz)',ylabel='Current gain (dB)',xlim=(1,1e10))
        a[0].set_title('Three current amplifiers, biased 1 kohm');a[1].set_title('Simple current-amplifier width sweep');finish(f,out,'current_amplifiers')
    if lab==5:
        f,a=plt.subplots(1,2,figsize=(7.2,3.2));cs=d['01_open_loop_compensation'];labels=['No compensation','2 pF','2 pF + 330 ohm','10 pF + 330 ohm']
        for i,label in enumerate(labels):
            ac(a[0],cs[i],label);ph=np.unwrap(np.deg2rad([r['phase_out'] for r in cs[i]['ac']]))*180/np.pi;a[1].semilogx([r['frequency_Hz'] for r in cs[i]['ac']],ph,label=label)
        a[0].set(xlabel='Frequency (Hz)',ylabel='Open-loop gain (dB)',xlim=(10,1e9),ylim=(-40,90));a[0].axhline(0,color='k',lw=.5)
        a[1].set(xlabel='Frequency (Hz)',ylabel='Unwrapped phase (deg)',xlim=(10,1e9),ylim=(-250,10));a[1].axhline(-180,color='k',lw=.5);finish(f,out,'compensation')
        f,a=plt.subplots(2,2,figsize=(7.2,5.4))
        for i,c in enumerate(d['03_unity_buffer_dc']):plot(a[0,0],c['dc'],'sweep','v_out',['Capacitive load only','100 kohm','10 kohm'][i])
        a[0,0].plot([0,1],[0,1],'k--',lw=.7,label='Ideal');a[0,0].set(xlabel='Buffer input (V)',ylabel='Buffer output (V)')
        for i,c in enumerate(d['04_inverting_output_swing']):plot(a[0,1],c['dc'],'sweep','v_out',['Capacitive load only','100 kohm','10 kohm'][i])
        a[0,1].set(xlabel='Inverting input (V)',ylabel='Output (V)')
        for i,c in enumerate(d['05_unity_buffer_steps']):
            for ax in a[1]:plot(ax,c['tran'],'time_s','v_out',labels[i],scale=1e6)
        plot(a[1,0],d['05_unity_buffer_steps'][0]['tran'],'time_s','v_ip','Input',scale=1e6,color='k',ls='--',lw=.7)
        a[1,0].set(xlabel='Time (us)',ylabel='Output (V)',xlim=(.99,1.15));a[1,1].set(xlabel='Time (us)',ylabel='Output (V)',xlim=(2.99,3.15));finish(f,out,'closed_loop')
if __name__=='__main__':
    for lab in sys.argv[1:]:draw(int(lab))
