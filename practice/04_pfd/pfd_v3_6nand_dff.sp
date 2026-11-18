.title Phase Frequency Detector (PFD) - 6-NAND Architecture Fix

* MODEL_SETUP_REQUIRED
* ==================================================
* 1. 電源與輸入訊號 (PWL 語法)
* ==================================================
vvdd vdd 0 DC 1.0V

* phi_in: 5ns 上升 (觸發 UP=1)
vphi_in phi_in 0 PWL(0ns 0V  5ns 0V  5.1ns 1.0V  20ns 1.0V  20.1ns 0V  45ns 0V  45.1ns 1.0V  60ns 1.0V  60.1ns 0V)

* phi_fb: 25ns 上升 (觸發 DN=1)，47ns 再上升 (觸發 UP=1 & DN=1 重置)
vphi_fb phi_fb 0 PWL(0ns 0V  25ns 0V  25.1ns 1.0V  40ns 1.0V  40.1ns 0V  47ns 0V  47.1ns 1.0V  60ns 1.0V  60.1ns 0V)


* ==================================================
* 2. 基礎邏輯門定義
* ==================================================
.subckt INV in out vdd gnd
mp1 out in vdd vdd pmos L=0.1u W=1.8u
mn1 out in gnd gnd nmos L=0.1u W=0.6u
.ends

.subckt NAND2 a b out vdd gnd
mp1 out a vdd vdd pmos L=0.1u W=1.8u
mp2 out b vdd vdd pmos L=0.1u W=1.8u
mn1 out a n1 gnd nmos L=0.1u W=1.2u
mn2 n1 b gnd gnd nmos L=0.1u W=1.2u
.ends

.subckt NAND3 a b c out vdd gnd
mp1 out a vdd vdd pmos L=0.1u W=1.8u
mp2 out b vdd vdd pmos L=0.1u W=1.8u
mp3 out c vdd vdd pmos L=0.1u W=1.8u
mn1 out a n1 gnd nmos L=0.1u W=1.8u
mn2 n1 b n2 gnd nmos L=0.1u W=1.8u
mn3 n2 c gnd gnd nmos L=0.1u W=1.8u
.ends


* ==================================================
* 3. 工業標準 6-NAND 邊緣觸發 DFF (帶非同步高電位重置)
* ==================================================
.subckt DFF_R D CLK RST Q QN vdd gnd
* 產生反相 Reset 訊號 (RSTB)
xinv_rst RST RSTB vdd gnd INV

* 內部 3-SR 鎖存器結構 (6-NAND)
xnand1 S4 D RSTB S1 vdd gnd NAND3
xnand2 S1 CLK RSTB S2 vdd gnd NAND3
xnand3 S2 CLK S3 vdd gnd NAND2
xnand4 S3 S2 RSTB S4 vdd gnd NAND3

* 輸出 RS 鎖存器
xnand5 S2 QN Q vdd gnd NAND2
xnand6 S4 Q RSTB QN vdd gnd NAND3
.ends


* ==================================================
* 4. PFD 頂層電路 (包含重置緩衝延遲鏈)
* ==================================================
xdff_up vdd phi_in rst up up_n vdd 0 DFF_R
xdff_dn vdd phi_fb rst dn dn_n vdd 0 DFF_R

* 重置 AND 邏輯 (NAND2 + INV)
xnand_rst up dn rst_raw vdd 0 NAND2
xinv_rst  rst_raw rst_node vdd 0 INV

* 重置延遲鏈 (防止 Reset Race Conditions)
xdel1 rst_node rst_d1 vdd 0 INV
xdel2 rst_d1   rst    vdd 0 INV


* ==================================================
* 5. 模擬 Setup
* ==================================================
.tran 0.05ns 70ns

.probe v(phi_in) v(phi_fb) v(up) v(dn) v(rst)
.op
.option post=2
.end