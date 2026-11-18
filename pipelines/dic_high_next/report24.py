from pathlib import Path
import json,csv,re,shutil
import numpy as np
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
W=Path('work/dic_missing_highB');R=Path('outputs/Circuit_Labs_Release');F=R/'DIC/Lab24/results';A=json.loads((W/'derived.json').read_text())
exec(Path('work/dic_high_next/extract.py').read_text().split('all_data={}')[0])
D=cases('Lab24_01_counters');base=D[0];rr=base['rows'];tt=np.array([r['time_s'] for r in rr])*1e9
def tab(headers,rows):return '\\begin{center}\\small\n\\begin{tabular}{'+'l'+'r'*(len(headers)-1)+'}\n\\toprule\n'+' & '.join(headers)+r' \\'+'\n\\midrule\n'+'\n'.join(' & '.join(map(str,row))+r' \\' for row in rows)+'\n\\bottomrule\n\\end{tabular}\n\\end{center}\n'
def fig(name,cap):return '\\begin{figure}[htbp]\\centering\n\\includegraphics[width=.94\\linewidth]{figures/'+name+'.pdf}\n\\caption{'+cap+'}\n\\end{figure}\n'
P=F/'figures';P.mkdir(exist_ok=True);plt.rcParams.update({'font.size':9,'pdf.fonttype':42})
def plot(ax,nodes,lim,period=False):
    for n in nodes:ax.plot(tt/20 if period else tt,[r[n] for r in rr],label=n.upper())
    ax.set_xlim(*lim);ax.set_ylabel('Voltage (V)');ax.legend(ncol=min(3,len(nodes)),loc='upper right');ax.grid(alpha=.2)
def save(name,f):
    f.savefig(P/(name+'.pdf'),bbox_inches='tight',metadata={'Title':'DIC Lab24 '+name,'Author':''});f.savefig(P/(name+'.png'),bbox_inches='tight',dpi=160);plt.close(f)
f,a=plt.subplots(4,1,figsize=(7.2,7),constrained_layout=True);plot(a[0],['clk','b0','b1'],(2,10),True);plot(a[1],['b2','b3','b4'],(2,40),True);plot(a[2],['b5','b6','b7'],(2,270),True);plot(a[3],['a0','a1','a2','a3'],(2,20),True)
for ax in a:ax.set_xlabel('Time / source-clock period')
save('division_waveforms',f)
f,a=plt.subplots(2,1,figsize=(7.2,5.3),constrained_layout=True)
for ax,nodes,k in [(a[0],['clk','a0','a1','a2','a3'],9),(a[1],['clk','b2','b3','b4'],33)]:
  for n in nodes:ax.plot(tt-(k+.25)*20,[r[n] for r in rr],label=n.upper())
  ax.set(xlim=(-.3,3.0),xlabel='Time from source-clock rising edge (ns)',ylabel='Voltage (V)');ax.legend(ncol=3,loc='upper right');ax.grid(alpha=.2)
a[0].set_title('Ripple counter: 7 to 8 transition');a[1].set_title('Clocked upper group: shared-edge transition');save('transition_alignment',f)
f,a=plt.subplots(1,2,figsize=(7.2,3.5),constrained_layout=True);rows=A['frequency']
for key,label in [('sync','Synchronous'),('async','Ripple')]:
 a[0].plot([x['frequency_MHz'] for x in rows],[x[key+'_correct'] for x in rows],'-o',label=label)
 a[1].plot([x['frequency_MHz'] for x in rows],[x[key+'_power_uW'] for x in rows],'-o',label=label)
