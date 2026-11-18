* ========================================================
* FO4 Minimum Average Delay (t_avg) Sweep Optimization (Smooth Curve)
* ========================================================

* MODEL_SETUP_REQUIRED
.param supply = 1.0v

* 1. 宣告 Sweep 初始值
.param wp_val = 1.2u

vvdd vdd 0 supply
vin in 0 PULSE(0 supply 0p 50p 50p 2n 4n)

.subckt inv in out vdd vss
mp1 out in vdd vdd pmos L=0.25u W=wp_val
mn1 out in vss vss nmos L=0.25u W=0.6u
.ends inv

* ========================================================
* Circuit Topology
* ========================================================
x1 in n1 vdd 0 inv
xdut n1 n2 vdd 0 inv

xload1 n2 n3_1 vdd 0 inv
xload2 n2 n3_2 vdd 0 inv
xload3 n2 n3_3 vdd 0 inv
xload4 n2 n3_4 vdd 0 inv

xterm1_1 n3_1 n4_11 vdd 0 inv
xterm1_2 n3_1 n4_12 vdd 0 inv
xterm1_3 n3_1 n4_13 vdd 0 inv
xterm1_4 n3_1 n4_14 vdd 0 inv

xterm2_1 n3_2 n4_21 vdd 0 inv
xterm2_2 n3_2 n4_22 vdd 0 inv
xterm2_3 n3_2 n4_23 vdd 0 inv
xterm2_4 n3_2 n4_24 vdd 0 inv

xterm3_1 n3_3 n4_31 vdd 0 inv
xterm3_2 n3_3 n4_32 vdd 0 inv
xterm3_3 n3_3 n4_33 vdd 0 inv
xterm3_4 n3_3 n4_34 vdd 0 inv

xterm4_1 n3_4 n4_41 vdd 0 inv
xterm4_2 n3_4 n4_42 vdd 0 inv
xterm4_3 n3_4 n4_43 vdd 0 inv
xterm4_4 n3_4 n4_44 vdd 0 inv

* ========================================================
* 2. SWEEP 語法：步階縮細至 0.02u (讓圖形取樣點更密)
* ========================================================
.tran 1p 5n SWEEP wp_val 0.6u 4.0u 0.02u

.measure tran tpHL trig v(n1) val='supply*0.5' rise=1 targ v(n2) val='supply*0.5' fall=1
.measure tran tpLH trig v(n1) val='supply*0.5' fall=1 targ v(n2) val='supply*0.5' rise=1

* 計算平均延遲
.measure tran t_fo4 param='(tpHL + tpLH)/2'

.op

* ========================================================
* 3. 消除鋸齒波高精確度設定 (核心修改區)
* ========================================================
.option numdgt=8    $ 將 .mt0 數據精度提升至 8 位數，消除四捨五入階梯
.option delmax=1p   $ 強制限制瞬態分析最大時間步階為 1ps
.option accurate   $ 啟用高精確度電路求解演算法
.option post=2
.end