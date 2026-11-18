.title Phase Frequency Detector (PFD) - Fixed Glitch & Reset Loop

* MODEL_SETUP_REQUIRED
* ==================================================
* 1. 電源與輸入訊號 (PWL 語法修正版)
* ==================================================
vvdd vdd 0 DC 1.0V

* phi_in: 5ns 上升 (引發 UP=1)
vphi_in phi_in 0 PWL(0ns 0V  5ns 0V  5.1ns 1.0V  20ns 1.0V  20.1ns 0V  45ns 0V  45.1ns 1.0V  60ns 1.0V  60.1ns 0V)

* phi_fb: 25ns 上升 (引發 DN=1)，47ns 再上升 (觸發 UP=1 & DN=1 重置)
vphi_fb phi_fb 0 PWL(0ns 0V  25ns 0V  25.1ns 1.0V  40ns 1.0V  40.1ns 0V  47ns 0V  47.1ns 1.0V  60ns 1.0V  60.1ns 0V)


* ==================================================
* 2. 子電路定義 (Subcircuits)
* ==================================================

* --- 反相器 (Inverter) ---
.subckt INV in out vdd gnd
mp out in vdd vdd pmos L=0.1u W=1.8u
mn out in gnd gnd nmos L=0.1u W=0.6u
.ends

* --- 2輸入 NAND 閘 ---
.subckt NAND2 a b out vdd gnd
mp1 out a vdd vdd pmos L=0.1u W=1.8u
mp2 out b vdd vdd pmos L=0.1u W=1.8u
mn1 out a n_mid gnd nmos L=0.1u W=1.2u
mn2 n_mid b gnd gnd nmos L=0.1u W=1.2u
.ends

* --- 2輸入 NOR 閘 ---
.subckt NOR2 a b out vdd gnd
mp1 p_mid a vdd vdd pmos L=0.1u W=1.8u
mp2 out b p_mid vdd pmos L=0.1u W=1.8u
mn1 out a gnd gnd nmos L=0.1u W=0.6u
mn2 out b gnd gnd nmos L=0.1u W=0.6u
.ends

* --- 2輸入 OR 閘 ---
.subckt OR2 a b out vdd gnd
xnor a b nor_out vdd gnd NOR2
xinv nor_out out vdd gnd INV
.ends

* --- 2輸入 AND 閘 ---
.subckt AND2 a b out vdd gnd
xnand a b nand_out vdd gnd NAND2
xinv nand_out out vdd gnd INV
.ends

* --- 修正版 D-Flip-Flop (徹底解決重置迴路震盪) ---
.subckt DFF_R D CLK RST Q QN vdd gnd
xclk_inv CLK CLK_B vdd gnd INV

* Master 階段
mp_tg1 node_m1 CLK D vdd pmos L=0.1u W=1.8u
mn_tg1 node_m1 CLK_B D gnd nmos L=0.1u W=1.2u

* Master 重置修正：RST=1 時強制輸出 1.0V，避免釋放重置後被重新誤觸發
xinv_m1 node_m1 node_m1_b vdd gnd INV
xor_m node_m1_b RST node_m2 vdd gnd OR2

mp_tg2 node_m1 CLK_B node_m2 vdd pmos L=0.1u W=1.8u
mn_tg2 node_m1 CLK node_m2 gnd nmos L=0.1u W=1.2u

* Slave 階段
mp_tg3 node_s1 CLK_B node_m2 vdd pmos L=0.1u W=1.8u
mn_tg3 node_s1 CLK node_m2 gnd nmos L=0.1u W=1.2u

* Slave 重置：RST=1 時強制 Q 歸零 (0V)
xnor_s node_s1 RST Q vdd gnd NOR2

xinv_q Q QN vdd gnd INV
mp_tg4 node_s1 CLK QN vdd pmos L=0.1u W=1.8u
mn_tg4 node_s1 CLK_B QN gnd nmos L=0.1u W=1.2u
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

* 設定初始電位，解決 0~5ns 浮點電位問題
.ic v(up)=0 v(dn)=0 v(rst)=0

.probe v(phi_in) v(phi_fb) v(up) v(dn) v(rst)
.op
.option post=2
.end