a[0].set(xlabel='Frequency (MHz)',ylabel='Correct full-word samples / 260',ylim=(-5,270));a[1].set(xlabel='Frequency (MHz)',ylabel='Supply power (uW)')
for ax in a:ax.legend();ax.grid(alpha=.2)
save('frequency_and_power',f)
best={k:max((x['frequency_MHz'] for x in rows if x[k+'_correct']==260),default=None) for k in ['sync','async']}
fail={k:min((x['frequency_MHz'] for x in rows if x[k+'_correct']<260 and (best[k] is None or x['frequency_MHz']>best[k])),default=None) for k in ['sync','async']}
for lang in ['zh','en']:
 zh=lang=='zh';parts=[]
 def bi(z,e):return z if zh else e
 def sec(z,e):parts.append('\\section{'+bi(z,e)+'}\n')
 def p(z,e):parts.append(bi(z,e)+'\n')
 sec('目的與講義對照','Objectives and handout mapping')
 p('依講義 PDF 第 94--98 頁，步驟 1 重建圖 24.1 的 8 輸出同步分頻器及圖 24.2 的 4 位元 ripple 計數器，驗證完整分頻週期與操作頻率；步驟 2 比較實際電晶體數、時脈輸入負載及功率。網表 01 包含 7 個週期，02 分離兩電路的時脈電流量測，03 再細化兩個頻率點，共 10 個分析。','Following handout PDF pages 94--98, Step 1 reconstructs the eight-output synchronous divider in Fig.24.1 and the four-bit ripple counter in Fig.24.2, checking a full division cycle and operating frequency. Step 2 compares transistor counts, clock input loading, and power. Deck 01 contains seven periods; deck 02 separately measures each clock input current; deck 03 refines two frequency points, giving ten analyses.')
 sec('電路重建與狀態方程','Circuit reconstruction and state equations')
 p('所有邏輯由 MOS、靜態閘及 TG latch 組成，不使用理想 DFF 或理想計數器。DFF 使用 22 顆電晶體，reset 同時清除 master 與 slave 狀態，避免解除 reset 時出現非預期計數。同步架構保留圖中的三個 Johnson DFF、兩個三位元同步計數群，以及四 NAND 加一反相器的時脈同步閘；ripple 架構以本級反相輸出驅動下一級正緣時脈。','All logic uses MOS devices, static gates, and TG latches, without ideal DFF or counter models. Each DFF uses 22 transistors and resets both master and slave states to avoid spurious counts on reset release. The synchronous architecture retains the three Johnson DFFs, two three-bit counter groups, and four-NAND-plus-inverter clock synchronizers drawn in the handout. The ripple counter clocks each next positive-edge DFF from the preceding inverted output.')
 p(r'圖 24.1 的 Johnson 解碼必須照圖判讀：$J_1^+=\overline{J_2}$、$J_2^+=J_1$、$J_3^+=J_2$，$B_0=J_3\oplus\overline{J_2}$、$B_1=J_3$。因此低兩位輸出序列是 1、0、3、2，並非一般遞增二進位碼。兩個三位元群各以 $B_0B_1$ 與 $B_0B_1[B_{4:2}=7]$ 啟用。這裡驗證的是照圖的狀態方程及除 2 至除 256 行為，不將其誤標為普通二進位遞增器。',r'The Fig.24.1 Johnson decoder is interpreted as drawn: $J_1^+=\overline{J_2}$, $J_2^+=J_1$, $J_3^+=J_2$, $B_0=J_3\oplus\overline{J_2}$, and $B_1=J_3$. The low two output bits therefore follow 1, 0, 3, 2 rather than ordinary ascending binary code. The two three-bit groups are enabled by $B_0B_1$ and $B_0B_1[B_{4:2}=7]$. Validation uses these state equations and divide-by-2 through divide-by-256 behavior, rather than mislabeling the drawing as a conventional binary up-counter.')
 sec('模擬設定與判讀','Simulation settings and interpretation')
 p('以提供模型、1.0 V、25°C 為教學基準，並非原講義 2.5 V 製程重現或已認證電壓。一般反相器 Wn/Wp/L = 0.6/1.8/0.25 µm，閘內串接元件尺寸在網表明列，每個外部輸出負載 5 fF；時脈邊緣 20 ps。每案例模擬 275 個來源時脈週期，reset 在 1.5T 解除，於第 10 至 269 週期的 0.7T 時點檢查 260 個完整輸出字。時脈上升開始於 0.25T，故輸出建立期限約為 0.45T。','The supplied model is evaluated at a teaching baseline of 1.0 V and 25°C, not a reproduction of the original 2.5 V process or a certified voltage rating. Ordinary inverter Wn/Wp/L is 0.6/1.8/0.25 µm, series-device sizes are explicit in the deck, and each external output has a 5 fF load. Clock edges are 20 ps. Every case runs for 275 source-clock periods, releases reset at 1.5T, and checks 260 complete output words at 0.7T in cycles 10 through 269. Since the source edge starts at 0.25T, the output settling deadline is approximately 0.45T.')
 p(r'高／低診斷線為 0.8/0.2 V，所有位元都須符合預期才算該字正確。這是宣告的取樣診斷，不是接收器雜訊容限萃取，也不能排除取樣間毛刺。\texttt{.tran} 列印間隔為 T/200；積分步長由求解器自適應。各案例皆完成且沒有 error 或 failed measurement，但加密模型警告內容仍被隱藏。公開網表以 \texttt{MODEL\_SETUP\_REQUIRED} 註解取代載入路徑，執行前需本機模型設定。',r'The declared high/low thresholds are 0.8/0.2 V, and every bit must match for a word to pass. This sampled diagnostic is not receiver noise-margin extraction and cannot exclude inter-sample glitches. The \texttt{.tran} print interval is T/200; solver integration steps are adaptive. All cases conclude without errors or failed measurements, while encrypted-model warning details remain suppressed. Public decks replace model-loading paths with a \texttt{MODEL\_SETUP\_REQUIRED} comment and require local model setup before running.')
 sec('波形與傳播時間','Waveforms and propagation timing')
 p('50 MHz 基準中，兩架構皆有 260/260 個完整字符合各自狀態方程。這涵蓋同步架構完整的 256 狀態分頻循環；ripple 輸出則依序遞增，最高位除 16。同步圖低位與高位使用不同時間窗，避免把密集低位切換誤看成穩態。','At the 50 MHz baseline, both architectures match their state equations for 260/260 full-word samples. This covers a complete 256-state synchronous division cycle, while ripple outputs increment in binary with a divide-by-16 highest bit. The synchronous plot uses different time windows for low and high bits to keep dense low-bit transitions readable.')
 parts.append(fig('division_waveforms',bi('基準分頻波形；各子圖時間窗不同。','Baseline divider waveforms; time windows differ between panels.')))
 p('ripple 的 7→8 轉換由前級逐級觸發，A0、A1、A2、A3 的半供應交越約落在來源時脈邊緣後 0.532、1.182、1.816、2.263 ns。同步的 B2/B3/B4 群在所選共同轉換中約為 1.012 ns，沒有相同的逐位累積延遲。這些值由 T/200 列印資料線性內插，精度受 100 ps 基準取樣間隔限制；不宣稱 ps 等級簽核精度。','In the ripple 7-to-8 transition, A0/A1/A2/A3 cross half supply approximately 0.532/1.182/1.816/2.263 ns after the source edge. The selected synchronous B2/B3/B4 transition occurs around 1.012 ns without the same bit-by-bit delay accumulation. These values are interpolated from T/200 printed data and are limited by the 100 ps baseline sample interval; picosecond signoff precision is not claimed.')
 parts.append(fig('transition_alignment',bi('ripple 累積延遲與同步群的共同轉換。','Accumulated ripple delay and the shared transition of a synchronous group.')))
 sec('頻率界線與功耗','Frequency boundary and power')
 parts.append(tab(['T (ns)','f (MHz)',bi('同步正確/260','Sync correct/260'),bi('Ripple 正確/260','Ripple correct/260')],[[x['period_ns'],f"{x['frequency_MHz']:.1f}",x['sync_correct'],x['async_correct']] for x in rows]))
 p(f"最高已測且 260/260 正確的同步／ripple 頻率分別為 {best['sync']:.1f}/{best['async']:.1f} MHz；其上方首個已測失敗點分別為 {fail['sync'] if fail['sync'] is not None else '未包含'}/{fail['async'] if fail['async'] is not None else '未包含'} MHz。這是固定負載、20 ps 邊緣與 0.45T 建立期限下的有限掃描界線，不是所有 PVT 的無條件最高頻率。",f"The highest tested frequencies with 260/260 correct words are {best['sync']:.1f}/{best['async']:.1f} MHz for synchronous/ripple. The next tested failing points are {fail['sync'] if fail['sync'] is not None else 'not included'}/{fail['async'] if fail['async'] is not None else 'not included'} MHz. These are finite-sweep boundaries at the stated load, 20 ps edges, and 0.45T settling deadline, not unconditional maximum frequencies across PVT.")
 parts.append(fig('frequency_and_power',bi('取樣正確率與電源功率；失敗頻率的功率仍保留，不能當作正常工作效率。','Sample correctness and supply power; power at failing frequencies is retained and is not valid-operation efficiency.')))
 q=A['clock_loading'];parts.append(tab([bi('架構','Architecture'),bi('電晶體','Transistors'),bi('時脈邊緣電荷 (fC)','Clock edge charge (fC)'),bi('50 MHz 功率 (µW)','50 MHz power (µW)')],[[bi('同步（8 輸出）','Sync (8 outputs)'),414,f"{q['sync_clock_charge']*1e15:.3f}",f"{rows[0]['sync_power_uW']:.3f}"],[bi('Ripple（4 位元）','Ripple (4 bits)'),98,f"{q['async_clock_charge']*1e15:.3f}",f"{rows[0]['async_power_uW']:.3f}"]]))
 p('電晶體數由實際階層網表遞迴計數，包括 clock inverter、同步閘、reset 與 XOR/AND 邏輯，排除未實例化的副電路。時脈負載由第 10.25T 上升邊緣期間獨立 0 V 探針電流積分量測；1 V 擺幅下 Q/ΔV 對應約 60.450/13.474 fF 的此邊緣等效負載，並非版圖電容。功率為 10T--270T 的平均供應功率，未計入理想時脈及 reset 驅動源的功率。','Transistor counts recursively expand the instantiated hierarchy, including clock inverters, synchronizers, reset, and XOR/AND logic, while excluding unused subcircuits. Clock loading integrates independent 0 V probe currents during the rising edge at 10.25T. At a 1 V swing, Q/ΔV corresponds to approximately 60.450/13.474 fF of edge-specific effective loading, not layout capacitance. Power averages supply input from 10T to 270T and excludes ideal clock/reset source power.')
 sec('討論與限制','Discussion and limitations')
 p('同步架構以更多時脈負載與邏輯換取較小的逐級延遲；ripple 則減少直接時脈負載，但必須等待前級切換。本講義比較 8 輸出與 4 位元兩種不同規模，故不能把總功率差當作相同功能、相同位數的公平效率比。沒有強迫結果符合講義 1 GHz/500 MHz 的原製程範例，也沒有用理想計數器掩蓋最高頻率失敗。所有逐案例波形、完整字判讀及量測保留於 results。','The synchronous architecture trades additional clock loading and logic for reduced sequential propagation, while ripple reduces direct clock loading but waits for preceding transitions. The handout compares different sizes, eight outputs versus four bits, so total power is not an equal-function/equal-width efficiency comparison. Results are not forced to reproduce the original 1 GHz/500 MHz process examples, and ideal counters are not used to conceal frequency failures. Per-case waveforms, full-word validation, and measurements are retained in results.')
 body='\n'.join(parts);assert not re.search(r'private_model_tag|hspui|[CD]:[\\/]',body,re.I)
 folder=R/'reports/DIC24'/lang;(folder/'body.tex').write_text(body,encoding='utf-8');(folder/'figures').mkdir(exist_ok=True)
 for path in P.glob('*.pdf'):shutil.copy2(path,folder/'figures'/path.name)
 main=folder/'main.tex';s=main.read_text(encoding='utf-8').replace('Circuit Simulation and Analysis','Synchronous and Ripple Counters').replace('電路模擬與結果分析','同步與非同步計數器');main.write_text(s,encoding='utf-8')
print('Lab24 report generated for',len(rows),'completed frequency cases')
