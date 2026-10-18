# Circuit Lab Reports

依兩份講義完成本次納入的電路模擬，每個 lab 提供中文與英文 LaTeX／PDF、完整 SPICE netlist、實際量測資料與圖表。

## DIC 學習路線：從平衡到強健

把各 lab 串起來看，核心問題是：**為了改善速度或面積，付出了什麼代價，又要如何讓電路可靠運作？**

| 設計問題 | 核心取捨 | 對應報告 |
| --- | --- | --- |
| ① 先讓反相器平衡 | 調整 PMOS／NMOS 寬度比，使切換點接近半供應電壓、平衡雜訊容限；2～3 倍只是常見起點，仍須看實際 VTC。 | [Lab 8](reports/DIC08/zh/main.pdf) |
| ② 串成邏輯閘後，如何維持驅動力？ | NAND／NOR 的串聯路徑可藉加寬降低電阻，代價是更大的輸入與寄生電容；切換點、延遲仍受輸入模式影響。 | [Lab 9](reports/DIC09/zh/main.pdf) |
| ③ 換一種邏輯，爭取面積與速度 | Pseudo-NMOS 簡化上拉網路，但付出靜態功耗與比例依賴；動態邏輯採預充／評估，則須處理電荷分享、耦合與漏電，並承擔時脈與預充功耗。 | [Lab 13](reports/DIC13/zh/main.pdf)、[25](reports/DIC25/zh/main.pdf) |
| ④ 讓資料在正確時間被接收 | Latch／DFF 建立儲存與取樣邊界，須檢查 setup／hold、clock slew／skew；動態串接、NORA 到 TSPC 進一步探討級間競爭與單相時脈的限制。 | [Lab 17](reports/DIC17/zh/main.pdf)、[20](reports/DIC20/zh/main.pdf)、[21](reports/DIC21/zh/main.pdf)、[26](reports/DIC26/zh/main.pdf)、[27](reports/DIC27/zh/main.pdf)、[28](reports/DIC28/zh/main.pdf) |
| ⑤ 導線與負載也會拖慢訊號 | 連線 RC 與串擾會改變延遲和波形；理解漸增尺寸 buffer 如何驅動大負載，再延伸思考長線分段、repeater 與屏蔽。 | [Lab 11](reports/DIC11/zh/main.pdf)、[12](reports/DIC12/zh/main.pdf) |
| ⑥ 電源也不是理想電壓源 | 切換電流造成電源／地壓降；decap 就近供應電荷、減小瞬態波動，但不能消除平均直流 IR drop，且有面積成本。 | [Lab 19](reports/DIC19/zh/main.pdf) |
| ⑦ 從典型條件走向可靠設計 | 用 TT／FF／SS、混合角落與電壓／溫度變化，檢查延遲、功耗與邏輯電位；有限角落測試仍不等於完整時序簽核或統計良率保證。 | [Lab 15](reports/DIC15/zh/main.pdf) |

