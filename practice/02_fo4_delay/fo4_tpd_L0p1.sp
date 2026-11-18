* FO4 (Fan-Out of 4) Propagation Delay Simulation
* MODEL_SETUP_REQUIRED
* ===== 電源與訊號源設定 =====
vvdd vdd 0 1.0V
vin  in  0 PULSE(0V 1.0V 0.1ns 0.02ns 0.02ns 0.5ns 1ns)

* ===== 定義 CMOS 反相器子電路 (Subcircuit) =====
.subckt inv in out vdd gnd
mn1 out in gnd gnd nmos L=0.1u W=0.6u
mp1 out in vdd vdd pmos L=0.1u W=1.2u
.ends inv

* ===== FO4 電路結構 =====
* 1. 前驅級 (Driver Stage)：將理想訊號整形成具真實斜率的波形
xinv_driver in in_dut vdd 0 inv

* 2. 待測級 (DUT)：量測此反相器的輸入與輸出延遲
xinv_dut in_dut out_dut vdd 0 inv

* 3. 負載級 (FO4 Load Stage)：4 個完全相同的反相器提供 $4 \times C_{in}$ 負載
xload1 out_dut dummy1 vdd 0 inv
xload2 out_dut dummy2 vdd 0 inv
xload3 out_dut dummy3 vdd 0 inv
xload4 out_dut dummy4 vdd 0 inv

* ===== 瞬態分析與自動量測指令 =====
.tran 1p 2n

* 量測 DUT 輸入與輸出波形通過 50% VDD (0.5V) 的時間差
.measure tran t_pHL trig v(in_dut)  val=0.5V rise=1 targ v(out_dut) val=0.5V fall=1
.measure tran t_pLH trig v(in_dut)  val=0.5V fall=1 targ v(out_dut) val=0.5V rise=1
.measure tran tpd   param='(t_pHL + t_pLH) / 2'

.probe v(in_dut) v(out_dut)
.option post=2
.end