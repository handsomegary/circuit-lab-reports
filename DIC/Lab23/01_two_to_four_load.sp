* DIC Lab 23: NAND and NOR two-to-four decoder
* Handout PDF pages 91-93. 1 V teaching adaptation.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* NAND implementation has 28 MOS; NOR has 20 including input complements.
* One-hot truth is checked at every settled code; transition hazards retained.
.param cl=10f
.subckt inv a z vp vn k=1
MP z a vp vp pmos w='3.6u*k' l=.25u
MN z a vn vn nmos w='1.8u*k' l=.25u
.ends inv
.subckt tg a z en eb vp vn k=1
MP a eb z vp pmos w='3.6u*k' l=.25u
MN a en z vn nmos w='1.8u*k' l=.25u
.ends tg
.subckt nand2 a0 a1 z vp vn k=1
MP0 z a0 vp vp pmos w='3.6u*k' l=.25u
MN0 z a0 n1 vn nmos w='3.6u*k' l=.25u
MP1 z a1 vp vp pmos w='3.6u*k' l=.25u
MN1 n1 a1 vn vn nmos w='3.6u*k' l=.25u
.ends nand2
.subckt nor2 a0 a1 z vp vn k=1
MN0 z a0 vn vn nmos w='1.8u*k' l=.25u
MP0 z a0 p1 vp pmos w='7.2u*k' l=.25u
MN1 z a1 vn vn nmos w='1.8u*k' l=.25u
MP1 p1 a1 vp vp pmos w='7.2u*k' l=.25u
.ends nor2
.subckt nand3 a0 a1 a2 z vp vn k=1
MP0 z a0 vp vp pmos w='3.6u*k' l=.25u
MN0 z a0 n1 vn nmos w='5.4u*k' l=.25u
MP1 z a1 vp vp pmos w='3.6u*k' l=.25u
MN1 n1 a1 n2 vn nmos w='5.4u*k' l=.25u
MP2 z a2 vp vp pmos w='3.6u*k' l=.25u
MN2 n2 a2 vn vn nmos w='5.4u*k' l=.25u
.ends nand3
.subckt nor3 a0 a1 a2 z vp vn k=1
MN0 z a0 vn vn nmos w='1.8u*k' l=.25u
MP0 z a0 p1 vp pmos w='10.8u*k' l=.25u
MN1 z a1 vn vn nmos w='1.8u*k' l=.25u
MP1 p1 a1 p2 vp pmos w='10.8u*k' l=.25u
MN2 z a2 vn vn nmos w='1.8u*k' l=.25u
MP2 p2 a2 vp vp pmos w='10.8u*k' l=.25u
.ends nor3
.subckt nand4 a0 a1 a2 a3 z vp vn k=1
MP0 z a0 vp vp pmos w='3.6u*k' l=.25u
MN0 z a0 n1 vn nmos w='7.2u*k' l=.25u
MP1 z a1 vp vp pmos w='3.6u*k' l=.25u
MN1 n1 a1 n2 vn nmos w='7.2u*k' l=.25u
MP2 z a2 vp vp pmos w='3.6u*k' l=.25u
MN2 n2 a2 n3 vn nmos w='7.2u*k' l=.25u
MP3 z a3 vp vp pmos w='3.6u*k' l=.25u
MN3 n3 a3 vn vn nmos w='7.2u*k' l=.25u
.ends nand4
.subckt nor4 a0 a1 a2 a3 z vp vn k=1
MN0 z a0 vn vn nmos w='1.8u*k' l=.25u
MP0 z a0 p1 vp pmos w='14.4u*k' l=.25u
MN1 z a1 vn vn nmos w='1.8u*k' l=.25u
MP1 p1 a1 p2 vp pmos w='14.4u*k' l=.25u
MN2 z a2 vn vn nmos w='1.8u*k' l=.25u
MP2 p2 a2 p3 vp pmos w='14.4u*k' l=.25u
MN3 z a3 vn vn nmos w='1.8u*k' l=.25u
MP3 p3 a3 vp vp pmos w='14.4u*k' l=.25u
.ends nor4
VN vn 0 1
VR vr 0 1
XnI0 a0 nb0 vn 0 inv
XnI1 a1 nb1 vn 0 inv
XnA0n nb0 nb1 nA0b vn 0 nand2 k=1
XnA0i nA0b n0 vn 0 inv k=1
Cn0 n0 0 'cl'
XnA1n a0 nb1 nA1b vn 0 nand2 k=1
XnA1i nA1b n1 vn 0 inv k=1
Cn1 n1 0 'cl'
XnA2n nb0 a1 nA2b vn 0 nand2 k=1
XnA2i nA2b n2 vn 0 inv k=1
Cn2 n2 0 'cl'
XnA3n a0 a1 nA3b vn 0 nand2 k=1
XnA3i nA3b n3 vn 0 inv k=1
Cn3 n3 0 'cl'
XrI0 a0 rb0 vr 0 inv
XrI1 a1 rb1 vr 0 inv
XrN0 a0 a1 r0 vr 0 nor2
Cr0 r0 0 'cl'
XrN1 rb0 a1 r1 vr 0 nor2
Cr1 r1 0 'cl'
XrN2 a0 rb1 r2 vr 0 nor2
Cr2 r2 0 'cl'
XrN3 rb0 rb1 r3 vr 0 nor2
Cr3 r3 0 'cl'
Va0 a0 0 pwl(0 0 2e-09 0 2.02e-09 1 4e-09 1 4.02e-09 0 6e-09 0 6.02e-09 1 8e-09 1 8.02e-09 0 1e-08 0 1.002e-08 1 1.2e-08 1 1.202e-08 0 1.4e-08 0 1.402e-08 1 1.6e-08 1 1.602e-08 0)
Va1 a1 0 pwl(0 0 2e-09 0 2.02e-09 0 4e-09 0 4.02e-09 1 6e-09 1 6.02e-09 1 8e-09 1 8.02e-09 0 1e-08 0 1.002e-08 0 1.2e-08 0 1.202e-08 1 1.4e-08 1 1.402e-08 1 1.6e-08 1 1.602e-08 0)

.tran 1p 18n 0 1p
.print tran v(a0) v(a1) v(n0) v(n1) v(n2) v(n3) v(r0) v(r1)
+ v(r2) v(r3)
.measure tran rise_n trig v(a0) val=.5 rise=1 targ v(n1) val=.5 rise=1
.measure tran fall_n trig v(a0) val=.5 fall=1 targ v(n1) val=.5 fall=1
.measure tran power_n avg par('-i(VN)') from=2n to=18n
.measure tran rise_r trig v(a0) val=.5 rise=1 targ v(r1) val=.5 rise=1
.measure tran fall_r trig v(a0) val=.5 fall=1 targ v(r1) val=.5 fall=1
.measure tran power_r avg par('-i(VR)') from=2n to=18n


.alter load_50f
.temp 27
.param cl=10f
.param cl=50f

.alter load_100f
.temp 27
.param cl=10f
.param cl=100f

.alter load_500f
.temp 27
.param cl=10f
.param cl=500f

.end
