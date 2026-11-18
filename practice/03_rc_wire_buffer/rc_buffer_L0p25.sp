.title CMOS buffer regeneration, L=0.25u (title line added; see README)
* MODEL_SETUP_REQUIRED
* 1. 電源與輸入訊號 (參考接地點統一為 0)
Vvdd vdd 0 1.2V
Vin  in  0 PULSE(0V 1.2V 0n 0.1n 0.1n 5n 10n)

* 2. 模擬長導線衰減 (RC 高阻抗與寄生電容)
Rwire in   in_degraded 20k
Cwire in_degraded 0     500fF

* 3. 第一級 Inverter (修正接地腳位為 0)
Mp1 out1 in_degraded vdd vdd pmos L=0.25u W=1.2u
Mn1 out1 in_degraded 0   0   nmos L=0.25u W=0.6u

* 4. 第二級 Inverter (修正接地腳位為 0)
Mp2 out  out1        vdd vdd pmos L=0.25u W=1.2u
Mn2 out  out1        0   0   nmos L=0.25u W=0.6u

* 5. 時域分析設定
.tran 0.01n 30n
.probe v(in) v(in_degraded) v(out1) v(out)
.option post=2
.end