# Circuit Lab Reports

依兩份講義完成本次納入的電路模擬，每個 lab 提供中文與英文 LaTeX／PDF、完整 SPICE netlist、實際量測資料與圖表。

## DIC 學習路線：從平衡到強健

這些 lab 串起來，就是工程師一邊追速度、一邊收拾副作用的過程：**加寬救了驅動力，卻帶來電容；簡化了電路，卻把難題交給雜訊與時序。** 每個實驗都在回答上一個設計留下的問題。

| 遇到什麼痛點 | 工程師出什麼招，又要盯住什麼代價 | 對應報告 |
| --- | --- | --- |
| ① 上拉、下拉力道不平衡 | 加寬 PMOS 補足上拉能力，把切換點往半供應電壓調，觀察兩側雜訊容限如何此消彼長。 | [Lab 8](reports/DIC08/zh/main.pdf) |
| ② 串聯之後，訊號變慢了 | NAND／NOR 加寬串聯管來救驅動力；接著看新增的輸入與寄生電容，又把多少速度吃回去。 | [Lab 9](reports/DIC09/zh/main.pdf) |
| ③ PMOS 網路太占空間、太重 | Pseudo-NMOS 用弱上拉換掉複雜網路，付出靜態功耗；動態邏輯改靠預充儲存電荷，開始面對電荷分享、耦合與漏電。 | [Lab 13](reports/DIC13/zh/main.pdf)、[25](reports/DIC25/zh/main.pdf) |
| ④ 資料算對了，卻在錯的時間被接走 | 用 latch／DFF 控制儲存與取樣；追查 setup／hold、clock slew／skew，再看 NORA、TSPC 如何安排級間時序。 | [Lab 17](reports/DIC17/zh/main.pdf)、[20](reports/DIC20/zh/main.pdf)、[21](reports/DIC21/zh/main.pdf)、[26](reports/DIC26/zh/main.pdf)、[27](reports/DIC27/zh/main.pdf)、[28](reports/DIC28/zh/main.pdf) |
| ⑤ 電晶體很快，訊號卻卡在線上 | 把連線 RC、串擾與大負載加進來；學會分級 buffer，再延伸到長線分段、repeater 與屏蔽。 | [Lab 11](reports/DIC11/zh/main.pdf)、[12](reports/DIC12/zh/main.pdf) |
| ⑥ 大家一起切換，電源就往下掉 | 用 decap 當就近供電的小水庫，觀察瞬態壓降與電流峰值能改善多少，以及電容要付出的成本。 | [Lab 19](reports/DIC19/zh/main.pdf) |
| ⑦ 典型條件跑得動，換個角落就出問題 | 把電路放進 TT／FF／SS、混合角落與不同電壓／溫度，找出速度、漏電和邏輯電位最脆弱的地方。 | [Lab 15](reports/DIC15/zh/main.pdf) |

