* DIC Lab 22: MUX data path delay versus output load
* Handout PDF pages 89-90. 1 V teaching adaptation.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Select=00 data A0 path; timing is not worst-case select delay.
* 10 fF is the primary comparison. Wider TG incur input/select capacitance and area costs.
* Unbuffered tree depends on data source drive; supply-only power is not total input energy.
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
Vs0 s0 0 0
Vs1 s1 0 0
Va0 a0 0 pulse(0 1 1n 20p 20p 4n 10n)
Va1 a1 0 0
Va2 a2 0 0
Va3 a3 0 0

.tran 1p 22n 0 1p
.print tran v(a0) v(og) v(oc) v(of)
.measure tran rise_g trig v(a0) val=.5 rise=1 targ v(og) val=.5 rise=1
.measure tran fall_g trig v(a0) val=.5 fall=1 targ v(og) val=.5 fall=1
.measure tran rise_c trig v(a0) val=.5 rise=1 targ v(oc) val=.5 rise=1
.measure tran fall_c trig v(a0) val=.5 fall=1 targ v(oc) val=.5 fall=1
.measure tran rise_f trig v(a0) val=.5 rise=1 targ v(of) val=.5 rise=1
.measure tran fall_f trig v(a0) val=.5 fall=1 targ v(of) val=.5 fall=1
.measure tran power_g avg par('-i(Vg)') from=2n to=22n
.measure tran data_power_g avg par('-v(a0)*i(VDg0)-v(a1)*i(VDg1)-v(a2)*i(VDg2)-v(a3)*i(VDg3)') from=2n to=22n
.measure tran combined_power_g avg par('-i(Vg)-v(a0)*i(VDg0)-v(a1)*i(VDg1)-v(a2)*i(VDg2)-v(a3)*i(VDg3)') from=2n to=22n
.measure tran power_c avg par('-i(Vc)') from=2n to=22n
.measure tran data_power_c avg par('-v(a0)*i(VDc0)-v(a1)*i(VDc1)-v(a2)*i(VDc2)-v(a3)*i(VDc3)') from=2n to=22n
.measure tran combined_power_c avg par('-i(Vc)-v(a0)*i(VDc0)-v(a1)*i(VDc1)-v(a2)*i(VDc2)-v(a3)*i(VDc3)') from=2n to=22n
.measure tran power_f avg par('-i(Vf)') from=2n to=22n
.measure tran data_power_f avg par('-v(a0)*i(VDf0)-v(a1)*i(VDf1)-v(a2)*i(VDf2)-v(a3)*i(VDf3)') from=2n to=22n
.measure tran combined_power_f avg par('-i(Vf)-v(a0)*i(VDf0)-v(a1)*i(VDf1)-v(a2)*i(VDf2)-v(a3)*i(VDf3)') from=2n to=22n


.alter load_1f
.temp 27
.param cl=10f
.param cl=1f

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
