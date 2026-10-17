DIC Lab 27: Four two-phase circuits with overlap and fixed-input tests
* Handout physical PDF pages 111-114; rewritten from experiment requirements.
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
 .param SKEW=0 DSTATIC=-1
VCB cbraw 0 pulse(1 0 'PER/4+SKEW' SLEW SLEW 'PER/2-SLEW' PER)
VDAT draw 0 pulse(0 1 2n .2n .2n 3.8n 8n)
ED d 0 vol='DSTATIC<0 ? v(draw) : DSTATIC'
XL1 d l1 clk cbraw vdd 0 c2
XI1 l1 a1 vdd 0 inv
XN1 a1 n1 clk vdd 0 ndyn
XL2 d l2 clk cbraw vdd 0 c2
XI2 l2 a2 vdd 0 inv
XN2 a2 n2 clk vdd 0 ndyn
XL3 d l3 clk cbraw vdd 0 c2
XI3 l3 a3 vdd 0 inv
XN3 a3 n3 clk vdd 0 ndyn
XL4 d l4 clk cbraw vdd 0 c2
XI4 l4 a4 vdd 0 inv
XN4 a4 n4 clk vdd 0 ndyn
* (a) odd static inversion between dynamic gate and final latch.
XAI n1 ai vdd 0 inv
XAO ai out1 cbraw clk vdd 0 c2
* (b) alternating N/P dynamic stages before output latch.
XBP n2 bp cbraw vdd 0 pdyn
XBO bp out2 cbraw clk vdd 0 c2
* (c) two successive clocked inverters.
XC1 n3 ci cbraw clk vdd 0 c2
XC2 ci out3 cbraw clk vdd 0 c2
* (d) clocked inverter then a static inverter.
XD1 n4 di cbraw clk vdd 0 c2
XD2 di out4 vdd 0 inv
C1 out1 0 5f
.measure tran q1_2 find v(out1) at=10.6n
.measure tran q1_3 find v(out1) at=14.6n
.measure tran q1_4 find v(out1) at=18.6n
.measure tran q1_5 find v(out1) at=22.6n
.measure tran q1_6 find v(out1) at=26.6n
.measure tran q1_7 find v(out1) at=30.6n
.measure tran min1 min v(out1) from=8n to=32n
.measure tran max1 max v(out1) from=8n to=32n
C2 out2 0 5f
.measure tran q2_2 find v(out2) at=10.6n
.measure tran q2_3 find v(out2) at=14.6n
.measure tran q2_4 find v(out2) at=18.6n
.measure tran q2_5 find v(out2) at=22.6n
.measure tran q2_6 find v(out2) at=26.6n
.measure tran q2_7 find v(out2) at=30.6n
.measure tran min2 min v(out2) from=8n to=32n
.measure tran max2 max v(out2) from=8n to=32n
C3 out3 0 5f
.measure tran q3_2 find v(out3) at=10.6n
.measure tran q3_3 find v(out3) at=14.6n
.measure tran q3_4 find v(out3) at=18.6n
.measure tran q3_5 find v(out3) at=22.6n
.measure tran q3_6 find v(out3) at=26.6n
.measure tran q3_7 find v(out3) at=30.6n
.measure tran min3 min v(out3) from=8n to=32n
.measure tran max3 max v(out3) from=8n to=32n
C4 out4 0 5f
.measure tran q4_2 find v(out4) at=10.6n
.measure tran q4_3 find v(out4) at=14.6n
.measure tran q4_4 find v(out4) at=18.6n
.measure tran q4_5 find v(out4) at=22.6n
.measure tran q4_6 find v(out4) at=26.6n
.measure tran q4_7 find v(out4) at=30.6n
.measure tran min4 min v(out4) from=8n to=32n
.measure tran max4 max v(out4) from=8n to=32n

.tran 2p 32n
.print tran v(clk) v(cbraw) v(d) v(n1) v(n2) v(n3) v(n4) v(bp) v(ci) v(di) v(out1) v(out2) v(out3) v(out4)

.alter case_1
.param SKEW=.5n DSTATIC=-1
.alter case_2
.param SKEW=-.5n DSTATIC=-1
.alter case_3
.param SKEW=0 DSTATIC=0
.alter case_4
.param SKEW=.5n DSTATIC=0
.alter case_5
.param SKEW=-.5n DSTATIC=0
.alter case_6
.param SKEW=0 DSTATIC=1
.alter case_7
.param SKEW=.5n DSTATIC=1
.alter case_8
.param SKEW=-.5n DSTATIC=1
.end
