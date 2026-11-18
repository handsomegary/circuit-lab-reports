DIC Lab 28: Two cascaded full and reduced-stage DFFs
* Handout physical PDF pages 118; rewritten from experiment requirements.
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
VIN d 0 pulse(0 1 5n .2n .2n 9.8n 20n)
XF1 d f1 clk fm1 fx1 fz1 vdd 0 tfull
XF2 f1 f2 clk fm2 fx2 fz2 vdd 0 tfull
XS1 d s1 clk sm1 sz1 vdd 0 tshort
XS2 s1 s2 clk sm2 sz2 vdd 0 tshort
CF1 f1 0 5f
CF2 f2 0 5f
CS1 s1 0 5f
CS2 s2 0 5f
.measure tran f1_2 find v(f1) at=26n
.measure tran f1_3 find v(f1) at=36n
.measure tran f1_4 find v(f1) at=46n
.measure tran f1_5 find v(f1) at=56n
.measure tran f1_6 find v(f1) at=66n
.measure tran f1_7 find v(f1) at=76n
.measure tran f2_2 find v(f2) at=26n
.measure tran f2_3 find v(f2) at=36n
.measure tran f2_4 find v(f2) at=46n
.measure tran f2_5 find v(f2) at=56n
.measure tran f2_6 find v(f2) at=66n
.measure tran f2_7 find v(f2) at=76n
.measure tran s1_2 find v(s1) at=26n
.measure tran s1_3 find v(s1) at=36n
.measure tran s1_4 find v(s1) at=46n
.measure tran s1_5 find v(s1) at=56n
.measure tran s1_6 find v(s1) at=66n
.measure tran s1_7 find v(s1) at=76n
.measure tran s2_2 find v(s2) at=26n
.measure tran s2_3 find v(s2) at=36n
.measure tran s2_4 find v(s2) at=46n
.measure tran s2_5 find v(s2) at=56n
.measure tran s2_6 find v(s2) at=66n
.measure tran s2_7 find v(s2) at=76n

.tran 2p 80n
.print tran v(clk) v(d) v(fm1) v(fx1) v(fz1) v(f1) v(fm2) v(f2) v(sm1) v(sz1) v(s1) v(sm2) v(s2)

.alter case_1
.param SLEW=1n
.end
