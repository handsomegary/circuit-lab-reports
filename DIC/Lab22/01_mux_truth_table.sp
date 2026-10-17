* DIC Lab 22: Four-to-one TG and static MUX truth table
* Handout PDF pages 88-90. 1 V teaching adaptation.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* All 64 combinations of four data and two select inputs, 2 ns per code.
* g: lecture TG (26 core MOS); c: four NAND3 plus NAND4 (32).
* f: balanced two-level TG tree, k=8, without output regeneration (12 core MOS).
* Each additionally includes four MOS for local select complements.
* MOS count is not a physical layout-area estimate.
* Zero-volt probes also meter each architecture data-input energy.
* Combined power includes supply and data drivers but not ideal select-source energy.
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
Vg vg 0 1
XgS0 s0 gb0 vg 0 inv
XgS1 s1 gb1 vg 0 inv
Vc vc 0 1
XcS0 s0 cb0 vc 0 inv
XcS1 s1 cb1 vc 0 inv
Vf vf 0 1
XfS0 s0 fb0 vf 0 inv
XfS1 s1 fb1 vf 0 inv
VDg0 g_in0 a0 0
VDg1 g_in1 a1 0
VDg2 g_in2 a2 0
VDg3 g_in3 a3 0
VDc0 c_in0 a0 0
VDc1 c_in1 a1 0
VDc2 c_in2 a2 0
VDc3 c_in3 a3 0
VDf0 f_in0 a0 0
VDf1 f_in1 a1 0
VDf2 f_in2 a2 0
VDf3 f_in3 a3 0
XGI0 g_in0 ga0 vg 0 inv
XGT0a ga0 gn0 gb1 s1 vg 0 tg
XGT0b gn0 gz gb0 s0 vg 0 tg
XCN0 cb1 cb0 c_in0 cn0 vc 0 nand3
XGI1 g_in1 ga1 vg 0 inv
XGT1a ga1 gn1 gb1 s1 vg 0 tg
XGT1b gn1 gz s0 gb0 vg 0 tg
XCN1 cb1 s0 c_in1 cn1 vc 0 nand3
XGI2 g_in2 ga2 vg 0 inv
XGT2a ga2 gn2 s1 gb1 vg 0 tg
XGT2b gn2 gz gb0 s0 vg 0 tg
XCN2 s1 cb0 c_in2 cn2 vc 0 nand3
XGI3 g_in3 ga3 vg 0 inv
XGT3a ga3 gn3 s1 gb1 vg 0 tg
XGT3b gn3 gz s0 gb0 vg 0 tg
XCN3 s1 s0 c_in3 cn3 vc 0 nand3
XGO gz og vg 0 inv
XCO cn0 cn1 cn2 cn3 oc vc 0 nand4
XFT0 f_in0 fn0 fb0 s0 vf 0 tg k=8
XFT1 f_in1 fn0 s0 fb0 vf 0 tg k=8
XFT2 f_in2 fn1 fb0 s0 vf 0 tg k=8
XFT3 f_in3 fn1 s0 fb0 vf 0 tg k=8
XFT4 fn0 of fb1 s1 vf 0 tg k=8
XFT5 fn1 of s1 fb1 vf 0 tg k=8
CLg og 0 'cl'
CLc oc 0 'cl'
CLf of 0 'cl'
Va0 a0 0 pwl(0 0 2e-09 0 2.02e-09 1 4e-09 1 4.02e-09 0 6e-09 0 6.02e-09 1 8e-09 1 8.02e-09 0 1e-08 0 1.002e-08 1 1.2e-08 1 1.202e-08 0 1.4e-08 0 1.402e-08 1 1.6e-08 1 1.602e-08 0 1.8e-08 0 1.802e-08 1 2e-08 1 2.002e-08 0 2.2e-08 0 2.202e-08 1 2.4e-08 1 2.402e-08 0 2.6e-08 0 2.602e-08 1 2.8e-08 1 2.802e-08 0 3e-08 0 3.002e-08 1 3.2e-08 1 3.202e-08 0 3.4e-08 0 3.402e-08 1 3.6e-08 1 3.602e-08 0 3.8e-08 0 3.802e-08 1 4e-08 1 4.002e-08 0 4.2e-08 0 4.202e-08 1 4.4e-08 1 4.402e-08 0 4.6e-08 0 4.602e-08 1 4.8e-08 1 4.802e-08 0 5e-08 0 5.002e-08 1 5.2e-08 1 5.202e-08 0 5.4e-08 0 5.402e-08 1 5.6e-08 1 5.602e-08 0 5.8e-08 0 5.802e-08 1 6e-08 1 6.002e-08 0 6.2e-08 0 6.202e-08 1 6.4e-08 1 6.402e-08 0 6.6e-08 0 6.602e-08 1 6.8e-08 1 6.802e-08 0 7e-08 0 7.002e-08 1 7.2e-08 1 7.202e-08 0 7.4e-08 0 7.402e-08 1 7.6e-08 1 7.602e-08 0 7.8e-08 0 7.802e-08 1 8e-08 1 8.002e-08 0 8.2e-08 0 8.202e-08 1 8.4e-08 1 8.402e-08 0 8.6e-08 0 8.602e-08 1 8.8e-08 1 8.802e-08 0 9e-08 0 9.002e-08 1 9.2e-08 1 9.202e-08 0 9.4e-08 0 9.402e-08 1 9.6e-08 1 9.602e-08 0 9.8e-08 0 9.802e-08 1 1e-07 1 1.0002e-07 0 1.02e-07 0 1.0202e-07 1 1.04e-07 1 1.0402e-07 0 1.06e-07 0 1.0602e-07 1 1.08e-07 1 1.0802e-07 0 1.1e-07 0 1.1002e-07 1 1.12e-07 1 1.1202e-07 0 1.14e-07 0 1.1402e-07 1 1.16e-07 1 1.1602e-07 0 1.18e-07 0 1.1802e-07 1 1.2e-07 1 1.2002e-07 0 1.22e-07 0 1.2202e-07 1 1.24e-07 1 1.2402e-07 0 1.26e-07 0 1.2602e-07 1)
Va1 a1 0 pwl(0 0 2e-09 0 2.02e-09 0 4e-09 0 4.02e-09 1 6e-09 1 6.02e-09 1 8e-09 1 8.02e-09 0 1e-08 0 1.002e-08 0 1.2e-08 0 1.202e-08 1 1.4e-08 1 1.402e-08 1 1.6e-08 1 1.602e-08 0 1.8e-08 0 1.802e-08 0 2e-08 0 2.002e-08 1 2.2e-08 1 2.202e-08 1 2.4e-08 1 2.402e-08 0 2.6e-08 0 2.602e-08 0 2.8e-08 0 2.802e-08 1 3e-08 1 3.002e-08 1 3.2e-08 1 3.202e-08 0 3.4e-08 0 3.402e-08 0 3.6e-08 0 3.602e-08 1 3.8e-08 1 3.802e-08 1 4e-08 1 4.002e-08 0 4.2e-08 0 4.202e-08 0 4.4e-08 0 4.402e-08 1 4.6e-08 1 4.602e-08 1 4.8e-08 1 4.802e-08 0 5e-08 0 5.002e-08 0 5.2e-08 0 5.202e-08 1 5.4e-08 1 5.402e-08 1 5.6e-08 1 5.602e-08 0 5.8e-08 0 5.802e-08 0 6e-08 0 6.002e-08 1 6.2e-08 1 6.202e-08 1 6.4e-08 1 6.402e-08 0 6.6e-08 0 6.602e-08 0 6.8e-08 0 6.802e-08 1 7e-08 1 7.002e-08 1 7.2e-08 1 7.202e-08 0 7.4e-08 0 7.402e-08 0 7.6e-08 0 7.602e-08 1 7.8e-08 1 7.802e-08 1 8e-08 1 8.002e-08 0 8.2e-08 0 8.202e-08 0 8.4e-08 0 8.402e-08 1 8.6e-08 1 8.602e-08 1 8.8e-08 1 8.802e-08 0 9e-08 0 9.002e-08 0 9.2e-08 0 9.202e-08 1 9.4e-08 1 9.402e-08 1 9.6e-08 1 9.602e-08 0 9.8e-08 0 9.802e-08 0 1e-07 0 1.0002e-07 1 1.02e-07 1 1.0202e-07 1 1.04e-07 1 1.0402e-07 0 1.06e-07 0 1.0602e-07 0 1.08e-07 0 1.0802e-07 1 1.1e-07 1 1.1002e-07 1 1.12e-07 1 1.1202e-07 0 1.14e-07 0 1.1402e-07 0 1.16e-07 0 1.1602e-07 1 1.18e-07 1 1.1802e-07 1 1.2e-07 1 1.2002e-07 0 1.22e-07 0 1.2202e-07 0 1.24e-07 0 1.2402e-07 1 1.26e-07 1 1.2602e-07 1)
Va2 a2 0 pwl(0 0 2e-09 0 2.02e-09 0 4e-09 0 4.02e-09 0 6e-09 0 6.02e-09 0 8e-09 0 8.02e-09 1 1e-08 1 1.002e-08 1 1.2e-08 1 1.202e-08 1 1.4e-08 1 1.402e-08 1 1.6e-08 1 1.602e-08 0 1.8e-08 0 1.802e-08 0 2e-08 0 2.002e-08 0 2.2e-08 0 2.202e-08 0 2.4e-08 0 2.402e-08 1 2.6e-08 1 2.602e-08 1 2.8e-08 1 2.802e-08 1 3e-08 1 3.002e-08 1 3.2e-08 1 3.202e-08 0 3.4e-08 0 3.402e-08 0 3.6e-08 0 3.602e-08 0 3.8e-08 0 3.802e-08 0 4e-08 0 4.002e-08 1 4.2e-08 1 4.202e-08 1 4.4e-08 1 4.402e-08 1 4.6e-08 1 4.602e-08 1 4.8e-08 1 4.802e-08 0 5e-08 0 5.002e-08 0 5.2e-08 0 5.202e-08 0 5.4e-08 0 5.402e-08 0 5.6e-08 0 5.602e-08 1 5.8e-08 1 5.802e-08 1 6e-08 1 6.002e-08 1 6.2e-08 1 6.202e-08 1 6.4e-08 1 6.402e-08 0 6.6e-08 0 6.602e-08 0 6.8e-08 0 6.802e-08 0 7e-08 0 7.002e-08 0 7.2e-08 0 7.202e-08 1 7.4e-08 1 7.402e-08 1 7.6e-08 1 7.602e-08 1 7.8e-08 1 7.802e-08 1 8e-08 1 8.002e-08 0 8.2e-08 0 8.202e-08 0 8.4e-08 0 8.402e-08 0 8.6e-08 0 8.602e-08 0 8.8e-08 0 8.802e-08 1 9e-08 1 9.002e-08 1 9.2e-08 1 9.202e-08 1 9.4e-08 1 9.402e-08 1 9.6e-08 1 9.602e-08 0 9.8e-08 0 9.802e-08 0 1e-07 0 1.0002e-07 0 1.02e-07 0 1.0202e-07 0 1.04e-07 0 1.0402e-07 1 1.06e-07 1 1.0602e-07 1 1.08e-07 1 1.0802e-07 1 1.1e-07 1 1.1002e-07 1 1.12e-07 1 1.1202e-07 0 1.14e-07 0 1.1402e-07 0 1.16e-07 0 1.1602e-07 0 1.18e-07 0 1.1802e-07 0 1.2e-07 0 1.2002e-07 1 1.22e-07 1 1.2202e-07 1 1.24e-07 1 1.2402e-07 1 1.26e-07 1 1.2602e-07 1)
Va3 a3 0 pwl(0 0 2e-09 0 2.02e-09 0 4e-09 0 4.02e-09 0 6e-09 0 6.02e-09 0 8e-09 0 8.02e-09 0 1e-08 0 1.002e-08 0 1.2e-08 0 1.202e-08 0 1.4e-08 0 1.402e-08 0 1.6e-08 0 1.602e-08 1 1.8e-08 1 1.802e-08 1 2e-08 1 2.002e-08 1 2.2e-08 1 2.202e-08 1 2.4e-08 1 2.402e-08 1 2.6e-08 1 2.602e-08 1 2.8e-08 1 2.802e-08 1 3e-08 1 3.002e-08 1 3.2e-08 1 3.202e-08 0 3.4e-08 0 3.402e-08 0 3.6e-08 0 3.602e-08 0 3.8e-08 0 3.802e-08 0 4e-08 0 4.002e-08 0 4.2e-08 0 4.202e-08 0 4.4e-08 0 4.402e-08 0 4.6e-08 0 4.602e-08 0 4.8e-08 0 4.802e-08 1 5e-08 1 5.002e-08 1 5.2e-08 1 5.202e-08 1 5.4e-08 1 5.402e-08 1 5.6e-08 1 5.602e-08 1 5.8e-08 1 5.802e-08 1 6e-08 1 6.002e-08 1 6.2e-08 1 6.202e-08 1 6.4e-08 1 6.402e-08 0 6.6e-08 0 6.602e-08 0 6.8e-08 0 6.802e-08 0 7e-08 0 7.002e-08 0 7.2e-08 0 7.202e-08 0 7.4e-08 0 7.402e-08 0 7.6e-08 0 7.602e-08 0 7.8e-08 0 7.802e-08 0 8e-08 0 8.002e-08 1 8.2e-08 1 8.202e-08 1 8.4e-08 1 8.402e-08 1 8.6e-08 1 8.602e-08 1 8.8e-08 1 8.802e-08 1 9e-08 1 9.002e-08 1 9.2e-08 1 9.202e-08 1 9.4e-08 1 9.402e-08 1 9.6e-08 1 9.602e-08 0 9.8e-08 0 9.802e-08 0 1e-07 0 1.0002e-07 0 1.02e-07 0 1.0202e-07 0 1.04e-07 0 1.0402e-07 0 1.06e-07 0 1.0602e-07 0 1.08e-07 0 1.0802e-07 0 1.1e-07 0 1.1002e-07 0 1.12e-07 0 1.1202e-07 1 1.14e-07 1 1.1402e-07 1 1.16e-07 1 1.1602e-07 1 1.18e-07 1 1.1802e-07 1 1.2e-07 1 1.2002e-07 1 1.22e-07 1 1.2202e-07 1 1.24e-07 1 1.2402e-07 1 1.26e-07 1 1.2602e-07 1)
Vs0 s0 0 pwl(0 0 2e-09 0 2.02e-09 0 4e-09 0 4.02e-09 0 6e-09 0 6.02e-09 0 8e-09 0 8.02e-09 0 1e-08 0 1.002e-08 0 1.2e-08 0 1.202e-08 0 1.4e-08 0 1.402e-08 0 1.6e-08 0 1.602e-08 0 1.8e-08 0 1.802e-08 0 2e-08 0 2.002e-08 0 2.2e-08 0 2.202e-08 0 2.4e-08 0 2.402e-08 0 2.6e-08 0 2.602e-08 0 2.8e-08 0 2.802e-08 0 3e-08 0 3.002e-08 0 3.2e-08 0 3.202e-08 1 3.4e-08 1 3.402e-08 1 3.6e-08 1 3.602e-08 1 3.8e-08 1 3.802e-08 1 4e-08 1 4.002e-08 1 4.2e-08 1 4.202e-08 1 4.4e-08 1 4.402e-08 1 4.6e-08 1 4.602e-08 1 4.8e-08 1 4.802e-08 1 5e-08 1 5.002e-08 1 5.2e-08 1 5.202e-08 1 5.4e-08 1 5.402e-08 1 5.6e-08 1 5.602e-08 1 5.8e-08 1 5.802e-08 1 6e-08 1 6.002e-08 1 6.2e-08 1 6.202e-08 1 6.4e-08 1 6.402e-08 0 6.6e-08 0 6.602e-08 0 6.8e-08 0 6.802e-08 0 7e-08 0 7.002e-08 0 7.2e-08 0 7.202e-08 0 7.4e-08 0 7.402e-08 0 7.6e-08 0 7.602e-08 0 7.8e-08 0 7.802e-08 0 8e-08 0 8.002e-08 0 8.2e-08 0 8.202e-08 0 8.4e-08 0 8.402e-08 0 8.6e-08 0 8.602e-08 0 8.8e-08 0 8.802e-08 0 9e-08 0 9.002e-08 0 9.2e-08 0 9.202e-08 0 9.4e-08 0 9.402e-08 0 9.6e-08 0 9.602e-08 1 9.8e-08 1 9.802e-08 1 1e-07 1 1.0002e-07 1 1.02e-07 1 1.0202e-07 1 1.04e-07 1 1.0402e-07 1 1.06e-07 1 1.0602e-07 1 1.08e-07 1 1.0802e-07 1 1.1e-07 1 1.1002e-07 1 1.12e-07 1 1.1202e-07 1 1.14e-07 1 1.1402e-07 1 1.16e-07 1 1.1602e-07 1 1.18e-07 1 1.1802e-07 1 1.2e-07 1 1.2002e-07 1 1.22e-07 1 1.2202e-07 1 1.24e-07 1 1.2402e-07 1 1.26e-07 1 1.2602e-07 1)
Vs1 s1 0 pwl(0 0 2e-09 0 2.02e-09 0 4e-09 0 4.02e-09 0 6e-09 0 6.02e-09 0 8e-09 0 8.02e-09 0 1e-08 0 1.002e-08 0 1.2e-08 0 1.202e-08 0 1.4e-08 0 1.402e-08 0 1.6e-08 0 1.602e-08 0 1.8e-08 0 1.802e-08 0 2e-08 0 2.002e-08 0 2.2e-08 0 2.202e-08 0 2.4e-08 0 2.402e-08 0 2.6e-08 0 2.602e-08 0 2.8e-08 0 2.802e-08 0 3e-08 0 3.002e-08 0 3.2e-08 0 3.202e-08 0 3.4e-08 0 3.402e-08 0 3.6e-08 0 3.602e-08 0 3.8e-08 0 3.802e-08 0 4e-08 0 4.002e-08 0 4.2e-08 0 4.202e-08 0 4.4e-08 0 4.402e-08 0 4.6e-08 0 4.602e-08 0 4.8e-08 0 4.802e-08 0 5e-08 0 5.002e-08 0 5.2e-08 0 5.202e-08 0 5.4e-08 0 5.402e-08 0 5.6e-08 0 5.602e-08 0 5.8e-08 0 5.802e-08 0 6e-08 0 6.002e-08 0 6.2e-08 0 6.202e-08 0 6.4e-08 0 6.402e-08 1 6.6e-08 1 6.602e-08 1 6.8e-08 1 6.802e-08 1 7e-08 1 7.002e-08 1 7.2e-08 1 7.202e-08 1 7.4e-08 1 7.402e-08 1 7.6e-08 1 7.602e-08 1 7.8e-08 1 7.802e-08 1 8e-08 1 8.002e-08 1 8.2e-08 1 8.202e-08 1 8.4e-08 1 8.402e-08 1 8.6e-08 1 8.602e-08 1 8.8e-08 1 8.802e-08 1 9e-08 1 9.002e-08 1 9.2e-08 1 9.202e-08 1 9.4e-08 1 9.402e-08 1 9.6e-08 1 9.602e-08 1 9.8e-08 1 9.802e-08 1 1e-07 1 1.0002e-07 1 1.02e-07 1 1.0202e-07 1 1.04e-07 1 1.0402e-07 1 1.06e-07 1 1.0602e-07 1 1.08e-07 1 1.0802e-07 1 1.1e-07 1 1.1002e-07 1 1.12e-07 1 1.1202e-07 1 1.14e-07 1 1.1402e-07 1 1.16e-07 1 1.1602e-07 1 1.18e-07 1 1.1802e-07 1 1.2e-07 1 1.2002e-07 1 1.22e-07 1 1.2202e-07 1 1.24e-07 1 1.2402e-07 1 1.26e-07 1 1.2602e-07 1)

