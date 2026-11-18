from pathlib import Path
import json,csv,re,shutil
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
W=Path('work/dic_high_next');R=Path('outputs/Circuit_Labs_Release');F=R/'DIC/Lab26/results';D=json.loads((W/'data_26.json').read_text())
def c(name,i=0):return D['Lab26_'+name][i]
def m(name,i=0):return c(name,i)['measurements']
def tab(headers,rows):return '\\begin{center}\\small\n\\begin{tabular}{'+'l'+'r'*(len(headers)-1)+'}\n\\toprule\n'+' & '.join(headers)+r' \\'+'\n\\midrule\n'+'\n'.join(' & '.join(map(str,row))+r' \\' for row in rows)+'\n\\bottomrule\n\\end{tabular}\n\\end{center}\n'
def fig(name,cap):return '\\begin{figure}[htbp]\\centering\n\\includegraphics[width=.93\\linewidth]{figures/'+name+'.pdf}\n\\caption{'+cap+'}\n\\end{figure}\n'
N=[]
for i,cf in enumerate([10,.001,2,5,15,20,30]):
 q=m('02_noise_immunity',i);N.append(dict(coupling_fF=cf,**{k:v for k,v in q.items() if k not in ['temper','alter#']}))
with (F/'noise_comparison.csv').open('w',newline='') as f:
 wr=csv.DictWriter(f,fieldnames=list(N[0]));wr.writeheader();wr.writerows(N)
P=F/'figures';P.mkdir(exist_ok=True);plt.rcParams.update({'font.size':9,'pdf.fonttype':42})
def plot(ax,case,nodes,labels=None):
 rr=case['rows'];t=[r['time_s']*1e9 for r in rr]
 for n,label in zip(nodes,labels or nodes):ax.plot(t,[r[n] for r in rr],label=label)
 ax.set_ylabel('Voltage (V)');ax.legend(ncol=3);ax.grid(alpha=.2)
def save(name,f):
 f.savefig(P/(name+'.pdf'),bbox_inches='tight',metadata={'Title':'DIC Lab26 '+name,'Author':''});f.savefig(P/(name+'.png'),bbox_inches='tight',dpi=160);plt.close(f)
