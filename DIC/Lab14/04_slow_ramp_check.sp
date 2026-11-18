DIC Lab 14: 04_slow_ramp_check
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
.subckt SCH a y vp vn f=1
MP1 p a vp vp pmos W=3.6u L=0.25u
MP2 y a p vp pmos W=3.6u L=0.25u
MN1 n a vn vn nmos W=1.2u L=0.25u
MN2 y a n vn nmos W=1.2u L=0.25u
MP3 vn y p vp pmos W='1.8u*f' L=0.25u
MN3 vp y n vn nmos W='0.6u*f' L=0.25u
.ends SCH
* Alternative: a strong input inverter drives a weak cross-coupled inverter pair.
.subckt ALT a y vp vn
XIN a y vp vn INV wn=1.2u wp=3.6u
XFB q y vp vn INV wn=0.6u wp=1.8u
XSENSE y q vp vn INV wn=0.6u wp=1.8u
.ends ALT
XINV in yi vdd 0 INV
XS1 in ys1 vdd 0 SCH f=1
XS2 in ys2 vdd 0 SCH f=2
XS3 in ys3 vdd 0 SCH f=3
XALT in ya vdd 0 ALT
.param TSCALE=1
VIN in 0 PWL(0 0 '100n*TSCALE' 0 '1100n*TSCALE' 1 '1200n*TSCALE' 1 '2200n*TSCALE' 0 '2300n*TSCALE' 0)
.tran '100p*TSCALE' '2300n*TSCALE'
.print tran V(in) V(yi) V(ys1) V(ys2) V(ys3) V(ya)
.measure tran vp_yi FIND V(in) WHEN V(yi)=0.5 FALL=1
.measure tran vm_yi FIND V(in) WHEN V(yi)=0.5 RISE=1
.measure tran vp_ys1 FIND V(in) WHEN V(ys1)=0.5 FALL=1
.measure tran vm_ys1 FIND V(in) WHEN V(ys1)=0.5 RISE=1
.measure tran vp_ys2 FIND V(in) WHEN V(ys2)=0.5 FALL=1
.measure tran vm_ys2 FIND V(in) WHEN V(ys2)=0.5 RISE=1
.measure tran vp_ys3 FIND V(in) WHEN V(ys3)=0.5 FALL=1
.measure tran vm_ys3 FIND V(in) WHEN V(ys3)=0.5 RISE=1
.measure tran vp_ya FIND V(in) WHEN V(ya)=0.5 FALL=1
.measure tran vm_ya FIND V(in) WHEN V(ya)=0.5 RISE=1
.alter slower_ramp
.param TSCALE=10

.end
