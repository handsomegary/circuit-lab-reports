DIC Lab 15: 07_dc_sf
* Handout PDF pages 62-64; user-selected CIC 0.18 um 1.8 V devices.
* Nominal 1.8 V; +/-10 percent are explicit corner experiments.
* Geometry retains handout Wn/Wp/L = 0.6/1.8/0.25 um.
* MODEL_SETUP_REQUIRED SF
.option post=2 runlvl=6 accurate warnlimit=100 measdgt=8 numdgt=8 ingold=2
.param VDDVAL=1.8
.temp 25
.option gmin=1e-18 gmindc=1e-18 pivtol=1e-20 abstol=1e-18
VIN in 0 0
* Static CMOS and pseudo-NMOS use independent supplies for current measurement.
VCMOS vc 0 'VDDVAL'
VRATIO vr 0 'VDDVAL'
MP1 outc in vc vc p_18 w=1.8u l=.25u
MN1 outc in 0 0 n_18 w=.6u l=.25u
MP2 outr 0 vr vr p_18 w=.6u l=.5u
MN2 outr in 0 0 n_18 w=.6u l=.25u
* Isolate the TWO reverse-biased D/B and S/B junctions: Vds=0, Vgs=0.
* Explicit diffusion geometry, same as W=0.6 um and extension=0.25 um.
* Gate, drain and source tied together, so no drain-source channel current.
EJN jn 0 in 0 1
VBN bn 0 0
MNJ jn jn jn bn n_18 w=.6u l=.25u ad=.15p as=.15p pd=1.7u ps=1.7u
EJP jp 0 vol='VDDVAL-v(in)'
VBP bp 0 'VDDVAL'
MPJ jp jp jp bp p_18 w=.6u l=.25u ad=.15p as=.15p pd=1.7u ps=1.7u
.dc VIN 0 1.8 .001
.print dc v(in) v(outc) v(outr) i(VCMOS) i(VRATIO) i(VBN) i(VBP)
.measure dc cmos_low find v(outc) at=1.8
.measure dc ratio_low find v(outr) at=1.8
.measure dc ratio_static_current find i(VRATIO) at=1.8
.measure dc cmos_off_low find i(VCMOS) at=0
.measure dc cmos_off_high find i(VCMOS) at=1.8
.measure dc n_junction find i(VBN) at=1.8
.measure dc p_junction find i(VBP) at=1.8

.end
