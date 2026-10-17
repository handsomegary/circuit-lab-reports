DIC Lab 14: 05_alternative_dc
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
XALT in ya vdd 0 ALT
VIN in 0 0
.param VSTART=0 VSTOP=1 VSTEP=0.0005
.dc VIN 'VSTART' 'VSTOP' 'VSTEP'
.print dc V(in) V(yi) V(ya)
.measure dc vm_ya FIND V(in) WHEN V(ya)=0.5 CROSS=1
.alter reverse
.param VSTART=1 VSTOP=0 VSTEP=-0.0005

.end
