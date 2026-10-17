DIC Lab 16: Six four-switch chains with optional midpoint inverter
* Handout physical PDF pages 67-72; rewritten from experiment requirements.
* 1 V is a teaching condition, not a certified process voltage rating.
* Original handout voltage/results are reference conditions, not new results.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=6 accurate warnlimit=100 measdgt=8 numdgt=8 ingold=2
.param VDDVAL=1
.temp 25

.subckt inv a y vp vn
MP y a vp vp pmos w=1.8u l=.25u
MN y a vn vn nmos w=.6u l=.25u
.ends
.subckt weak a y vp vn
MP y a vp vp pmos w=.3u l=1u
MN y a vn vn nmos w=.3u l=3u
.ends
.subckt tg a b en eb vp vn
MN b en a vn nmos w=.6u l=.25u
MP b eb a vp pmos w=.6u l=.25u
.ends
.subckt dff d ck cb q x y z vp vn
XT1 d x cb ck vp vn tg
XI1 x y vp vn inv
XT3 y z ck cb vp vn tg
XI3 z q vp vn inv
.ends
.subckt sdff d ck cb q x y z vp vn
XT1 d x cb ck vp vn tg
XI1 x y vp vn inv
XI2 y fb1 vp vn inv
XT2 fb1 x ck cb vp vn tg
XT3 y z ck cb vp vn tg
XI3 z q vp vn inv
XI4 q fb2 vp vn inv
XT4 fb2 z cb ck vp vn tg
.ends
.subckt kdff d ck cb q x y z vp vn
XT1 d x cb ck vp vn tg
XI1 x y vp vn inv
XK1 y x vp vn weak
XT3 y z ck cb vp vn tg
XI3 z q vp vn inv
XK2 q z vp vn weak
.ends
.subckt rdff d ck cb rst q x y z vp vn
XT1 d x cb ck vp vn tg
XI1 x y vp vn inv
XI2 y fb1 vp vn inv
XT2 fb1 x ck cb vp vn tg
XT3 y z ck cb vp vn tg
MP1 pr rst vp vp pmos w=3.6u l=.25u
MP2 q z pr vp pmos w=3.6u l=.25u
MN1 q z vn vn nmos w=.6u l=.25u
MN2 q rst vn vn nmos w=.6u l=.25u
XI4 q fb2 vp vn inv
XT4 fb2 z cb ck vp vn tg
.ends
.subckt c2 a y cp cn vp vn
MP1 p a vp vp pmos w=1.8u l=.25u
MP2 y cp p vp pmos w=1.8u l=.25u
MN1 y cn n vn nmos w=.6u l=.25u
MN2 n a vn vn nmos w=.6u l=.25u
.ends
.subckt ndyn a y ck vp vn
MP y ck vp vp pmos w=1.8u l=.25u
MN1 y a x vn nmos w=.6u l=.25u
MN2 x vp f vn nmos w=.6u l=.25u
MN3 f ck vn vn nmos w=.6u l=.25u
.ends
.subckt pdyn a y cb vp vn
MP1 p cb vp vp pmos w=1.8u l=.25u
MP2 y a p vp pmos w=1.8u l=.25u
MN y cb vn vn nmos w=.6u l=.25u
.ends
.subckt nclock a y ck vp vn
MP y a vp vp pmos w=1.8u l=.25u
MN1 y ck n vn nmos w=.6u l=.25u
MN2 n a vn vn nmos w=.6u l=.25u
.ends
.subckt pclock a y ck vp vn
MP1 p a vp vp pmos w=1.8u l=.25u
MP2 y ck p vp pmos w=1.8u l=.25u
MN y a vn vn nmos w=.6u l=.25u
.ends
.subckt nlatch a y ck x vp vn
MP x ck vp vp pmos w=1.8u l=.25u
MN1 x a n vn nmos w=.6u l=.25u
MN2 n ck vn vn nmos w=.6u l=.25u
XO x y ck vp vn nclock
.ends
.subckt platch a y ck x vp vn
MP1 p ck vp vp pmos w=1.8u l=.25u
MP2 x a p vp pmos w=1.8u l=.25u
MN x ck vn vn nmos w=.6u l=.25u
XO x y ck vp vn pclock
.ends
.subckt tfull a q ck m x z vp vn
XM a m ck x vp vn platch
XS m q ck z vp vn nlatch
.ends
.subckt tshort a q ck m z vp vn
XM a m ck vp vn pclock
XS m q ck z vp vn nlatch
.ends
VDD vdd 0 'VDDVAL'
VIN in 0 pulse(0 'VDDVAL' 2n .2n .2n 19.8n 40n)
X1i in c1a vdd 0 inv
M1p1 c1x1 0 c1a vdd pmos w=1.8u l=.25u
M1p2 c1x2 0 c1x1 vdd pmos w=1.8u l=.25u
M1p3 c1x3 0 c1x2 vdd pmos w=1.8u l=.25u
M1p4 c1x4 0 c1x3 vdd pmos w=1.8u l=.25u
X1o c1x4 out1 vdd 0 inv
C1 out1 0 5f
.measure tran highslot1 find v(out1) at=15n
.measure tran lowslot1 find v(out1) at=35n
X2i in c2a vdd 0 inv
M2p1 c2x1 0 c2a vdd pmos w=1.8u l=.25u
M2p2 c2x2 0 c2x1 vdd pmos w=1.8u l=.25u
X2m c2x2 c2mid vdd 0 inv
M2p3 c2x3 0 c2mid vdd pmos w=1.8u l=.25u
M2p4 c2x4 0 c2x3 vdd pmos w=1.8u l=.25u
X2o c2x4 out2 vdd 0 inv
C2 out2 0 5f
.measure tran highslot2 find v(out2) at=15n
.measure tran lowslot2 find v(out2) at=35n
X3i in c3a vdd 0 inv
M3n1 c3x1 vdd c3a 0 nmos w=.6u l=.25u
M3n2 c3x2 vdd c3x1 0 nmos w=.6u l=.25u
M3n3 c3x3 vdd c3x2 0 nmos w=.6u l=.25u
M3n4 c3x4 vdd c3x3 0 nmos w=.6u l=.25u
X3o c3x4 out3 vdd 0 inv
C3 out3 0 5f
.measure tran highslot3 find v(out3) at=15n
.measure tran lowslot3 find v(out3) at=35n
X4i in c4a vdd 0 inv
M4n1 c4x1 vdd c4a 0 nmos w=.6u l=.25u
M4n2 c4x2 vdd c4x1 0 nmos w=.6u l=.25u
X4m c4x2 c4mid vdd 0 inv
M4n3 c4x3 vdd c4mid 0 nmos w=.6u l=.25u
M4n4 c4x4 vdd c4x3 0 nmos w=.6u l=.25u
X4o c4x4 out4 vdd 0 inv
C4 out4 0 5f
.measure tran highslot4 find v(out4) at=15n
.measure tran lowslot4 find v(out4) at=35n
X5i in c5a vdd 0 inv
M5n1 c5x1 vdd c5a 0 nmos w=.6u l=.25u
M5p1 c5x1 0 c5a vdd pmos w=.6u l=.25u
M5n2 c5x2 vdd c5x1 0 nmos w=.6u l=.25u
M5p2 c5x2 0 c5x1 vdd pmos w=.6u l=.25u
M5n3 c5x3 vdd c5x2 0 nmos w=.6u l=.25u
M5p3 c5x3 0 c5x2 vdd pmos w=.6u l=.25u
M5n4 c5x4 vdd c5x3 0 nmos w=.6u l=.25u
M5p4 c5x4 0 c5x3 vdd pmos w=.6u l=.25u
X5o c5x4 out5 vdd 0 inv
C5 out5 0 5f
.measure tran highslot5 find v(out5) at=15n
.measure tran lowslot5 find v(out5) at=35n
X6i in c6a vdd 0 inv
M6n1 c6x1 vdd c6a 0 nmos w=.6u l=.25u
M6p1 c6x1 0 c6a vdd pmos w=.6u l=.6u
M6n2 c6x2 vdd c6x1 0 nmos w=.6u l=.25u
M6p2 c6x2 0 c6x1 vdd pmos w=.6u l=.6u
X6m c6x2 c6mid vdd 0 inv
M6n3 c6x3 vdd c6mid 0 nmos w=.6u l=.25u
M6p3 c6x3 0 c6mid vdd pmos w=.6u l=.25u
M6n4 c6x4 vdd c6x3 0 nmos w=.6u l=.25u
M6p4 c6x4 0 c6x3 vdd pmos w=.6u l=.25u
X6o c6x4 out6 vdd 0 inv
C6 out6 0 5f
.measure tran highslot6 find v(out6) at=15n
.measure tran lowslot6 find v(out6) at=35n

.tran 10p 80n
.print tran v(in) v(c1a) v(c1x1) v(c1x2) v(c1x3) v(c1x4) v(out1) v(c2a) v(c2x1) v(c2x2) v(c2mid) v(c2x3) v(c2x4) v(out2) v(c3a) v(c3x1) v(c3x2) v(c3x3) v(c3x4) v(out3) v(c4a) v(c4x1) v(c4x2) v(c4mid) v(c4x3) v(c4x4) v(out4) v(c5a) v(c5x1) v(c5x2) v(c5x3) v(c5x4) v(out5) v(c6a) v(c6x1) v(c6x2) v(c6mid) v(c6x3) v(c6x4) v(out6)


.end
