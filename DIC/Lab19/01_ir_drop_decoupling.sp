* DIC Lab 19: Supply resistance and decoupling
* Handout PDF pages 78-80. 1 V teaching adaptation.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Unit inverter Wp/Wn/L=3.6/1.8/0.25 um; stages x30,x60,x180,x540.
* R supply and return are each 1 ohm. 1e-21 F represents no added decoupling.
* Lumped RC study; no layout extraction or package inductance is claimed.
.param cd=1e-21
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
VDD ext 0 1
RP ext vp 1
RN vn 0 1
CD vp vn 'cd'
VIN in 0 pulse(0 1 1n 50p 50p 2n 4n)
X0 in n1 vp vn inv k=30
X1 n1 n2 vp vn inv k=60
X2 n2 n3 vp vn inv k=180
X3 n3 n4 vp vn inv k=540
CL n4 vn 10f

.tran 2p 20n 0 2p
.print tran v(in) v(n4) v(ext) v(vp) v(vn) vrail=par('v(vp)-v(vn)') i(RP) i(RN)
.measure tran rail_min min v(vp,vn) from=4n to=20n
.measure tran rail_max max v(vp,vn) from=4n to=20n
.measure tran supply_min min v(vp) from=4n to=20n
.measure tran ground_max max v(vn) from=4n to=20n
.measure tran rp_peak max i(RP) from=4n to=20n
.measure tran rn_peak max i(RN) from=4n to=20n
.measure tran power avg par('-v(ext)*i(VDD)') from=4n to=20n

.alter decoupling_10p
.temp 27
.param cd=1e-21
.param cd=10p

.alter decoupling_100p
.temp 27
.param cd=1e-21
.param cd=100p

.alter decoupling_1n
.temp 27
.param cd=1e-21
.param cd=1n

.end
