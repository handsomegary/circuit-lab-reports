from pathlib import Path
import json
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
ROOT=Path(__file__).resolve().parents[2];PUB=ROOT/'outputs/Circuit_Labs_Release/DIC'
plt.rcParams.update({'font.size':9,'axes.spines.top':False,'axes.spines.right':False,'axes.grid':True,'grid.alpha':.2,'legend.fontsize':7,'savefig.bbox':'tight'})
def load(lab):
 p=PUB/f'Lab{lab:02d}'/'results';idx=json.loads((p/'simulation_data.json').read_text());return p,{k:json.loads((p/v).read_text())for k,v in idx['files'].items()},json.loads((p/'summary.json').read_text())
def trace(ax,c,node,label,scale=1):ax.plot([r['time_s']*1e9 for r in c['tran']],[r['v_'+node]*scale for r in c['tran']],label=label)
def finish(fig,p,name):
 for ax in fig.axes:
  if ax.get_legend_handles_labels()[0]:ax.legend()
 fig.tight_layout();dest=p/'figures';dest.mkdir(exist_ok=True);fig.savefig(dest/(name+'.pdf'),metadata={'Title':name.replace('_',' '),'Author':'Circuit lab report'});fig.savefig(dest/(name+'.png'),dpi=150);plt.close(fig)
def lab19():
 p,d,s=load(19);cs=d['01_ir_drop_decoupling'];labels=['No added C','10 pF','100 pF','1 nF'];f,a=plt.subplots(2,2,figsize=(7.2,5))
 for c,lab in zip(cs,labels):
  for ax,node in [(a[0,0],'vp'),(a[0,1],'vn')]:trace(ax,c,node,lab)
  a[1,0].plot([r['time_s']*1e9 for r in c['tran']],[r['v_vp']-r['v_vn']for r in c['tran']],label=lab)
  a[1,1].plot([r['time_s']*1e9 for r in c['tran']],[r['i_rp']*1e3 for r in c['tran']],label=lab)
 for ax,title,y in zip(a.flat,['Internal supply','Internal ground','Differential rail','External supply current'],['VDD internal (V)','GND internal (V)','VDD - GND (V)','Current (mA)']):ax.set(xlim=(4,12),xlabel='Time (ns)',ylabel=y,title=title)
 finish(f,p,'supply_decoupling')
def lab20():
 p,d,s=load(20);f,a=plt.subplots(1,2,figsize=(7.2,3.1));cs=d['01_chain_pulse_filter'];trace(a[0],cs[0],'in','Input');trace(a[0],cs[0],'n4','Four-stage output');a[0].set(xlim=(.9,2.9),xlabel='Time (ns)',ylabel='Voltage (V)',title='Delay and 10-90% edges')
 for c,lab in zip(cs[1:],['100 ps','50 ps','20 ps','10 ps','5 ps']):trace(a[1],c,'n4',lab)
 a[1].set(xlim=(.95,1.9),xlabel='Time (ns)',ylabel='Output (V)',title='Narrow pulse attenuation');finish(f,p,'chain_timing')
 f,a=plt.subplots(1,2,figsize=(7.2,3.1))
 for ax,kind in zip(a,['setup','hold']):
  for target in [0,1]:
   rr=sorted([r for r in s['metrics']if r.get('kind')==kind and r['target']==target],key=lambda r:r['offset_ps']);ax.plot([r['offset_ps']for r in rr],[r['q_capture']for r in rr],'.-',label=f'Target={target}')
  ax.axhline(.1,color='gray',ls='--',lw=.6);ax.axhline(.9,color='gray',ls='--',lw=.6);ax.set(xlabel=f'{kind.title()} offset (ps)',ylabel='Captured Q at 1.8 ns (V)',title=f'{kind.title()} sweep, 10 ps grid')
 finish(f,p,'dff_boundaries')