這條路線將各實驗的設計取捨串起；各 lab 實際做了哪些測試、得到什麼結果，請見連結報告。延伸閱讀：[邏輯家族與速度／功耗取捨](https://pages.hmc.edu/harris/cmosvlsi/4e/Westeweb.fm.pdf)、[長線與 repeater 延遲模型](https://pages.hmc.edu/harris/research/wiredelay.pdf)。

## Planned lab：用 Unfooted Domino 挑戰速度極限

**狀態：待實作與量測。** 延伸 [Lab 25](reports/DIC25/zh/main.pdf) 的動態非理想效應與 [Lab 26](reports/DIC26/zh/main.pdf) 的串接問題，研究能否以移除 footer 換取更快的評估速度。

- **為什麼值得試：** Unfooted（無底腳）移除下拉路徑中受時脈控制的 NMOS，減少串聯電阻與時脈負載；在相同驅動力下，有機會縮小輸入管、降低前級負擔。
- **混合使用策略：** 接收外部靜態輸入的首級採 Footed，隔離預充時可能導通的下拉網路；後級在前級完成預充、反相器輸出回到 0，且本級進入評估前不會再被拉高的條件下，才考慮採 Unfooted。必要時延後後級預充，並保留足夠預充時間。[時序依據：§10.5.3](https://pages.hmc.edu/harris/cmosvlsi/4e/Westeweb.fm.pdf#page=24)
- **必須守住的條件：** 無爭用預充要求每條下拉路徑至少有一顆 NMOS 截止；所有輸入為 0 是充分條件。預充 PMOS 與下拉網路同時導通會造成直通電流，嚴重時影響預充。需驗證預充傳播延遲與 clock skew，後級並非一律可以移除 footer。
- **預計比較：** 全 Footed 與混合架構，在相同負載、輸入邊緣下，分別做等尺寸與等驅動力比較；量測評估延遲、預充完成時間、爭用電流及每週期能量（統一計入預充與時脈驅動），再檢查評估期輸入單調性、keeper、耦合、漏電與可用 PVT 角落。速度收益以實測為準。

## Planned labs：靜態 CMOS 與 Pulsed Latch 的能效取捨

**時代背景｜2000 年代初的高頻與行動能效設計。** Pentium 4 以積極的 Domino 管線追求高頻，同時已使用脈衝時脈降低時脈功耗與負載。2003 年的 Pentium M 則記錄了將許多 Domino 電路改為靜態 CMOS、把 Low-Vt 留給關鍵路徑，以及加長部分快取電晶體通道以減少漏電。這些方法當時已並存；設計必須共同權衡速度、切換功耗、漏電與雜訊，不能把功耗牆單獨歸因於 Domino，或把 Pulsed Latch 當成後來才出現的替代品。[Intel 2001](https://www.intel.com/content/dam/www/public/us/en/documents/research/2001-vol05-iss-1-intel-technology-journal.pdf#page=49)、[Intel 2003](https://www.intel.com/content/dam/www/public/us/en/documents/research/2003-vol07-iss-2-intel-technology-journal.pdf#page=44)

### 靜態 CMOS：把速度花在關鍵路徑上

**狀態：待實作與量測；可先做人工閾值偏移近似，製程級 Multi-Vt 須另備適用模型。** 延伸 [Lab 7](reports/DIC07/zh/main.pdf)、[9](reports/DIC09/zh/main.pdf)、[15](reports/DIC15/zh/main.pdf)。

- **設計策略：** 關鍵路徑評估加大驅動尺寸或使用 Low-Vt；有時序餘裕的路徑則評估 High-Vt 或較長通道。較強驅動可能增加電容，較低閾值通常增加漏電，須依路徑需求配置。
- **概念實驗做法：** 保留原模型，在本機副本建立不同名稱的模型並調整 `VTH0`；或對已確認支援的 MOS 使用 instance `DELVTO`，讓同一電路逐顆選擇偏移。兩種方式擇一，避免偏移疊加；也避免改動共用模型使全部元件一起變。以本次查核的 HSPICE BSIM3 Level 49／53 慣例，降低閾值絕對值 50 mV 的示例為 NMOS `DELVTO=-0.05`、PMOS `DELVTO=+0.05`；提高則反向。先用 DC 曲線確認參數生效與符號，示例數值尚未量測。
- **對照方式：** 比較全基準、全低閾值、全高閾值與「關鍵路徑低閾值、其餘高閾值」的人工偏移配置。先固定 W／L、邏輯功能、負載及輸入邊緣，再於模型有效範圍內另做 W／L 掃描，分開判讀閾值與尺寸的影響。
- **觀察重點：** 以相同條件及方法萃取 ID–VG／閾值，記錄上升與下降延遲、slew、每次切換能量、不同輸入狀態的待機漏電，以及 VTC／雜訊容限；檢查混合配置能否在滿足時序時降低漏電，並確認高溫及可用角落下是否仍成立。

人工偏移只代表閾值敏感度與 Multi-Vt 概念實驗；取得製程提供的 LVT／HVT 模型後才能進行對應的製程比較。製程角落與 body bias 不代替不同閾值模型，尺寸代理量也不視為實際 layout 面積。

### Pulsed Latch：縮短取樣開銷，守住保持時間

**狀態：待實作與量測。** 延伸 [Lab 17](reports/DIC17/zh/main.pdf)、[20](reports/DIC20/zh/main.pdf)、[21](reports/DIC21/zh/main.pdf)。

- **設計策略：** 用短時脈脈衝開啟具有靜態回授的 latch，利用短暫透明窗降低取樣開銷並容許有限時間借用；關閉後由回授保持資料。脈衝式觸發本身不保證儲存節點是靜態，也不保證一定優於 DFF。[時序概念](https://pages.hmc.edu/harris/research/JSSC.pdf)
- **預計比較：** 建立實際脈衝產生器與靜態 latch，對照 master–slave DFF；掃描脈寬、資料到達時間、clock slew／skew 與短路徑延遲，量測有效取樣範圍、輸出延遲及包含脈衝產生器的能量。重點找出脈衝過窄的取樣失敗，以及過寬或短路徑造成的 hold／race 問題。

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
