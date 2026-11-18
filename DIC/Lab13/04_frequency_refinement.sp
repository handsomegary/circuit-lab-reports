DIC Lab 13: 04_frequency_refinement
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
.param RATIO=1.5 SIZE=1 CLVAL=7f PERIOD=0.322580645161n
.temp 27

.alter case_001
.param RATIO=1.5 SIZE=1 CLVAL=7f PERIOD=0.3125n
.temp 27

.alter case_002
.param RATIO=1.5 SIZE=1 CLVAL=7f PERIOD=0.30303030303n
.temp 27

.alter case_003
.param RATIO=1.5 SIZE=1 CLVAL=7f PERIOD=0.294117647059n
.temp 27

.alter case_004
.param RATIO=1.5 SIZE=1 CLVAL=7f PERIOD=0.285714285714n
.temp 27

.alter case_005
.param RATIO=1.5 SIZE=1 CLVAL=7f PERIOD=0.277777777778n
.temp 27

.alter case_006
.param RATIO=1.5 SIZE=1 CLVAL=7f PERIOD=0.27027027027n
.temp 27

.alter case_007
.param RATIO=1.5 SIZE=1 CLVAL=7f PERIOD=0.263157894737n
.temp 27

.alter case_008
.param RATIO=1.5 SIZE=1 CLVAL=7f PERIOD=0.25641025641n
.temp 27

.alter case_009
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.243902439024n
.temp 27

.alter case_010
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.238095238095n
.temp 27

.alter case_011
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.232558139535n
.temp 27

.alter case_012
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.227272727273n
.temp 27

.alter case_013
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.222222222222n
.temp 27

.alter case_014
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.217391304348n
.temp 27

.alter case_015
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.212765957447n
.temp 27

.alter case_016
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.208333333333n
.temp 27

.alter case_017
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.204081632653n
.temp 27

.alter case_018
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.196078431373n
.temp 27

.alter case_019
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.192307692308n
.temp 27

.alter case_020
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.188679245283n
.temp 27

.alter case_021
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.185185185185n
.temp 27

.alter case_022
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.181818181818n
.temp 27

.alter case_023
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.178571428571n
.temp 27

.alter case_024
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.175438596491n
.temp 27

.alter case_025
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.172413793103n
.temp 27

.alter case_026
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.169491525424n
.temp 27

.alter case_027
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.166666666667n
.temp 27

.alter case_028
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.16393442623n
.temp 27

.alter case_029
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.161290322581n
.temp 27

.alter case_030
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.15873015873n
.temp 27

.alter case_031
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.15625n
.temp 27

.alter case_032
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.153846153846n
.temp 27

.alter case_033
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.151515151515n
.temp 27

.alter case_034
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.149253731343n
.temp 27

.alter case_035
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.147058823529n
.temp 27

.alter case_036
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.144927536232n
.temp 27

.alter case_037
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.142857142857n
.temp 27

.alter case_038
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.140845070423n
.temp 27

.alter case_039
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.138888888889n
.temp 27

.alter case_040
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.13698630137n
.temp 27

.alter case_041
.param RATIO=1.5 SIZE=2 CLVAL=7f PERIOD=0.135135135135n
.temp 27

.alter case_042
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.909090909091n
.temp 27

.alter case_043
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.833333333333n
.temp 27

.alter case_044
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.769230769231n
.temp 27

.alter case_045
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.714285714286n
.temp 27

.alter case_046
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.666666666667n
.temp 27

.alter case_047
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.625n
.temp 27

.alter case_048
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.588235294118n
.temp 27

.alter case_049
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.555555555556n
.temp 27

.alter case_050
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.526315789474n
.temp 27

.alter case_051
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.47619047619n
.temp 27

.alter case_052
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.454545454545n
.temp 27

.alter case_053
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.434782608696n
.temp 27

.alter case_054
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.416666666667n
.temp 27

.alter case_055
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.4n
.temp 27

.alter case_056
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.384615384615n
.temp 27

.alter case_057
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.37037037037n
.temp 27

.alter case_058
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.357142857143n
.temp 27

.alter case_059
.param RATIO=1.5 SIZE=1 CLVAL=14f PERIOD=0.344827586207n
.temp 27

.alter case_060
.param RATIO=1.5 SIZE=2 CLVAL=14f PERIOD=0.322580645161n
.temp 27

.alter case_061
.param RATIO=1.5 SIZE=2 CLVAL=14f PERIOD=0.3125n
.temp 27

.alter case_062
.param RATIO=1.5 SIZE=2 CLVAL=14f PERIOD=0.30303030303n
.temp 27

.alter case_063
.param RATIO=1.5 SIZE=2 CLVAL=14f PERIOD=0.294117647059n
.temp 27

.alter case_064
.param RATIO=1.5 SIZE=2 CLVAL=14f PERIOD=0.285714285714n
.temp 27

.alter case_065
.param RATIO=1.5 SIZE=2 CLVAL=14f PERIOD=0.277777777778n
.temp 27

.alter case_066
.param RATIO=1.5 SIZE=2 CLVAL=14f PERIOD=0.27027027027n
.temp 27

.alter case_067
.param RATIO=1.5 SIZE=2 CLVAL=14f PERIOD=0.263157894737n
.temp 27

.alter case_068
.param RATIO=1.5 SIZE=2 CLVAL=14f PERIOD=0.25641025641n
.temp 27

.end
