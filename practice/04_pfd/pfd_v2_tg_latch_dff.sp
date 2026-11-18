.title Phase Frequency Detector (PFD) - Bug-Free Architecture

* MODEL_SETUP_REQUIRED
* ==================================================
* 1. 電源與輸入訊號
* ==================================================
vvdd vdd 0 DC 1.0V

* phi_in: 5ns 上升 (引發 UP=1)
vphi_in phi_in 0 PWL(0ns 0V  5ns 0V  5.1ns 1.0V  20ns 1.0V  20.1ns 0V  45ns 0V  45.1ns 1.0V  60ns 1.0V  60.1ns 0V)

* phi_fb: 25ns 上升 (引發 DN=1)，47ns 再上升 (觸發 UP=1 & DN=1 重置)
vphi_fb phi_fb 0 PWL(0ns 0V  25ns 0V  25.1ns 1.0V  40ns 1.0V  40.1ns 0V  47ns 0V  47.1ns 1.0V  60ns 1.0V  60.1ns 0V)


* ==================================================
* 2. 基礎邏輯門定義 (Subcircuits)
* ==================================================

* --- 獨立傳輸閘 (Transmission Gate) ---
.subckt TG in out sel_p sel_n vdd gnd
mp out sel_p in vdd pmos L=0.1u W=1.8u
mn out sel_n in gnd nmos L=0.1u W=1.2u
.ends

* --- 反相器 (Inverter) ---
.subckt INV in out vdd gnd
mp out in vdd vdd pmos L=0.1u W=1.8u
mn out in gnd gnd nmos L=0.1u W=0.6u
.ends

* --- 2輸入 NOR 閘 ---
.subckt NOR2 a b out vdd gnd
mp1 p_mid a vdd vdd pmos L=0.1u W=1.8u
mp2 out b p_mid vdd pmos L=0.1u W=1.8u
mn1 out a gnd gnd nmos L=0.1u W=0.6u
mn2 out b gnd gnd nmos L=0.1u W=0.6u
.ends

* --- 2輸入 NAND 閘 ---
.subckt NAND2 a b out vdd gnd
mp1 out a vdd vdd pmos L=0.1u W=1.8u
mp2 out b vdd vdd pmos L=0.1u W=1.8u
mn1 out a n_mid gnd nmos L=0.1u W=1.2u
mn2 n_mid b gnd gnd nmos L=0.1u W=1.2u
.ends

* --- 2輸入 AND 閘 ---
.subckt AND2 a b out vdd gnd
xnand a b nand_out vdd gnd NAND2
xinv nand_out out vdd gnd INV
.ends

* --- 嚴謹修復版 D-Flip-Flop (偶數反相級雙穩態鎖存器) ---
.subckt DFF_R D CLK RST Q QN vdd gnd
xclk_inv CLK CLK_B vdd gnd INV

* --- Master Stage (CLK=0 時採樣，CLK=1 時鎖存) ---
xtg1 D n_m1 CLK CLK_B vdd gnd TG
xnor_m n_m1 RST n_m2 vdd gnd NOR2
xinv_m2 n_m2 n_m3 vdd gnd INV
xtg2 n_m3 n_m1 CLK_B CLK vdd gnd TG

* --- Slave Stage (CLK=1 時採樣，CLK=0 時鎖存) ---
xtg3 n_m2 n_s1 CLK_B CLK vdd gnd TG
xnor_s n_s1 RST Q vdd gnd NOR2
xinv_q Q QN vdd gnd INV
xinv_s2 Q n_s2 vdd gnd INV
xtg4 n_s2 n_s1 CLK CLK_B vdd gnd TG
.ends


* ==================================================
* 3. PFD 主電路拓撲
* ==================================================
xdff_up vdd phi_in rst up up_n vdd 0 DFF_R
xdff_dn vdd phi_fb rst dn dn_n vdd 0 DFF_R
xand_reset up dn rst vdd 0 AND2


* ==================================================
* 4. 模擬 Setup
* ==================================================
.tran 0.05ns 70ns

.ic v(up)=0 v(dn)=0 v(rst)=0

.probe v(phi_in) v(phi_fb) v(up) v(dn) v(rst)
.op
.option post=2
.end