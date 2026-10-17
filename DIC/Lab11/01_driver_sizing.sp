DIC Lab 11: 01_driver_sizing
* MODEL_SETUP_REQUIRED
* Handout-based simulation at 1 V; this condition is not a model voltage rating.
.option post=2 nomod runlvl=6 measdgt=10 numdgt=10 ingold=2
.temp 27
.param VS=1
VDD vdd 0 'VS'
.subckt INV a y vp vn wn=0.6u wp=1.8u ll=0.25u
MN y a vn vn nmos W=wn L=ll
MP y a vp vp pmos W=wp L=ll
.ends INV
.param SIZE=1 LEN=10000 RUNIT=0.17 CUNIT=0.211
VIN in 0 PULSE(0 1 5n 100p 100p 80n 200n)
XD in t1 vdd 0 INV wn='WNBASE*SIZE' wp='WPBASE*SIZE' ll=LBASE
R1 t1 n1 'RUNIT*LEN/3'
R2 n1 n2 'RUNIT*LEN/3'
R3 n2 t2 'RUNIT*LEN/3'
C1 t1 0 'CUNIT*1f*LEN/6'
C2 n1 0 'CUNIT*1f*LEN/3'
C3 n2 0 'CUNIT*1f*LEN/3'
C4 t2 0 'CUNIT*1f*LEN/6'
XR t2 out vdd 0 INV wn=WNBASE wp=WPBASE ll=LBASE
CL out 0 10f
.tran 20p 180n
.print tran V(in) V(t1) V(t2) V(out)
.measure tran t1_tphl TRIG V(in) VAL='VS/2' RISE=1 TARG V(t1) VAL='VS/2' FALL=1
.measure tran t1_tplh TRIG V(in) VAL='VS/2' FALL=1 TARG V(t1) VAL='VS/2' RISE=1
.measure tran t2_tphl TRIG V(in) VAL='VS/2' RISE=1 TARG V(t2) VAL='VS/2' FALL=1
.measure tran t2_tplh TRIG V(in) VAL='VS/2' FALL=1 TARG V(t2) VAL='VS/2' RISE=1
.measure tran t3_r TRIG V(in) VAL='VS/2' RISE=1 TARG V(out) VAL='VS/2' RISE=1
.measure tran t3_f TRIG V(in) VAL='VS/2' FALL=1 TARG V(out) VAL='VS/2' FALL=1
.param SIZE=1 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_001
.param SIZE=2 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_002
.param SIZE=3 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_003
.param SIZE=4 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_004
.param SIZE=5 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_005
.param SIZE=6 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_006
.param SIZE=7 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_007
.param SIZE=8 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_008
.param SIZE=9 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_009
.param SIZE=10 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_010
.param SIZE=11 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_011
.param SIZE=12 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_012
.param SIZE=13 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_013
.param SIZE=14 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_014
.param SIZE=15 LEN=10000 RUNIT=0.17 CUNIT=0.211 WNBASE=.9u WPBASE=2.7u LBASE=.35u
.temp 27

.alter case_015
.param SIZE=1 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_016
.param SIZE=2 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_017
.param SIZE=3 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_018
.param SIZE=4 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_019
.param SIZE=5 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_020
.param SIZE=6 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_021
.param SIZE=7 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_022
.param SIZE=8 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_023
.param SIZE=9 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_024
.param SIZE=10 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_025
.param SIZE=11 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_026
.param SIZE=12 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_027
.param SIZE=13 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_028
.param SIZE=14 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_029
.param SIZE=15 LEN=10000 RUNIT=0.238 CUNIT=0.239 WNBASE=.6u WPBASE=1.8u LBASE=.25u
.temp 27

.alter case_030
.param SIZE=1 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_031
.param SIZE=2 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_032
.param SIZE=3 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_033
.param SIZE=4 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_034
.param SIZE=5 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_035
.param SIZE=6 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_036
.param SIZE=7 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_037
.param SIZE=8 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_038
.param SIZE=9 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_039
.param SIZE=10 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_040
.param SIZE=11 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_041
.param SIZE=12 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_042
.param SIZE=13 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_043
.param SIZE=14 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.alter case_044
.param SIZE=15 LEN=10000 RUNIT=0.339 CUNIT=0.246 WNBASE=.5u WPBASE=1.5u LBASE=.18u
.temp 27

.end
