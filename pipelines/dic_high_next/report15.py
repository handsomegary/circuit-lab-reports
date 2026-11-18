from pathlib import Path
import json,csv,re,shutil
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
W=Path('work/dic_high_next');R=Path('outputs/Circuit_Labs_Release');F=R/'DIC/Lab15/results'
D=json.loads((W/'data_15.json').read_text())
def c(name,i=0):return D['Lab15_'+name][i]
def m(name,i=0):return c(name,i)['measurements']
def tab(headers,rows):
 return '\\begin{center}\\small\n\\begin{tabular}{'+'l'+'r'*(len(headers)-1)+'}\n\\toprule\n'+' & '.join(headers)+r' \\'+'\n\\midrule\n'+'\n'.join(' & '.join(map(str,row))+r' \\' for row in rows)+'\n\\bottomrule\n\\end{tabular}\n\\end{center}\n'
def fig(name,cap):return '\\begin{figure}[htbp]\\centering\n\\includegraphics[width=.93\\linewidth]{figures/'+name+'.pdf}\n\\caption{'+cap+'}\n\\end{figure}\n'
def csvout(name,rows):
 with (F/(name+'.csv')).open('w',newline='') as f:
  w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
P=[]
for corner,stem,v,t,i in [('TT','01_inverter_tt',1.8,25,0),('FF','02_inverter_ff',1.98,0,0),('SS','03_inverter_ss',1.62,115,0),('FF','02_inverter_ff',1.8,25,1),('SS','03_inverter_ss',1.8,25,1)]:
 q=m(stem,i);P.append(dict(corner=corner,voltage_V=v,temperature_C=t,tphl_ps=q['tphl']*1e12,tplh_ps=q['tplh']*1e12,mean_delay_ps=(q['tphl']+q['tplh'])*5e11,power_uW=q['pavg']*1e6))
csvout('corner_comparison',P)
J=[];Q=[]
for corner,stem in [('TT','04_dc_tt'),('FF','05_dc_ff'),('SS','06_dc_ss'),('SF','07_dc_sf'),('FS','08_dc_fs')]:
 q=m(stem);Q.append(dict(corner=corner,cmos_VOL_V=q['cmos_low'],ratio_VOL_V=q['ratio_low'],ratio_static_power_uW=-q['ratio_static_current']*1.8e6))
 if corner in ['TT','FF','SS']:
  for idx,t in enumerate([25,0,115]):
   q=m(stem,idx);J.append(dict(corner=corner,temperature_C=t,n_raw_A=q['n_junction'],p_raw_A=abs(q['p_junction']),conductance_contribution_A=3.6e-18,n_corrected_A=q['n_junction']-3.6e-18,p_corrected_A=abs(q['p_junction'])-3.6e-18,cmos_low_input_A=abs(q['cmos_off_low']),cmos_high_input_A=abs(q['cmos_off_high'])))
csvout('junction_comparison',J);csvout('ratioed_comparison',Q)
figdir=F/'figures';figdir.mkdir(exist_ok=True)
plt.rcParams.update({'font.size':9,'pdf.fonttype':42})
def save(name,f):
 f.savefig(figdir/(name+'.pdf'),bbox_inches='tight',metadata={'Title':'DIC Lab 15 '+name,'Author':''});f.savefig(figdir/(name+'.png'),bbox_inches='tight',dpi=160);plt.close(f)
f,a=plt.subplots(2,1,figsize=(7.2,5.5),constrained_layout=True)
for stem,label in [('01_inverter_tt','TT / 1.8 V / 25 C'),('02_inverter_ff','FF / 1.98 V / 0 C'),('03_inverter_ss','SS / 1.62 V / 115 C')]:
 cc=c(stem);a[0].plot([r['time_s']*1e9 for r in cc['rows']],[r['out'] for r in cc['rows']],label=label)
a[0].set(xlim=(4.8,7.6),ylabel='Output voltage (V)',xlabel='Time (ns)');a[0].legend();a[0].grid(alpha=.2)
x=np.arange(3);a[1].bar(x-.18,[q['tphl_ps'] for q in P[:3]],.36,label='High to low');a[1].bar(x+.18,[q['tplh_ps'] for q in P[:3]],.36,label='Low to high');a[1].set_xticks(x,['TT nominal','FF cold/high V','SS hot/low V']);a[1].set_ylabel('Delay (ps)');a[1].legend();save('pvt',f)
f,a=plt.subplots(1,2,figsize=(7.2,3.4),constrained_layout=True)
for corner,stem in [('TT','04_dc_tt'),('FF','05_dc_ff'),('SS','06_dc_ss'),('SF','07_dc_sf'),('FS','08_dc_fs')]:
 cc=c(stem);a[0].plot([r['sweep_V'] for r in cc['rows']],[r['outr'] for r in cc['rows']],label=corner)
