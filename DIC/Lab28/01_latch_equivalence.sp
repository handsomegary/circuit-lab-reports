DIC Lab 28: Full and simplified N/P latches
* Handout physical PDF pages 115-117; rewritten from experiment requirements.
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
.param PER=4n SLEW=.2n
VCLK clk 0 pulse(0 'VDDVAL' 'PER/4' 'SLEW' 'SLEW' 'PER/2-SLEW' 'PER')
ECB cb 0 vol='VDDVAL-v(clk)'
VIN d 0 pulse(0 1 2n .2n .2n 7.8n 16n)
* Fig28.1(a): N dynamic stage plus full clocked inverter.
MPA a clk vdd vdd pmos w=1.8u l=.25u
MNA1 a d na 0 nmos w=.6u l=.25u
MNA2 na clk 0 0 nmos w=.6u l=.25u
XOA a out1 cb clk vdd 0 c2
* Fig28.1(b): P dynamic stage plus full clocked inverter.
MPB1 pb clk vdd vdd pmos w=1.8u l=.25u
MPB2 b d pb vdd pmos w=1.8u l=.25u
MNB b clk 0 0 nmos w=.6u l=.25u
XOB b out2 clk cb vdd 0 c2
* Fig28.1(c,d) remove redundant complementary-clock transistors.
XNC d out3 clk c vdd 0 nlatch
XPD d out4 clk e vdd 0 platch
C1 out1 0 5f
.measure tran q1_2 find v(out1) at=10.5n
.measure tran q1_3 find v(out1) at=14.5n
.measure tran q1_4 find v(out1) at=18.5n
.measure tran q1_5 find v(out1) at=22.5n
.measure tran q1_6 find v(out1) at=26.5n
.measure tran q1_7 find v(out1) at=30.5n
C2 out2 0 5f
.measure tran q2_2 find v(out2) at=10.5n
.measure tran q2_3 find v(out2) at=14.5n
.measure tran q2_4 find v(out2) at=18.5n
.measure tran q2_5 find v(out2) at=22.5n
.measure tran q2_6 find v(out2) at=26.5n
.measure tran q2_7 find v(out2) at=30.5n
C3 out3 0 5f
.measure tran q3_2 find v(out3) at=10.5n
.measure tran q3_3 find v(out3) at=14.5n
.measure tran q3_4 find v(out3) at=18.5n
.measure tran q3_5 find v(out3) at=22.5n
.measure tran q3_6 find v(out3) at=26.5n
.measure tran q3_7 find v(out3) at=30.5n
C4 out4 0 5f
.measure tran q4_2 find v(out4) at=10.5n
.measure tran q4_3 find v(out4) at=14.5n
.measure tran q4_4 find v(out4) at=18.5n
.measure tran q4_5 find v(out4) at=22.5n
.measure tran q4_6 find v(out4) at=26.5n
.measure tran q4_7 find v(out4) at=30.5n

.tran 2p 32n
.print tran v(clk) v(cb) v(d) v(a) v(b) v(c) v(e) v(out1) v(out2) v(out3) v(out4)


.end