.tran 5p 128n 0 2p
.print tran v(a0) v(a1) v(a2) v(a3) v(s0) v(s1) v(og) v(oc)
+ v(of)
.measure tran power_g avg par('-i(Vg)') from=0 to=128n
.measure tran data_power_g avg par('-v(a0)*i(VDg0)-v(a1)*i(VDg1)-v(a2)*i(VDg2)-v(a3)*i(VDg3)') from=0 to=128n
.measure tran combined_power_g avg par('-i(Vg)-v(a0)*i(VDg0)-v(a1)*i(VDg1)-v(a2)*i(VDg2)-v(a3)*i(VDg3)') from=0 to=128n
.measure tran power_c avg par('-i(Vc)') from=0 to=128n
.measure tran data_power_c avg par('-v(a0)*i(VDc0)-v(a1)*i(VDc1)-v(a2)*i(VDc2)-v(a3)*i(VDc3)') from=0 to=128n
.measure tran combined_power_c avg par('-i(Vc)-v(a0)*i(VDc0)-v(a1)*i(VDc1)-v(a2)*i(VDc2)-v(a3)*i(VDc3)') from=0 to=128n
.measure tran power_f avg par('-i(Vf)') from=0 to=128n
.measure tran data_power_f avg par('-v(a0)*i(VDf0)-v(a1)*i(VDf1)-v(a2)*i(VDf2)-v(a3)*i(VDf3)') from=0 to=128n
.measure tran combined_power_f avg par('-i(Vf)-v(a0)*i(VDf0)-v(a1)*i(VDf1)-v(a2)*i(VDf2)-v(a3)*i(VDf3)') from=0 to=128n


.end
