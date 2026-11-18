.title CMOS AND Gate - 4 Versions Parallel Comparison for WaveView

* MODEL_SETUP_REQUIRED
* ==================================================
* 1. 電源與輸入訊號 (Power Supply & Input Signals)
* ==================================================
vvdd vdd 0 DC 1.0V

* 標準輸入 (tr=tf=0.1ns，用於 Base, Sol1, Sol2)
va   a   0 PULSE(0 1.0V 0ns 0.1ns  0.1ns  20ns 40ns)
vb   b   0 PULSE(0 1.0V 0ns 0.1ns  0.1ns  10ns 20ns)

* 高速輸入 (tr=tf=0.01ns，專用於 Sol3: Fast Edge 測試)
va_f a_f 0 PULSE(0 1.0V 0ns 0.01ns 0.01ns 20ns 40ns)
vb_f b_f 0 PULSE(0 1.0V 0ns 0.01ns 0.01ns 10ns 20ns)


* ==================================================
* Version 0: Baseline (原始有 Glitch 的 AND 閘)
* Output: and_out_base
* ==================================================
mp1_0 nand_out_0 a vdd vdd pmos L=0.1u W=1.8u
mp2_0 nand_out_0 b vdd vdd pmos L=0.1u W=1.8u
mn1_0 nand_out_0 a n_mid_0 0 nmos L=0.1u W=1.2u
mn2_0 n_mid_0    b 0       0 nmos L=0.1u W=1.2u

mp_inv0 and_out_base nand_out_0 vdd vdd pmos L=0.1u W=1.8u
mn_inv0 and_out_base nand_out_0 0   0   nmos L=0.1u W=0.6u


* ==================================================
* Version 1: Solution 1 (加大 PMOS 驅動能力, Wp = 3.0u)
* Output: and_out_sol1
* ==================================================
mp1_1 nand_out_1 a vdd vdd pmos L=0.1u W=3.0u
mp2_1 nand_out_1 b vdd vdd pmos L=0.1u W=3.0u
mn1_1 nand_out_1 a n_mid_1 0 nmos L=0.1u W=1.2u
mn2_1 n_mid_1    b 0       0 nmos L=0.1u W=1.2u

mp_inv1 and_out_sol1 nand_out_1 vdd vdd pmos L=0.1u W=1.8u
mn_inv1 and_out_sol1 nand_out_1 0   0   nmos L=0.1u W=0.6u


* ==================================================
* Version 2: Solution 2 (中間節點加入 3fF 低通濾波電容)
* Output: and_out_sol2
* ==================================================
mp1_2 nand_out_2 a vdd vdd pmos L=0.1u W=1.8u
mp2_2 nand_out_2 b vdd vdd pmos L=0.1u W=1.8u
mn1_2 nand_out_2 a n_mid_2 0 nmos L=0.1u W=1.2u
mn2_2 n_mid_2    b 0       0 nmos L=0.1u W=1.2u

c_flt2 nand_out_2 0 3f   * 濾波電容壓制 Glitch

mp_inv2 and_out_sol2 nand_out_2 vdd vdd pmos L=0.1u W=1.8u
mn_inv2 and_out_sol2 nand_out_2 0   0   nmos L=0.1u W=0.6u


* ==================================================
* Version 3: Solution 3 (優化輸入斜率, 使用 Fast Edge 輸入)
* Output: and_out_sol3
* ==================================================
mp1_3 nand_out_3 a_f vdd vdd pmos L=0.1u W=1.8u
mp2_3 nand_out_3 b_f vdd vdd pmos L=0.1u W=1.8u
mn1_3 nand_out_3 a_f n_mid_3 0 nmos L=0.1u W=1.2u
mn2_3 n_mid_3    b_f 0       0 nmos L=0.1u W=1.2u

mp_inv3 and_out_sol3 nand_out_3 vdd vdd pmos L=0.1u W=1.8u
mn_inv3 and_out_sol3 nand_out_3 0   0   nmos L=0.1u W=0.6u


* ==================================================
* 模擬與波形輸出 (Simulation Setup)
* ==================================================
.tran 0.05ns 80ns

* 同時 Probe 四個版本的輸出波形，便於在 WaveView 比對
.probe v(and_out_base) v(and_out_sol1) v(and_out_sol2) v(and_out_sol3)
.op
.option post=2
.end