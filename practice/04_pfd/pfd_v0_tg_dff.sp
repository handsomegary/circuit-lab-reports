.title Phase Frequency Detector (PFD) Simulation for WaveView

* MODEL_SETUP_REQUIRED
* ==================================================
* 1. 電源與輸入訊號 (Power Supply & Input Signals)
* ==================================================
vvdd vdd 0 DC 1.0V

* PWL 訊號編排：手動控制相位差以觸發完整狀態轉移
* 0~5ns    : (0, 0) 初始狀態
* 5~20ns   : phi_in 先升起  --> UP=1, DN=0 (1, 0)
* 25~40ns  : phi_fb 先升起  --> UP=0, DN=1 (0, 1)
* 45~60ns  : phi_in 與 phi_fb 相繼升起 --> 進入 (1, 1) 並立刻觸發 Reset 歸零 (0, 0)

vphi_in phi_in 0 PWL(0ns 0V  5ns 0V  5.1ns 1.0V  20ns 1.0V  20.1ns 0V  45ns 0V  45.1ns 1.0V  60ns 1.0V  60.1ns 0V)

vphi_fb phi_fb 0 PWL(0ns 0V  25ns 0V  25.1ns 1.0V  40ns 1.0V  40.1ns 0V  47ns 0V  47.1ns 1.0V  60ns 1.0V  60.1ns 0V)


* ==================================================
* 2. 子電路定義 (Subcircuit Definitions)
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

* --- 2輸入 AND 閘 (用於重置路徑) ---
.subckt AND2 a b out vdd gnd
x_nand a b nand_out vdd gnd NAND2
x_inv nand_out out vdd gnd INV
.ends

* --- 2輸入 NOR 閘 ---
.subckt NOR2 a b out vdd gnd
mp1 p_mid a vdd vdd pmos L=0.1u W=1.8u
mp2 out b p_mid vdd pmos L=0.1u W=1.8u
mn1 out a gnd gnd nmos L=0.1u W=0.6u
mn2 out b gnd gnd nmos L=0.1u W=0.6u
.ends

* --- 帶有非同步高電位重置 (Reset) 的 D-Flip-Flop ---
.subckt DFF_R D CLK RST Q QN vdd gnd
* 時脈反相
xclk_inv CLK CLK_B vdd gnd INV

* 主鎖存器 (Master Stage) Transmission Gate & NOR Reset
mp_tg1 node_m1 CLK D vdd pmos L=0.1u W=1.8u
mn_tg1 node_m1 CLK_B D gnd nmos L=0.1u W=1.2u

xnor_m node_m1 RST node_m2 vdd gnd NOR2

mp_tg2 node_m1 CLK_B node_m2 vdd pmos L=0.1u W=1.8u
mn_tg2 node_m1 CLK node_m2 gnd nmos L=0.1u W=1.2u

* 從鎖存器 (Slave Stage) Transmission Gate & NOR Reset
mp_tg3 node_s1 CLK_B node_m2 vdd pmos L=0.1u W=1.8u
mn_tg3 node_s1 CLK node_m2 gnd nmos L=0.1u W=1.2u

xnor_s node_s1 RST Q vdd gnd NOR2

xinv_q Q QN vdd gnd INV
mp_tg4 node_s1 CLK QN vdd pmos L=0.1u W=1.8u
mn_tg4 node_s1 CLK_B QN gnd nmos L=0.1u W=1.2u
.ends


* ==================================================
* 3. PFD 主電路拓撲 (Top-Level PFD Architecture)
* ==================================================
* D 輸入固定拉至 VDD (1.0V)
* UP 鎖存器
xdff_up vdd phi_in rst up up_n vdd 0 DFF_R

* DN 鎖存器
xdff_dn vdd phi_fb rst dn dn_n vdd 0 DFF_R

* AND 閘 (偵測 UP=1 且 DN=1，輸出 Reset 訊號)
xand_reset up dn rst vdd 0 AND2


* ==================================================
* 4. 模擬 Setup
* ==================================================
.tran 0.05ns 70ns

.probe v(phi_in) v(phi_fb) v(up) v(dn) v(rst)
.op
.option post=2
.end