a[0].set(xlabel='Input (V)',ylabel='Pseudo-NMOS output (V)');a[0].legend();a[0].grid(alpha=.2)
a[1].bar([q['corner'] for q in Q],[q['ratio_VOL_V'] for q in Q]);a[1].set(ylabel='Pseudo-NMOS low output (V)',title='Input 1.8 V, temperature 25 C');save('ratioed',f)
f,a=plt.subplots(1,2,figsize=(7.2,3.3),constrained_layout=True)
j=sorted([x for x in J if x['corner']=='TT'],key=lambda x:x['temperature_C'])
for key,label in [('n_corrected_A','NMOS: two junctions'),('p_corrected_A','PMOS: two junctions')]:a[0].semilogy([x['temperature_C'] for x in j],[x[key] for x in j],'-o',label=label)
a[0].set(xlabel='Temperature (C)',ylabel='Corrected reverse current (A)');a[0].legend();a[0].grid(alpha=.2)
for corner in ['TT','FF','SS']:
 jj=sorted([x for x in J if x['corner']==corner],key=lambda x:x['temperature_C']);a[1].semilogy([x['temperature_C'] for x in jj],[x['cmos_low_input_A'] for x in jj],'-o',label=corner)
a[1].set(xlabel='Temperature (C)',ylabel='CMOS supply current, input low (A)');a[1].legend();a[1].grid(alpha=.2);save('leakage',f)
for lang in ['zh','en']:
 zh=lang=='zh';parts=[]
 def bi(z,e):return z if zh else e
 def sec(z,e):parts.append('\\section{'+bi(z,e)+'}\n')
 def p(z,e):parts.append(bi(z,e)+'\n')
 sec('目的與講義對照','Objectives and handout mapping')
 p('依講義 PDF 第 62--64 頁完成步驟 1 的 FF／TT／SS 延遲與功率比較，問題 1 的混合角落 ratioed logic 比較，以及問題 2 的反偏接面漏電比較。共 8 份網表、17 個實際分析。','Handout PDF pages 62--64 are covered by Step 1 FF/TT/SS delay and power tests, Q1 mixed-corner ratioed-logic tests, and Q2 reverse-junction leakage comparisons. Eight decks contain 17 executed analyses.')
 p('本實驗依使用者選定的 CIC 0.18 µm、1.8 V 元件進行；講義原範例是 0.25 µm、2.5 V，因此結果不是原表格的數值重現。保留講義反相器尺寸 Wn/Wp/L = 0.6/1.8/0.25 µm，名義供應改為 1.8 V。1.98 V 與 1.62 V 為明列的正負 10\\% 教學角落條件；這不等同電壓可靠度認證。','The user-selected CIC 0.18 µm, 1.8 V devices replace the handout example at 0.25 µm and 2.5 V. These results do not reproduce the original numerical table. The handout inverter dimensions Wn/Wp/L = 0.6/1.8/0.25 µm are retained, with nominal supply adapted to 1.8 V. The explicit 1.98 V and 1.62 V conditions implement the teaching ±10\\% sweep, not voltage-reliability qualification.')
 sec('方法與可重現資料','Methods and reproducible data')
 p(r'使用 HSPICE S-2021.09，所有分析完成且未回報 warning、error 或 failed measurement。輸入週期 4 ns、rise/fall 0.2 ns，輸出負載 10 fF；延遲使用第二次邊緣的半供應電壓交越，$t_p=(t_{pHL}+t_{pLH})/2$。功率為 4--12 ns 的平均電源輸入功率。FF、SS 各增加 1.8 V、25°C 的分析以分離製程變化。',r'HSPICE S-2021.09 completed all analyses without reported warnings, errors, or failed measurements. Input period is 4 ns with 0.2 ns edges and a 10 fF load. Delay uses half-supply crossings on the second transition, with $t_p=(t_{pHL}+t_{pLH})/2$. Power is average supply input power from 4 to 12 ns. Additional FF and SS runs at 1.8 V and 25°C isolate process variation.')
 p(r'網表 01--03 為 transient，04--08 為 DC。公開網表僅保留 \texttt{MODEL\_SETUP\_REQUIRED} 與角落名稱註解；模型內容及載入路徑不隨檔案發布，執行前須補入本機設定。所有圖由實際模擬資料繪製；\texttt{results/} 附逐案例 CSV、量測 JSON 與比較 CSV。',r'Decks 01--03 are transient tests and 04--08 are DC tests. Public decks contain only a \texttt{MODEL\_SETUP\_REQUIRED} comment and corner label. Neither model content nor loading paths are distributed; local setup is required before running. Figures use actual simulation data, with per-case CSV, measurement JSON, and comparison CSV files in \texttt{results/}.')
 sec('製程、電壓與溫度結果','Process, voltage, and temperature results')
 parts.append(tab(['Corner','V (V)','T (°C)',r'$t_p$ (ps)',r'$P$ (µW)'],[[q['corner'],q['voltage_V'],q['temperature_C'],f"{q['mean_delay_ps']:.3f}",f"{q['power_uW']:.3f}"] for q in P]))
 parts.append(fig('pvt',bi('前三個合併 PVT 案例的輸出與兩種傳播延遲。','Outputs and both propagation delays for the three combined PVT cases.')))
 p('合併角落的平均延遲依 FF、TT、SS 為 69.853、87.110、159.081 ps；功率為 15.239、11.946、10.150 µW，符合此組條件下快角落較快且較耗電的趨勢。但固定電壓與溫度時，SS 功率 12.232 µW 略高於 TT，顯示功率不能只按 fast/slow 標籤單調排序。輸入頻率、負載充放電與短路電流都會影響結果。','Combined-corner mean delays for FF, TT, and SS are 69.853, 87.110, and 159.081 ps, with powers of 15.239, 11.946, and 10.150 µW. The faster combined corner is faster and consumes more power here. At fixed supply and temperature, however, SS power is 12.232 µW, slightly above TT. Power cannot be ranked universally by fast/slow labels; input frequency, load switching, and short-circuit current all matter.')
 sec('問題 1：ratioed logic 的混合角落','Q1: mixed corners in ratioed logic')
 p('Pseudo-NMOS 的 PMOS 永遠導通，尺寸 0.6/0.5 µm；NMOS 為 0.6/0.25 µm。低電位由上拉與下拉電流平衡決定，故需要檢查 SF、FS。下表為 1.8 V、25°C、輸入 1.8 V；靜態 CMOS 的低電位均接近 0，pseudo-NMOS 則保留可見的直流壓降及功耗。','The pseudo-NMOS PMOS is always on with W/L = 0.6/0.5 µm; the NMOS is 0.6/0.25 µm. Its low output is determined by competing pull-up/down currents, so SF and FS must be checked. The table uses 1.8 V, 25°C, and input 1.8 V. Static CMOS low outputs are near zero, while pseudo-NMOS retains a measurable DC voltage and power.')
 parts.append(tab(['Corner',r'$V_{OL}$ (V)',r'$P_{static}$ (µW)'],[[q['corner'],f"{q['ratio_VOL_V']:.6f}",f"{q['ratio_static_power_uW']:.3f}"] for q in Q]))
 parts.append(fig('ratioed',bi('混合角落造成 ratioed 電路低電位最差點改變。','Mixed corners change the worst low-output condition for the ratioed circuit.')))
 p('本次 SF 的 VOL = 0.172730 V，高於 FF、TT、SS，因此僅檢查三個同向角落會漏掉此項最差結果。對靜態 CMOS 而言，ratio-less 並不代表 SF/FS 永遠不必驗證；切換點、占空比、雜訊容限或其他不對稱規格仍可能受混合角落限制。','SF gives VOL = 0.172730 V, exceeding FF, TT, and SS, so checking only the three same-direction corners would miss this worst result. Ratio-less static CMOS does not make SF/FS universally irrelevant: switching threshold, duty cycle, noise margins, and other asymmetric requirements may still be limited by mixed corners.')
 sec('問題 2：反偏接面漏電','Q2: reverse-junction leakage')
 p(r'另建 NMOS 與 PMOS，D、S、G 短接，使 $V_{DS}=V_{GS}=0$，只反偏兩個 D/B、S/B 接面。每個接面面積 0.15 µm$^2$、周長 1.7 µm，反偏 1.8 V。量測 body 電流，分開列出兩接面總和；沒有把整個反相器的 off-state 電流誤稱為單一接面漏電。',r'Separate NMOS and PMOS test devices tie D, S, and G together, setting $V_{DS}=V_{GS}=0$ while reverse-biasing both D/B and S/B junctions. Each junction has area 0.15 µm$^2$, perimeter 1.7 µm, and reverse bias 1.8 V. Body current measures the two-junction total. Whole-inverter off-state current is not mislabeled as a single junction current.')
 p(r'採用 GMIN = GMINDC = $10^{-18}$ S，兩接面的數值導通貢獻為 $2(1.8)(10^{-18})=3.6\times10^{-18}$ A，從 raw 值明確扣除。另以 $10^{-15}$ S 重跑 TT、25°C，扣除後 NMOS 與 PMOS 均回到相同數值；保留 raw 與校正值於 CSV。0°C 的 raw 值很小，數值導通占比不可忽略。',r'GMIN = GMINDC = $10^{-18}$ S contributes $2(1.8)(10^{-18})=3.6\times10^{-18}$ A across the two junctions; this known numerical contribution is explicitly subtracted from raw results. A TT 25°C rerun at $10^{-15}$ S yields matching corrected NMOS/PMOS currents. Raw and corrected values are retained in CSV. At 0°C, the raw values are tiny and the numerical contribution is significant.')
 parts.append(tab(['T (°C)','N (A)','P (A)'],[[x['temperature_C'],f"{x['n_corrected_A']:.4e}",f"{x['p_corrected_A']:.4e}"] for x in j]))
 parts.append(fig('leakage',bi('左：校正接面漏電；右：反相器供應漏電，兩者不是相同量。','Left: corrected junction leakage. Right: inverter supply leakage; these are different quantities.')))
 p('此模型在相同溫度及接面幾何下，TT／FF／SS 的隔離接面電流相同；溫度造成極大的變化。另一方面，反相器供應漏電會隨角落改變，例如 25°C、輸入低時 FF/TT/SS 分別為 8.429/1.308/0.03975 pA。故不能假設所有漏電機制都具有 FF > TT > SS 的相同排序。','For this model and identical temperature/junction geometry, isolated junction currents are identical across TT/FF/SS, while temperature has a very large effect. Inverter supply leakage does vary with corner: at 25°C with low input, FF/TT/SS are 8.429/1.308/0.03975 pA. Different leakage mechanisms therefore cannot be assumed to share the same FF > TT > SS ranking.')
 sec('結論與限制','Conclusions and limits')
 p('已完成講義的角落延遲、功耗及兩個問題。結果僅對此模型、尺寸、負載與明列刺激成立；未宣稱原 0.25 µm 數值重現、完整 PVT 簽核、統計良率或版圖後模擬。沒有在本實驗改動其他 lab 的模型。','The corner delay/power experiment and both questions are completed. Results apply to the selected model, geometry, load, and stated stimulus. They do not establish reproduction of the original 0.25 µm values, complete PVT signoff, statistical yield, or post-layout behavior. Other labs retain their original model.')
 body='\n'.join(parts);assert not re.search(r'private_model_tag|hspui|[CD]:[\\/]',body,re.I)
 folder=R/'reports/DIC15'/lang;folder.mkdir(exist_ok=True);(folder/'body.tex').write_text(body,encoding='utf-8');(W/'report_bodies'/f'DIC15_{lang}.tex').write_text(body,encoding='utf-8')
 (folder/'figures').mkdir(exist_ok=True)
 for pth in figdir.glob('*.pdf'):shutil.copy2(pth,folder/'figures'/pth.name)
 main=folder/'main.tex';s=main.read_text(encoding='utf-8').replace('Process Corners, Threshold Voltage and Leakage','Process Corners and Junction Leakage').replace('製程角落、臨界電壓與漏電','製程角落與接面漏電');main.write_text(s,encoding='utf-8')
# Remove superseded tentative-model results from public Lab15 and its report figures.
archive=W/'superseded_lab15_results';archive.mkdir(exist_ok=True)
for p in F.rglob('*'):
 if p.is_file() and (p.name.startswith(('01_voltage_temperature','02_off_state_current')) or p.name in ['environment_comparison.csv','off_current.csv','environment.pdf','environment.png']):
  shutil.copy2(p,archive/p.name);p.unlink()
for lang in ['zh','en']:
 p=R/'reports/DIC15'/lang/'figures/environment.pdf'
 if p.exists():p.unlink()
print('Lab15: bilingual bodies, three figures, comparison CSVs installed')
