DIC Lab 17: Sampled capture versus clock period
* Handout physical PDF pages 75-77; rewritten from experiment requirements.
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
.param PER=20n SLEW=20p
VCLK clk 0 pulse(0 'VDDVAL' 'PER/4' 'SLEW' 'SLEW' 'PER/2-SLEW' 'PER')
ECB cb 0 vol='VDDVAL-v(clk)'
VIN d 0 pulse(0 1 'PER/2' 'SLEW' 'SLEW' 'PER-SLEW' '2*PER')
Xs d clk cb qs xs ys zs vdd 0 sdff
Cs qs 0 5f
.measure tran qs2 find v(qs) at='2*PER+.49*PER'
.measure tran qs3 find v(qs) at='3*PER+.49*PER'
.measure tran qs4 find v(qs) at='4*PER+.49*PER'
.measure tran qs5 find v(qs) at='5*PER+.49*PER'
.measure tran qs6 find v(qs) at='6*PER+.49*PER'
.measure tran qs7 find v(qs) at='7*PER+.49*PER'
.measure tran qs8 find v(qs) at='8*PER+.49*PER'
.measure tran qs9 find v(qs) at='9*PER+.49*PER'
Xd d clk cb qd xd yd zd vdd 0 dff
Cd qd 0 5f
.measure tran qd2 find v(qd) at='2*PER+.49*PER'
.measure tran qd3 find v(qd) at='3*PER+.49*PER'
.measure tran qd4 find v(qd) at='4*PER+.49*PER'
.measure tran qd5 find v(qd) at='5*PER+.49*PER'
.measure tran qd6 find v(qd) at='6*PER+.49*PER'
.measure tran qd7 find v(qd) at='7*PER+.49*PER'
.measure tran qd8 find v(qd) at='8*PER+.49*PER'
.measure tran qd9 find v(qd) at='9*PER+.49*PER'

.tran 'PER/1000' '10*PER'
.print tran v(clk) v(d) v(qs) v(qd)

.alter case_1
.param PER=10n
.alter case_2
.param PER=5n
.alter case_3
.param PER=2n
.alter case_4
.param PER=1n
.alter case_5
.param PER=.5n
.alter case_6
.param PER=.25n
.alter case_7
.param PER=.1n
.alter case_8
.param PER=1.2n
.alter case_9
.param PER=1.4n
.alter case_10
.param PER=1.6n
.alter case_11
.param PER=1.8n
.end
