DIC Lab 8: 01_dc_transfer
* Specification-based teaching adaptation; 1 V is a simulation condition, not a model rating.
* MODEL_SETUP_REQUIRED
.option post=2 nomod runlvl=6 measdgt=10 numdgt=10 ingold=2
.temp 25
.param VS=1
VDD vdd 0 'VS'
.subckt INV a y vp vn wn=0.6u wp=1.8u ll=0.25u
MN y a vn vn nmos W=wn L=ll
MP y a vp vp pmos W=wp L=ll
.ends INV
X0 in y0 vdd 0 INV wp=0.45u
X1 in y1 vdd 0 INV wp=1.8u
X2 in y2 vdd 0 INV wp=7.2u
* PDF pages 31-34: ratios 0.75, 3 and 12; derivative extraction uses printed data.
VIN in 0 0
.dc VIN 0 1 0.0005
.print dc V(in) V(y0) V(y1) V(y2)
.measure dc vth0 FIND V(in) WHEN V(y0)=0.5 CROSS=1
.measure dc vth1 FIND V(in) WHEN V(y1)=0.5 CROSS=1
.measure dc vth2 FIND V(in) WHEN V(y2)=0.5 CROSS=1

.end
