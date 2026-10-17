DIC Lab 21: Three buffered-clock DFFs with signed clock skew
* Handout physical PDF pages 87; rewritten from experiment requirements.
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
.param PER=10n SLEW=.2n
VCLK clk 0 pulse(0 'VDDVAL' 'PER/4' 'SLEW' 'SLEW' 'PER/2-SLEW' 'PER')
 .param SKEW=0
VSK sk 0 pulse(0 1 'PER/4+SKEW' .2n .2n 'PER/2-.2n' 'PER')
XB1 clk cb12 vdd 0 inv
XB2 cb12 ck12 vdd 0 inv
XB3 sk cb3 vdd 0 inv
XB4 cb3 ck3 vdd 0 inv
VIN d 0 pulse(0 1 'PER/2' 20p 20p 'PER-20p' '2*PER')
X1 d ck12 cb12 q1 x1 y1 z1 vdd 0 dff
X2 q1 ck12 cb12 q2 x2 y2 z2 vdd 0 dff
X3 q2 ck3 cb3 q3 x3 y3 z3 vdd 0 dff
CQ1 q1 0 5f
CQ2 q2 0 5f
CQ3 q3 0 5f
.measure tran q3_3 find v(q3) at='3*PER+.9*PER'
.measure tran q3_4 find v(q3) at='4*PER+.9*PER'
.measure tran q3_5 find v(q3) at='5*PER+.9*PER'
.measure tran q3_6 find v(q3) at='6*PER+.9*PER'
.measure tran q3_7 find v(q3) at='7*PER+.9*PER'
.measure tran q3_8 find v(q3) at='8*PER+.9*PER'
.measure tran q3_9 find v(q3) at='9*PER+.9*PER'

.tran 5p 100n
.print tran v(clk) v(sk) v(ck12) v(ck3) v(d) v(q1) v(q2) v(q3)

.alter case_1
.param SKEW=-.2n
.alter case_2
.param SKEW=-.5n
.alter case_3
.param SKEW=-1n
.alter case_4
.param SKEW=-2n
.alter case_5
.param SKEW=.2n
.alter case_6
.param SKEW=.5n
.alter case_7
.param SKEW=1n
.alter case_8
.param SKEW=2n
.end
