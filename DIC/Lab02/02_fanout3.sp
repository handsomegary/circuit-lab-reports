DIC Lab 2 step 2: 02_fanout3
* Rewritten from DIC Lab.pdf, Lab 2; original files are references only.
* supplied-model teaching adaptation: 1.0 V operating range, not a model rating claim.
* HSPICE syntax; run this file directly in batch.
* MODEL_SETUP_REQUIRED
.option post=2 nomod measdgt=8 numdgt=8
.temp 25
.option runlvl=6
.param VDDVAL=1.0 TRIN=0.2n TPER=10n TD=1n PW=4.8n
.param TSTOP=30n TPRINT=1p

.subckt INV a y vdd vss
MN y a vss vss nmos W=0.6u L=0.25u
MP y a vdd vdd pmos W=1.8u L=0.25u
.ends INV
X1 in out1 vdd 0 INV
XF1_1 out1 load1_1 vdd 0 INV
XF1_2 out1 load1_2 vdd 0 INV
X2 out1 out2 vdd 0 INV
XF2_1 out2 load2_1 vdd 0 INV
XF2_2 out2 load2_2 vdd 0 INV
X3 out2 out3 vdd 0 INV
XF3_1 out3 load3_1 vdd 0 INV
XF3_2 out3 load3_2 vdd 0 INV
X4 out3 out4 vdd 0 INV
XF4_1 out4 load4_1 vdd 0 INV
XF4_2 out4 load4_2 vdd 0 INV
X5 out4 out5 vdd 0 INV
XF5_1 out5 load5_1 vdd 0 INV
XF5_2 out5 load5_2 vdd 0 INV
X6 out5 out6 vdd 0 INV
XF6_1 out6 load6_1 vdd 0 INV
XF6_2 out6 load6_2 vdd 0 INV
X7 out6 out7 vdd 0 INV
XF7_1 out7 load7_1 vdd 0 INV
XF7_2 out7 load7_2 vdd 0 INV
X8 out7 out8 vdd 0 INV
XF8_1 out8 load8_1 vdd 0 INV
XF8_2 out8 load8_2 vdd 0 INV
X9 out8 out9 vdd 0 INV

VDD vdd 0 'VDDVAL'
VIN in 0 PULSE(0 'VDDVAL' 'TD' 'TRIN' 'TRIN' 'PW' 'TPER')
.tran 'TPRINT' 'TSTOP'
.probe tran V(in) V(out1) V(out2) V(out3) V(out4)
+ V(out5) V(out6) V(out7) V(out8) V(out9)
.measure tran tr1 TRIG V(out1) VAL='0.1*VDDVAL' RISE=1
+ TARG V(out1) VAL='0.9*VDDVAL' RISE=1
.measure tran tf1 TRIG V(out1) VAL='0.9*VDDVAL' FALL=1
+ TARG V(out1) VAL='0.1*VDDVAL' FALL=1
.measure tran tr2 TRIG V(out2) VAL='0.1*VDDVAL' RISE=1
+ TARG V(out2) VAL='0.9*VDDVAL' RISE=1
.measure tran tf2 TRIG V(out2) VAL='0.9*VDDVAL' FALL=1
+ TARG V(out2) VAL='0.1*VDDVAL' FALL=1
.measure tran tr3 TRIG V(out3) VAL='0.1*VDDVAL' RISE=1
+ TARG V(out3) VAL='0.9*VDDVAL' RISE=1
.measure tran tf3 TRIG V(out3) VAL='0.9*VDDVAL' FALL=1
+ TARG V(out3) VAL='0.1*VDDVAL' FALL=1
.measure tran tr4 TRIG V(out4) VAL='0.1*VDDVAL' RISE=1
+ TARG V(out4) VAL='0.9*VDDVAL' RISE=1
.measure tran tf4 TRIG V(out4) VAL='0.9*VDDVAL' FALL=1
+ TARG V(out4) VAL='0.1*VDDVAL' FALL=1
.measure tran tr5 TRIG V(out5) VAL='0.1*VDDVAL' RISE=1
+ TARG V(out5) VAL='0.9*VDDVAL' RISE=1
.measure tran tf5 TRIG V(out5) VAL='0.9*VDDVAL' FALL=1
+ TARG V(out5) VAL='0.1*VDDVAL' FALL=1
.measure tran tr6 TRIG V(out6) VAL='0.1*VDDVAL' RISE=1
+ TARG V(out6) VAL='0.9*VDDVAL' RISE=1
.measure tran tf6 TRIG V(out6) VAL='0.9*VDDVAL' FALL=1
+ TARG V(out6) VAL='0.1*VDDVAL' FALL=1
.measure tran tr7 TRIG V(out7) VAL='0.1*VDDVAL' RISE=1
+ TARG V(out7) VAL='0.9*VDDVAL' RISE=1
.measure tran tf7 TRIG V(out7) VAL='0.9*VDDVAL' FALL=1
+ TARG V(out7) VAL='0.1*VDDVAL' FALL=1
.measure tran tr8 TRIG V(out8) VAL='0.1*VDDVAL' RISE=1
+ TARG V(out8) VAL='0.9*VDDVAL' RISE=1
.measure tran tf8 TRIG V(out8) VAL='0.9*VDDVAL' FALL=1
+ TARG V(out8) VAL='0.1*VDDVAL' FALL=1

.measure tran rise_change_78 PARAM='abs(tr8-tr7)/tr8'
.measure tran fall_change_78 PARAM='abs(tf8-tf7)/tf8'
.measure tran pavg AVG PAR('-V(vdd)*I(VDD)') FROM='TPER' TO='3*TPER'
* The handout requests 0 ns. HSPICE replaces zero PULSE edges by a default.
* 1 ps is an explicit near-step approximation; it is not claimed to be exactly 0 ns.
.alter edge_near_step_1ps
.param TRIN=1p TPER=10n TD=1n PW=4.999n TSTOP=30n TPRINT=1p
.alter edge_slow_2us
.param TRIN=2u TPER=20u TD=1u PW=8u TSTOP=60u TPRINT=100p
.end
