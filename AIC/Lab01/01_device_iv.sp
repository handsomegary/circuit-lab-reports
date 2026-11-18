* AIC Lab 01 - NMOS and PMOS current sources, gate and length sweeps
* Handout: AIC Lab.pdf, PDF pages 2-4 (one-based physical pages).
* supplied-model adaptation: 1 V is a teaching assumption, NOT a verified model rating.
* The original 0.35 um / 3.3 V numerical results are NOT supplied-model specifications.
* Device geometry is not blindly scaled to 90 nm.
* Nominal reference is 50 uA; separate 10 uA and 1 uA alters show headroom.
* Ideal current sources do NOT enforce supply compliance. Check every bias node.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate measdgt=8 numdgt=8 ingold=2
.temp 27
.param VDDVAL=1.0 IREFVAL=50u WUNIT=3u LUNIT=1.4u
* W=5u follows handout p3; lengths reproduce p4 comparison without scaling.
.param LCHAR=1.4u
VDD vdd 0 'VDDVAL'
VD nd 0 0.8 ac 1
VG ng 0 0.6
MN nd ng 0 0 nmos w=5u l='LCHAR'
* Equal magnitude VSG and VSD: EPG and EPD translate the NMOS axes.
EPG pg vdd ng 0 -1
EPD pd vdd nd 0 -1
MP pd pg vdd vdd pmos w=5u l='LCHAR'
.op
.dc VD 0 'VDDVAL' 0.01 VG 0 'VDDVAL' 0.1
.print dc v(nd) v(ng) i(MN) i(MP)
+ rn=par('1/max(abs(lx8(MN)),1e-30)')
+ rp=par('1/max(abs(lx8(MP)),1e-30)')
* This nested sweep intentionally uses waveform data, not one scalar result.
.alter length_035u
.param LCHAR=0.35u
.alter length_070u
.param LCHAR=0.70u
.alter length_280u
.param LCHAR=2.80u
.end