def lab22():
 p,d,s=load(22);f,a=plt.subplots(1,2,figsize=(7.2,3.1));cs=d['02_mux_delay_load'];rr=[r for r in s['metrics']if r['deck'].startswith('02')];loads=[10,1,50,100,500];order=np.argsort(loads)
 for tag,lab in [('g','Lecture TG'),('c','Static CMOS'),('f','Wide TG tree')]:
  trace(a[0],cs[0],'o'+tag,lab);a[1].plot(np.array(loads)[order],[max(rr[i]['rise_'+tag],rr[i]['fall_'+tag])*1e12 for i in order],'o-',label=lab)
 trace(a[0],cs[0],'a0','Input');a[0].set(xlim=(.95,1.8),xlabel='Time (ns)',ylabel='Voltage (V)',title='Selected data edge, 10 fF');a[1].set(xlabel='Output load (fF)',ylabel='Max rise/fall delay (ps)',title='Data-path load sweep');finish(f,p,'mux_delay_load')
 f,a=plt.subplots(1,2,figsize=(7.2,3.1));c=d['01_mux_truth_table'][0]
 for tag,lab in [('g','Lecture TG'),('c','Static CMOS'),('f','Wide TG tree')]:trace(a[0],c,'o'+tag,lab)
 a[0].set(xlim=(26,48),xlabel='Time (ns)',ylabel='MUX output (V)',title='Representative truth-test transitions')
 rr=s['metrics'][0];names=['Lecture TG','Static CMOS','Wide TG tree'];x=np.arange(3)
 a[1].bar(x-.18,[rr['power_'+p]*1e6 for p in'gcf'],.36,label='Supply only');a[1].bar(x+.18,[rr['combined_power_'+p]*1e6 for p in'gcf'],.36,label='Supply + data');a[1].set(xticks=x,xticklabels=names,ylabel='Average power (uW)',title='64-code stimulus; ideal select excluded');finish(f,p,'mux_function_power')
def lab23():
 p,d,s=load(23);f,a=plt.subplots(1,2,figsize=(7.2,3.1));cs=d['01_two_to_four_load'];c=cs[0]
 for prefix,ls in [('n','-'),('r','--')]:
  for j in [1,2]:a[0].plot([r['time_s']*1e9 for r in c['tran']],[r[f'v_{prefix}{j}']for r in c['tran']],ls,label=f'{"NAND"if prefix=="n"else"NOR"}, D{j}')
 a[0].set(xlim=(1.8,6.8),xlabel='Time (ns)',ylabel='Output (V)',title='2-to-4 at 10 fF')
 rr=[r for r in s['metrics']if r['deck'].startswith('01')]
 for prefix,label in [('n','NAND + inverter'),('r','NOR')]:
  a[1].plot([10,50,100,500],[r['rise_'+prefix]*1e12 for r in rr],'o-',label=label+' rise');a[1].plot([10,50,100,500],[r['fall_'+prefix]*1e12 for r in rr],'x--',label=label+' fall')
 a[1].set(xlabel='Load per output (fF)',ylabel='Delay (ps)',title='500 fF fails settled 0.1/0.9 V check');finish(f,p,'decoder_load')
 f,a=plt.subplots(1,2,figsize=(7.2,3.1));c=d['04_eight_to_256_timing'][0]
 for prefix,label in [('t','Two logic stages'),('h','Three logic stages')]:trace(a[0],c,prefix+'1',label)
 trace(a[0],c,'a0','Input A0');a[0].set(xlim=(4.9,7),xlabel='Time (ns)',ylabel='Output 1 (V)',title='8-to-256, 0 -> 1, 10 fF')
 rows=d['03_eight_to_256_truth'][0]['dc']
 for prefix,label in [('t','Two stages'),('h','Three stages')]:
  code=[sum(round(r[f'v_a{b}'])*(1<<b)for b in range(8))for r in rows];active=[r[f'v_{prefix}{k}']for r,k in zip(rows,code)];inactive=[max(r[f'v_{prefix}{j}']for j in range(256)if j!=k)for r,k in zip(rows,code)]
  a[1].plot(code,active,label=label+' active');a[1].plot(code,inactive,'--',label=label+' max inactive')
 a[1].set(xlabel='Input code',ylabel='DC output voltage (V)',title='Every code, every output checked');finish(f,p,'hierarchical_decoder')
if __name__=='__main__':
 lab19();lab20();lab22();lab23();print('Seven figure pairs written.')
