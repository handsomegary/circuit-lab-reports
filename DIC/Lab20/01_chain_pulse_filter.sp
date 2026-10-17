* DIC Lab 20: Four-inverter timing and narrow pulses
* Handout PDF pages 81,84. 1 V teaching adaptation.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Main case measures 50-percent propagation and 10-90-percent edges in postprocessing.
* Narrow pulses may not cross thresholds; those crossings are reported as not observed.
.param pw=1n
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
VDD vp 0 1
VIN in 0 pulse(0 1 1n 5p 5p 'pw' 4n)
X0 in n1 vp 0 inv
X1 n1 n2 vp 0 inv
X2 n2 n3 vp 0 inv
X3 n3 n4 vp 0 inv
CL n4 0 10f

.tran .5p 8n 0 .5p
.print tran v(in) v(n1) v(n2) v(n3) v(n4)
.measure tran output_peak max v(n4) from=1n to=3n
.measure tran output_low min v(n4) from=1n to=3n

.alter width_100p
.temp 27
.param pw=1n
.param pw=100p

.alter width_50p
.temp 27
.param pw=1n
.param pw=50p

.alter width_20p
.temp 27
.param pw=1n
.param pw=20p

.alter width_10p
.temp 27
.param pw=1n
.param pw=10p

.alter width_5p
.temp 27
.param pw=1n
.param pw=5p

.end