這條路線將各實驗的設計取捨串起；各 lab 實際做了哪些測試、得到什麼結果，請見連結報告。延伸閱讀：[邏輯家族與速度／功耗取捨](https://pages.hmc.edu/harris/cmosvlsi/4e/Westeweb.fm.pdf)、[長線與 repeater 延遲模型](https://pages.hmc.edu/harris/research/wiredelay.pdf)。

## Planned labs：從榨乾速度，到把功耗壓回來

**時代背景：衝上 GHz 之後，熱怎麼辦？** 2000 年代的 Pentium 4／NetBurst 把高頻競賽推到眼前：加深管線，在關鍵區塊用 Domino 搶速度，桌上型號一路衝到 **3.8 GHz**。追逐高頻的帳單，是時脈與切換功耗、漏電和散熱壓力。**功耗牆讓工程師更在意：每多一分速度，究竟要花多少電？** [Pentium 4 電路設計](https://www.intel.com/content/dam/www/public/us/en/documents/research/2001-vol05-iss-1-intel-technology-journal.pdf#page=49)、[型號與頻率](https://www.intel.com/pressroom/kits/quickreffam.htm)

同時，行動處理器走出另一條路：2003 年的 Pentium M 把許多 Domino 電路換成靜態 CMOS，將 Low-Vt 集中在關鍵路徑，並用較長通道壓低部分快取的漏電。脈衝時脈也已出現在 Pentium 4，用來減輕時脈負載。這些設計給了我們三個值得親手拆開的題目：**拿掉拖慢速度的元件、把快元件用在刀口上、連鎖住資料的時間都要省。** [Pentium M 的功耗最佳化](https://www.intel.com/content/dam/www/public/us/en/documents/research/2003-vol07-iss-2-intel-technology-journal.pdf#page=44)

**以下三項均為規劃中，尚未實作與量測。**

### 1. Unfooted Domino：拔掉 footer，把評估速度榨出來

Footer 替預充階段隔離下拉網路，卻也在評估路徑多串了一顆 NMOS。這個 lab 就是要拆掉這個速度負擔，看看預充端會付出什麼代價。延伸 [Lab 25](reports/DIC25/zh/main.pdf)、[26](reports/DIC26/zh/main.pdf)。

- **作法：** 首級保留 Footed，承接外部輸入；後級改成 Unfooted，利用前級預充後反相器輸出回到 0，關閉下拉路徑。調整後級預充時機，讓資料先歸零、再開始充電，並與全 Footed 架構對照。[串接與預充時序](https://pages.hmc.edu/harris/cmosvlsi/4e/Westeweb.fm.pdf#page=24)
- **觀察重點：省下的評估時間，有沒有被預充與功耗吃回去？** 盯住評估延遲、預充完成時間與直通電流尖峰，再看包含時脈驅動的整週期能量。刻意掃 clock skew 與預充延遲，找出「更快」到「開始爭用、甚至充不滿」的界線。

### 2. 靜態 CMOS／Multi-Vt：把速度留給關鍵路徑，其餘省電

決定時脈的是最慢的路徑。把所有閘都換成低閾值、大尺寸，會讓有餘裕的地方也跟著多漏電、多背電容。這個 lab 要試的是：**保住關鍵路徑的速度，把其餘地方的耗電收回來。** 延伸 [Lab 7](reports/DIC07/zh/main.pdf)、[9](reports/DIC09/zh/main.pdf)、[15](reports/DIC15/zh/main.pdf)。

- **作法：** 保留原模型，用模型副本的 `VTH0` 或逐顆 MOS 的 `DELVTO` 做人工閾值偏移。比較全基準、全低閾值、全高閾值，以及「關鍵路徑低閾值、其餘高閾值」四種配置；再分開掃描 W／L，觀察加寬與加長通道的效果。
- **觀察重點：少漏多少電，換掉多少速度？** 先看關鍵路徑延遲與待機漏電，再看切換能量、VTC／雜訊容限。檢查混合配置能否維持目標時序，同時降低整體漏電；再用高溫與可用角落，把原本看似漂亮的餘裕逼出來。

### 3. Pulsed Latch：邏輯算得快，鎖資料也要快

一個週期不只花在邏輯運算，DFF 的 setup 與 clock-to-Q 也會吃掉時間。Pulsed latch 用一小段透明窗讓資料通過，再以靜態回授鎖住；這個 lab 要找到那個**夠接住資料、又不會讓資料一路穿透的開門時間**。延伸 [Lab 17](reports/DIC17/zh/main.pdf)、[20](reports/DIC20/zh/main.pdf)、[21](reports/DIC21/zh/main.pdf)。

- **作法：** 建立實際脈衝產生器，驅動具有靜態回授的 latch，與 master–slave DFF 比較。掃描脈寬、資料到達時間、clock slew／skew 和短路徑延遲，畫出可正常取樣的範圍。[時間借用與時序開銷](https://pages.hmc.edu/harris/research/JSSC.pdf)
- **觀察重點：脈衝太窄接不到，太寬就追撞。** 找出取樣失敗與 hold／race 的邊界，量測時間借用及輸出延遲；最後把脈衝產生器的能量一起算進去，看省下的時序開銷值不值得。

<details>
<summary>展開實驗設定與完整量測清單</summary>

- **Unfooted：** 固定負載與輸入邊緣，分別做等尺寸、等驅動力對照。無爭用預充要求每條下拉路徑至少有一顆 MOS 截止，且維持到本級開始評估；掃描預充延遲、寬度及 clock skew。能量統一計入預充與時脈驅動，另檢查評估期輸入單調性、keeper、電荷分享、耦合、漏電與可用 PVT 角落。
- **Multi-Vt：** `VTH0` 副本與 instance `DELVTO` 兩種方式擇一，避免偏移疊加或誤改共用模型。依已查核的 HSPICE BSIM3 Level 49／53 慣例，降低閾值絕對值 50 mV 的示例為 NMOS `DELVTO=-0.05`、PMOS `DELVTO=+0.05`；提高則反向，先用 DC 曲線確認方向。固定 W／L、功能、負載與輸入邊緣比較閾值，再於模型有效範圍內單獨掃尺寸。記錄 ID–VG／同一定義萃取的閾值、上升／下降延遲、slew、每次切換能量、各輸入狀態的待機漏電及 VTC／雜訊容限。
- **Pulsed latch：** 使用實際脈衝產生器與靜態回授儲存節點。聯合掃描脈寬、資料到達時間、clock slew／skew 與短路徑延遲，記錄有效取樣窗口、時間借用、輸出延遲、hold／race 和包含脈衝產生器的能量。

**量測註記：** 人工閾值偏移用於 Multi-Vt 概念與敏感度實驗；製程級比較使用對應的 LVT／HVT 模型。模型副本留在本機，面積以尺寸代理量記錄。各實驗的實際結果將另附完整條件與通過範圍。

</details>

## 收錄內容

每份報告另附可編輯的 CircuitikZ MOS 電晶體電路圖，原始碼為語言資料夾內的 `schematic.tex`。圖說標明對應網表、節點及 bulk 接法；大型重複電路以實際 MOS 單元搭配階層連線圖呈現，代表性版本與省略範圍均有註明。

依使用者指定，排除需要 PDK 設計規則的 DIC Lab 3，以及需要 layout／實體驗證的 DIC Lab 29、30。DIC 講義沒有 Lab 18。電路執行成功與符合每一項規格分別記錄；移植差異、未達指標及模型限制保留於各報告。

本版納入 **31 個 lab、62 份中英文報告、114 份 lab netlist**。

## Reports and netlists

| Lab | Topic | 中文 PDF | English PDF | LaTeX | MOS schematic source | Netlists |
| --- | --- | --- | --- | --- | --- | --- |
| DIC01 | MOS Transistor DC Characteristics | [中文](reports/DIC01/zh/main.pdf) | [English](reports/DIC01/en/main.pdf) | [ZH](reports/DIC01/zh/main.tex) / [EN](reports/DIC01/en/main.tex) | [ZH](reports/DIC01/zh/schematic.tex) / [EN](reports/DIC01/en/schematic.tex) | [7 files](DIC/Lab01) |
| DIC02 | CMOS Inverter Delay and Loading | [中文](reports/DIC02/zh/main.pdf) | [English](reports/DIC02/en/main.pdf) | [ZH](reports/DIC02/zh/main.tex) / [EN](reports/DIC02/en/main.tex) | [ZH](reports/DIC02/zh/schematic.tex) / [EN](reports/DIC02/en/schematic.tex) | [3 files](DIC/Lab02) |
| DIC04 | MOSFET Diffusion Geometry and Parasitics | [中文](reports/DIC04/zh/main.pdf) | [English](reports/DIC04/en/main.pdf) | [ZH](reports/DIC04/zh/main.tex) / [EN](reports/DIC04/en/main.tex) | [ZH](reports/DIC04/zh/schematic.tex) / [EN](reports/DIC04/en/schematic.tex) | [3 files](DIC/Lab04) |
| DIC05 | Miller Capacitance | [中文](reports/DIC05/zh/main.pdf) | [English](reports/DIC05/en/main.pdf) | [ZH](reports/DIC05/zh/main.tex) / [EN](reports/DIC05/en/main.tex) | [ZH](reports/DIC05/zh/schematic.tex) / [EN](reports/DIC05/en/schematic.tex) | [1 files](DIC/Lab05) |
| DIC06 | Effective Gate Capacitance | [中文](reports/DIC06/zh/main.pdf) | [English](reports/DIC06/en/main.pdf) | [ZH](reports/DIC06/zh/main.tex) / [EN](reports/DIC06/en/main.tex) | [ZH](reports/DIC06/zh/schematic.tex) / [EN](reports/DIC06/en/schematic.tex) | [1 files](DIC/Lab06) |
| DIC07 | Body Bias and Ring Oscillators | [中文](reports/DIC07/zh/main.pdf) | [English](reports/DIC07/en/main.pdf) | [ZH](reports/DIC07/zh/main.tex) / [EN](reports/DIC07/en/main.tex) | [ZH](reports/DIC07/zh/schematic.tex) / [EN](reports/DIC07/en/schematic.tex) | [2 files](DIC/Lab07) |
| DIC08 | Inverter DC Characteristics and Noise Margins | [中文](reports/DIC08/zh/main.pdf) | [English](reports/DIC08/en/main.pdf) | [ZH](reports/DIC08/zh/main.tex) / [EN](reports/DIC08/en/main.tex) | [ZH](reports/DIC08/zh/schematic.tex) / [EN](reports/DIC08/en/schematic.tex) | [2 files](DIC/Lab08) |
| DIC09 | NAND and NOR Logic Gates | [中文](reports/DIC09/zh/main.pdf) | [English](reports/DIC09/en/main.pdf) | [ZH](reports/DIC09/zh/main.tex) / [EN](reports/DIC09/en/main.tex) | [ZH](reports/DIC09/zh/schematic.tex) / [EN](reports/DIC09/en/schematic.tex) | [4 files](DIC/Lab09) |
| DIC10 | Linear and Nonlinear Delay Models | [中文](reports/DIC10/zh/main.pdf) | [English](reports/DIC10/en/main.pdf) | [ZH](reports/DIC10/zh/main.tex) / [EN](reports/DIC10/en/main.tex) | [ZH](reports/DIC10/zh/schematic.tex) / [EN](reports/DIC10/en/schematic.tex) | [2 files](DIC/Lab10) |
| DIC11 | Interconnect RC Delay and Capacitive Coupling | [中文](reports/DIC11/zh/main.pdf) | [English](reports/DIC11/en/main.pdf) | [ZH](reports/DIC11/zh/main.tex) / [EN](reports/DIC11/en/main.tex) | [ZH](reports/DIC11/zh/schematic.tex) / [EN](reports/DIC11/en/schematic.tex) | [3 files](DIC/Lab11) |
| DIC12 | Delay Elements and Tapered Buffers | [中文](reports/DIC12/zh/main.pdf) | [English](reports/DIC12/en/main.pdf) | [ZH](reports/DIC12/zh/main.tex) / [EN](reports/DIC12/en/main.tex) | [ZH](reports/DIC12/zh/schematic.tex) / [EN](reports/DIC12/en/schematic.tex) | [2 files](DIC/Lab12) |
| DIC13 | Static CMOS and Pseudo NMOS Logic | [中文](reports/DIC13/zh/main.pdf) | [English](reports/DIC13/en/main.pdf) | [ZH](reports/DIC13/zh/main.tex) / [EN](reports/DIC13/en/main.tex) | [ZH](reports/DIC13/zh/schematic.tex) / [EN](reports/DIC13/en/schematic.tex) | [4 files](DIC/Lab13) |
| DIC14 | Schmitt Triggers | [中文](reports/DIC14/zh/main.pdf) | [English](reports/DIC14/en/main.pdf) | [ZH](reports/DIC14/zh/main.tex) / [EN](reports/DIC14/en/main.tex) | [ZH](reports/DIC14/zh/schematic.tex) / [EN](reports/DIC14/en/schematic.tex) | [5 files](DIC/Lab14) |
| DIC15 | Process Corners and Junction Leakage | [中文](reports/DIC15/zh/main.pdf) | [English](reports/DIC15/en/main.pdf) | [ZH](reports/DIC15/zh/main.tex) / [EN](reports/DIC15/en/main.tex) | [ZH](reports/DIC15/zh/schematic.tex) / [EN](reports/DIC15/en/schematic.tex) | [8 files](DIC/Lab15) |
| DIC16 | Pass Transistors and Transmission Gates | [中文](reports/DIC16/zh/main.pdf) | [English](reports/DIC16/en/main.pdf) | [ZH](reports/DIC16/zh/main.tex) / [EN](reports/DIC16/en/main.tex) | [ZH](reports/DIC16/zh/schematic.tex) / [EN](reports/DIC16/en/schematic.tex) | [5 files](DIC/Lab16) |
| DIC17 | Latches and Flip-Flops | [中文](reports/DIC17/zh/main.pdf) | [English](reports/DIC17/en/main.pdf) | [ZH](reports/DIC17/zh/main.tex) / [EN](reports/DIC17/en/main.tex) | [ZH](reports/DIC17/zh/schematic.tex) / [EN](reports/DIC17/en/schematic.tex) | [4 files](DIC/Lab17) |
| DIC19 | Supply IR Drop and Decoupling | [中文](reports/DIC19/zh/main.pdf) | [English](reports/DIC19/en/main.pdf) | [ZH](reports/DIC19/zh/main.tex) / [EN](reports/DIC19/en/main.tex) | [ZH](reports/DIC19/zh/schematic.tex) / [EN](reports/DIC19/en/schematic.tex) | [1 files](DIC/Lab19) |
| DIC20 | Combinational and Sequential Timing | [中文](reports/DIC20/zh/main.pdf) | [English](reports/DIC20/en/main.pdf) | [ZH](reports/DIC20/zh/main.tex) / [EN](reports/DIC20/en/main.tex) | [ZH](reports/DIC20/zh/schematic.tex) / [EN](reports/DIC20/en/schematic.tex) | [3 files](DIC/Lab20) |
| DIC21 | Clock Slew and Skew | [中文](reports/DIC21/zh/main.pdf) | [English](reports/DIC21/en/main.pdf) | [ZH](reports/DIC21/zh/main.tex) / [EN](reports/DIC21/en/main.tex) | [ZH](reports/DIC21/zh/schematic.tex) / [EN](reports/DIC21/en/schematic.tex) | [3 files](DIC/Lab21) |
| DIC22 | Four-to-One Multiplexer Comparison | [中文](reports/DIC22/zh/main.pdf) | [English](reports/DIC22/en/main.pdf) | [ZH](reports/DIC22/zh/main.tex) / [EN](reports/DIC22/en/main.tex) | [ZH](reports/DIC22/zh/schematic.tex) / [EN](reports/DIC22/en/schematic.tex) | [2 files](DIC/Lab22) |
| DIC23 | Decoder and Hierarchy Comparison | [中文](reports/DIC23/zh/main.pdf) | [English](reports/DIC23/en/main.pdf) | [ZH](reports/DIC23/zh/main.tex) / [EN](reports/DIC23/en/main.tex) | [ZH](reports/DIC23/zh/schematic.tex) / [EN](reports/DIC23/en/schematic.tex) | [4 files](DIC/Lab23) |
| DIC24 | Synchronous and Ripple Counters | [中文](reports/DIC24/zh/main.pdf) | [English](reports/DIC24/en/main.pdf) | [ZH](reports/DIC24/zh/main.tex) / [EN](reports/DIC24/en/main.tex) | [ZH](reports/DIC24/zh/schematic.tex) / [EN](reports/DIC24/en/schematic.tex) | [3 files](DIC/Lab24) |
| DIC25 | Nonideal Effects in Dynamic Logic | [中文](reports/DIC25/zh/main.pdf) | [English](reports/DIC25/en/main.pdf) | [ZH](reports/DIC25/zh/main.tex) / [EN](reports/DIC25/en/main.tex) | [ZH](reports/DIC25/zh/schematic.tex) / [EN](reports/DIC25/en/schematic.tex) | [6 files](DIC/Lab25) |
| DIC26 | Cascading Dynamic Circuits | [中文](reports/DIC26/zh/main.pdf) | [English](reports/DIC26/en/main.pdf) | [ZH](reports/DIC26/zh/main.tex) / [EN](reports/DIC26/en/main.tex) | [ZH](reports/DIC26/zh/schematic.tex) / [EN](reports/DIC26/en/schematic.tex) | [3 files](DIC/Lab26) |
| DIC27 | NORA Dynamic Pipelines | [中文](reports/DIC27/zh/main.pdf) | [English](reports/DIC27/en/main.pdf) | [ZH](reports/DIC27/zh/main.tex) / [EN](reports/DIC27/en/main.tex) | [ZH](reports/DIC27/zh/schematic.tex) / [EN](reports/DIC27/en/schematic.tex) | [1 files](DIC/Lab27) |
| DIC28 | True Single-Phase Clocking | [中文](reports/DIC28/zh/main.pdf) | [English](reports/DIC28/en/main.pdf) | [ZH](reports/DIC28/zh/main.tex) / [EN](reports/DIC28/en/main.tex) | [ZH](reports/DIC28/zh/schematic.tex) / [EN](reports/DIC28/en/schematic.tex) | [4 files](DIC/Lab28) |
| AIC01 | MOS Current Mirrors | [中文](reports/AIC01/zh/main.pdf) | [English](reports/AIC01/en/main.pdf) | [ZH](reports/AIC01/zh/main.tex) / [EN](reports/AIC01/en/main.tex) | [ZH](reports/AIC01/zh/schematic.tex) / [EN](reports/AIC01/en/schematic.tex) | [7 files](AIC/Lab01) |
| AIC02 | Voltage References and Bias Circuits | [中文](reports/AIC02/zh/main.pdf) | [English](reports/AIC02/en/main.pdf) | [ZH](reports/AIC02/zh/main.tex) / [EN](reports/AIC02/en/main.tex) | [ZH](reports/AIC02/zh/schematic.tex) / [EN](reports/AIC02/en/schematic.tex) | [6 files](AIC/Lab02) |
| AIC03 | Single-Stage Amplifiers and Source Followers | [中文](reports/AIC03/zh/main.pdf) | [English](reports/AIC03/en/main.pdf) | [ZH](reports/AIC03/zh/main.tex) / [EN](reports/AIC03/en/main.tex) | [ZH](reports/AIC03/zh/schematic.tex) / [EN](reports/AIC03/en/schematic.tex) | [5 files](AIC/Lab03) |
| AIC04 | Differential and Current Amplifiers | [中文](reports/AIC04/zh/main.pdf) | [English](reports/AIC04/en/main.pdf) | [ZH](reports/AIC04/zh/main.tex) / [EN](reports/AIC04/en/main.tex) | [ZH](reports/AIC04/zh/schematic.tex) / [EN](reports/AIC04/en/schematic.tex) | [5 files](AIC/Lab04) |
| AIC05 | Two-Stage Operational Amplifiers and Compensation | [中文](reports/AIC05/zh/main.pdf) | [English](reports/AIC05/en/main.pdf) | [ZH](reports/AIC05/zh/main.tex) / [EN](reports/AIC05/en/main.tex) | [ZH](reports/AIC05/zh/schematic.tex) / [EN](reports/AIC05/en/schematic.tex) | [5 files](AIC/Lab05) |

## Local model setup

上傳的 netlist 不含模型載入路徑。`MODEL_SETUP_REQUIRED` 是本機模擬前必須補入模型設定的註記；具名角落的註記另附 section 名稱。模型庫、原始講義與原始模擬 listing 不隨 repo 上傳。

DIC Lab 15 使用另行提供的 CIC 0.18µm 具名角落庫，裝置名稱為 `n_18`／`p_18`；其他 labs 使用另行提供的 `nmos`／`pmos` 模型。模型切換會改變數值。一般 labs 的 1 V 是本次教學模擬條件，並非已驗證的製程額定電壓。

The public decks omit all model loading paths. Prepare private execution copies with locally supplied libraries:

```text
python scripts/stage_batch.py LOCAL_RUN_DIRECTORY --model LOCAL_MODEL --corner-model LOCAL_CORNER_MODEL
python scripts/run_batch.py LOCAL_RUN_DIRECTORY --simulator HSPICE_EXECUTABLE --workers 2
```

Use `--labs DIC/Lab05 AIC/Lab02` to select specific labs. The destination must be a fresh local work directory. Keep staged execution copies outside the repository. The staging manifest records the public source hash and the transformation without recording model paths.

The runner invokes HSPICE in the background with `-i` and `-o`, saves results beside each staged netlist, and records completion and measurement failures. Increase `--timeout` for long counter or exhaustive decoder runs. A successful simulator exit does not imply that the circuit meets every specification.

## Results and validation

Measurements and waveform plots come from actual local HSPICE simulations. CSV and derived metrics are provided under the lab result folders; the original DIC 1/2 exports are under `validation/dic_pilot`. Source statements, case completion, visible errors and failed measurements are checked separately from specification compliance.

Encrypted-model warning details remain suppressed in the ordinary-model runs. A representative diagnostic is recorded in `validation/model_warning_diagnostic.json`; measurement agreement does not prove that the suppressed warnings are harmless.

The supplied scripts support local staging, listing inspection and the initial lab exports. Later lab CSV files and figures are the archived results for the supplied netlists. Re-running with different inputs requires updating the numerical tables and discussion as well as figures.

## Rebuild reports

Use XeLaTeX with `fontspec`, `xeCJK`, `circuitikz` (including TikZ), and Microsoft JhengHei or Noto CJK TC. Keep `body.tex`, `schematic.tex` and the `figures` directory beside `main.tex`. In each language directory, run twice:

```text
xelatex -no-shell-escape -interaction=nonstopmode -halt-on-error main.tex
xelatex -no-shell-escape -interaction=nonstopmode -halt-on-error main.tex
```

Each report includes the specification mapping, circuit reasoning, simulation setup, actual results, limitations and an editable MOS schematic appendix. Waveform figures are redrawn from exported simulation data; circuit schematics document the cited netlist topology and are not layout drawings.