f,a=plt.subplots(2,1,figsize=(7.2,4.6),constrained_layout=True);plot(a[0],c('01_unsafe_cascade'),['clk','a']);plot(a[1],c('01_unsafe_cascade'),['x','y']);a[1].axhline(.8,ls=':',c='grey');a[1].set_xlabel('Time (ns)');save('unsafe_cascade',f)
f,a=plt.subplots(3,1,figsize=(7.2,6),constrained_layout=True);cc=c('02_noise_immunity');plot(a[0],cc,['clk','q'],['Clock','Aggressor']);plot(a[1],cc,['nx','ny','nz','nout']);plot(a[2],cc,['px','py','pz','pout']);a[2].set_xlabel('Time (ns)');save('equal_noise',f)
f,a=plt.subplots(1,2,figsize=(7.2,3.5),constrained_layout=True);q=sorted(N,key=lambda x:x['coupling_fF']);a[0].plot([x['coupling_fF'] for x in q],[x['n_peak'] for x in q],'-o',label='N domino');a[0].plot([x['coupling_fF'] for x in q],[x['p_peak'] for x in q],'-s',label='N-P cascade');a[0].set(xlabel='Coupling (fF)',ylabel='Peak output (V)');a[0].legend();a[0].grid(alpha=.2);plot(a[1],c('03_speed_comparison'),['a','nout','pout'],['Input','N domino','N-P cascade']);a[1].set(xlim=(3.8,5.2),xlabel='Time (ns)');a[1].legend(ncol=1,loc='lower right',fontsize=8);save('sweep_and_speed',f)
for lang in ['zh','en']:
 zh=lang=='zh';parts=[]
 def bi(z,e):return z if zh else e
 def sec(z,e):parts.append('\\section{'+bi(z,e)+'}\n')
 def p(z,e):parts.append(bi(z,e)+'\n')
 sec('目的與講義要求','Objectives and handout requirements')
 p('依講義 PDF 第 107--110 頁，網表 01 重現圖 26.1 同型動態電路直接串接的錯誤；02 依圖 26.4/26.5 加入相同 10 fF 耦合雜訊並掃描強度；03 回答問題 1 的速度比較。三份網表共 9 個分析，均完成且無 error 或 failed measurement。模擬器仍回報加密區塊的警告內容被隱藏，不能將其解讀為模型完全無警告。','Following handout PDF pages 107--110, deck 01 tests the unsafe same-type cascade in Fig.26.1; deck 02 compares Figs.26.4/26.5 under equal 10 fF coupling and a strength sweep; deck 03 answers Q1 on speed. The three decks contain nine completed analyses without errors or failed measurements. The simulator reports suppressed encrypted-block warning details, which does not establish a warning-free model.')
 sec('電路、測試條件與判讀','Circuits, conditions, and interpretation')
 p('以提供模型、1.0 V、25°C 為教學條件，並非已認證額定電壓或原講義 2.5 V 製程重現。除網表另註，Wn/Wp/L = 0.6/1.8/0.25 µm，輸出負載 5 fF；時脈週期 10 ns、邊緣 20 ps。採 0.2/0.8 V 作明列的低／高判讀準則；這是本報告診斷門檻，並非已萃取接收器雜訊容限。','The supplied model is evaluated at a declared teaching condition of 1.0 V and 25°C, not a certified voltage rating or reproduction of the original 2.5 V process. Unless stated otherwise, Wn/Wp/L = 0.6/1.8/0.25 µm and output load is 5 fF. The clock period is 10 ns with 20 ps edges. Declared low/high diagnostic thresholds are 0.2/0.8 V; these are not extracted receiver noise margins.')
 p('同型 N-domino 使用兩個四電晶體動態 NAND（第二輸入固定高），每級接靜態反相器；N-P 鏈則直接串接四個 N/P 動態級。各鏈完成相同的非反相邏輯，輸出負載相同；N-domino 共 12 顆、N-P 鏈共 16 顆核心電晶體。這是照講義拓樸比較，並非相同電晶體數或最佳化邏輯努力的比較。','The N-only domino uses two four-transistor dynamic NAND gates with their second inputs tied high, each followed by a static inverter. The N-P chain directly alternates four N/P dynamic stages. Both implement noninverting logic with equal output loads. The N-domino core contains 12 transistors and the N-P core 16. This compares the handout topologies, not equal transistor counts or optimized logical effort.')
 p(r'所有網表只保留 \texttt{MODEL\_SETUP\_REQUIRED} 註解；執行前須自行補入本機模型設定。公開檔案不含模型內容或載入路徑。圖由實際列印資料重繪，逐案例 CSV 與量測 JSON 置於 \texttt{results/}。',r'Every public deck contains only a \texttt{MODEL\_SETUP\_REQUIRED} comment; local model setup is required before execution. Neither model content nor loading paths are distributed. Figures use actual printed data; per-case CSV and measurement JSON files are in \texttt{results/}.')
 sec('步驟 1：錯誤串接','Step 1: unsafe cascading')
 p('輸入 A 在預充相位先升高。時脈於 2.5 ns 上升時，X 與 Y 初始均高，第二級先被 X 打開；即使第一級隨後把 X 放低，Y 已流失的電荷在評估相位沒有主動充回路徑。7 ns 的 Y = 0.655339 V，未達 0.8 V 的高電位診斷門檻。本模型下是顯著高電位劣化，並非完整放到 0 V；如實保留此差異。','Input A rises during precharge. When the clock rises at 2.5 ns, X and Y are initially high, so X initially enables the second stage. Although the first stage later discharges X, lost charge at Y has no active restoration path during evaluation. Y is 0.655339 V at 7 ns, below the 0.8 V high diagnostic threshold. Here the result is substantial high-level degradation rather than a complete discharge to zero; that distinction is retained.')
 parts.append(fig('unsafe_cascade',bi('直接串接的電荷流失；虛線為 0.8 V 診斷線。','Charge loss in the direct cascade; dotted line is the 0.8 V diagnostic threshold.')))
 sec('步驟 2：相同雜訊比較','Step 2: equal-noise comparison')
 p('A 固定 0，預期兩鏈輸出皆低。在評估相位中，aggressor Q 於 4 ns 從 1 降到 0 V，經相同電容耦合至各鏈第一動態節點；10 fF 為講義條件。N-domino 的靜態反相器抑制小擾動，而 N-P 級的輸入直接控制對向 MOS，較小的浮接節點變化就可能被後級再生。','A is fixed at zero, so both outputs should remain low. During evaluation, aggressor Q falls from 1 to 0 V at 4 ns and couples through equal capacitances into each first dynamic node. The handout condition is 10 fF. A static inverter in N-domino rejects small disturbances, whereas N-P stages directly control opposite-type devices and can regenerate smaller floating-node shifts.')
 parts.append(tab(['C (fF)',bi('N 峰值 (V)','N peak (V)'),bi('N-P 峰值 (V)','N-P peak (V)')],[[x['coupling_fF'],f"{x['n_peak']:.6f}",f"{x['p_peak']:.6f}"] for x in sorted(N,key=lambda x:x['coupling_fF'])]))
 parts.append(fig('equal_noise',bi('10 fF 下的相同擾動與各鏈內部節點。','Equal 10 fF disturbances and the internal nodes of each chain.')))
 p('10 fF 時，N-domino 峰值只有 0.000249 V，N-P 輸出卻約為 1 V，出現持續的錯誤高電位。15 fF 仍有同樣區別；20/30 fF 時兩者都失敗。接近零耦合的 0.001 fF 對照組顯示 N-P 輸出約 -0.097 V 的 clock feedthrough，沒有將其裁成理想 0 V。測試支持這組條件下 N-domino 抗擾動較佳，並不保證任意尺寸、斜率、負載或雜訊形式都如此。','At 10 fF the N-domino peak is only 0.000249 V, while the N-P output reaches approximately 1 V and holds an erroneous high. The distinction persists at 15 fF, whereas both fail at 20/30 fF. The near-zero 0.001 fF control shows N-P clock feedthrough near -0.097 V, which is not clipped to ideal zero. These tests support better N-domino immunity under the stated conditions, not under every sizing, edge, load, or noise waveform.')
 sec('問題 1：速度與討論','Q1: speed and discussion')
 p('另以輸入在 4 ns、評估相位內由低轉高比較速度，避免把不同時脈預充時間算成資料延遲。以輸入與輸出 0.5 V 交越量測，N-domino 為 367.720 ps，N-P 為 657.328 ps。本實作 N-domino 較快；不能單憑 N-P 省掉靜態反相器就斷言其較快，因為 PMOS 動態堆疊驅動力、各節點負載與尺寸都參與延遲。','A separate input transition at 4 ns during evaluation compares data-path speed without confusing precharge timing with propagation delay. Using 0.5 V input/output crossings, N-domino delay is 367.720 ps and N-P delay is 657.328 ps. N-domino is faster in this implementation. Eliminating static inverters does not by itself guarantee a faster N-P chain: PMOS stack drive, node loading, and device sizes also contribute.')
 parts.append(fig('sweep_and_speed',bi('左：耦合掃描；右：無耦合電容的資料速度測試。','Left: coupling sweep. Right: data-path speed test without coupling capacitors.')))
 p('預充輸出不可打開後級的評估路徑，這是安全串接的核心條件；同型需插反相器，異型可直接相接，但後者的類比雜訊容忍仍需實測。所有結果皆為有限條件的電路模擬，未宣稱 PVT、版圖後或完整雜訊簽核。','A precharged output must not enable the next evaluation network. Same-type stages therefore need an intervening inverter, while opposite types can connect directly, with analog noise tolerance still requiring evaluation. These are finite circuit simulations, not PVT, post-layout, or complete noise signoff.')
 body='\n'.join(parts);assert not re.search(r'private_model_tag|hspui|[CD]:[\\/]',body,re.I)
 folder=R/'reports/DIC26'/lang;(folder/'body.tex').write_text(body,encoding='utf-8');(folder/'figures').mkdir(exist_ok=True)
 for pth in P.glob('*.pdf'):shutil.copy2(pth,folder/'figures'/pth.name)
 main=folder/'main.tex';s=main.read_text(encoding='utf-8').replace('Circuit Simulation and Analysis','Cascading Dynamic Circuits').replace('電路模擬與結果分析','動態電路串接');main.write_text(s,encoding='utf-8')
print('Lab26 bilingual reports and three figures installed')
