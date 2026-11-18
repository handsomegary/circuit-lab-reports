DIC Lab 13: 01_ratio
* MODEL_SETUP_REQUIRED
* Handout-based simulation at 1 V; this condition is not a model voltage rating.
.option post=2 nomod runlvl=6 measdgt=10 numdgt=10 ingold=2
.temp 27
.param VS=1
VDD vdd 0 'VS'
.param RATIO=1.5 SIZE=1 CLVAL=7f PERIOD=2n
VC cdd 0 VS
VP pdd 0 VS
VIN in 0 PULSE(0 1 'PERIOD/4' 'PERIOD/100' 'PERIOD/100' 'PERIOD*.48' PERIOD)
MNC yc in 0 0 nmos W='0.6u*SIZE' L=.25u
MPC yc in cdd cdd pmos W='0.6u*SIZE*RATIO' L=.25u
MNP yp in 0 0 nmos W='0.6u*SIZE' L=.25u
MPP yp 0 pdd pdd pmos W='0.6u*SIZE*RATIO' L=.25u
CC yc 0 CLVAL
CP yp 0 CLVAL
.tran 'PERIOD/500' 'PERIOD*12'
.print tran V(in) V(yc) V(yp)
.measure tran c_power AVG PAR('-V(cdd)*I(VC)') FROM='PERIOD*4' TO='PERIOD*12'
.measure tran p_power AVG PAR('-V(pdd)*I(VP)') FROM='PERIOD*4' TO='PERIOD*12'
.measure tran c_low FIND V(yc) AT='PERIOD*10.7'
.measure tran c_high FIND V(yc) AT='PERIOD*11.2'
.measure tran p_low FIND V(yp) AT='PERIOD*10.7'
.measure tran p_high FIND V(yp) AT='PERIOD*11.2'
.measure tran p_ilo FIND I(VP) AT='PERIOD*10.7'
.param RATIO=0.25 SIZE=1 CLVAL=7f PERIOD=2n
.temp 27

.alter case_001
.param RATIO=0.5 SIZE=1 CLVAL=7f PERIOD=2n
.temp 27

.alter case_002
.param RATIO=1 SIZE=1 CLVAL=7f PERIOD=2n
.temp 27

.alter case_003
.param RATIO=1.5 SIZE=1 CLVAL=7f PERIOD=2n
.temp 27

.alter case_004
.param RATIO=3 SIZE=1 CLVAL=7f PERIOD=2n
.temp 27

.alter case_005
.param RATIO=6 SIZE=1 CLVAL=7f PERIOD=2n
.temp 27

.end
