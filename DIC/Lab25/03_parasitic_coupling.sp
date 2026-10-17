DIC Lab 25: Gate-position dependence of parasitic coupling
* Handout physical PDF pages 101-102,105-106; rewritten from experiment requirements.
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

.subckt dyn a b ck y x vp vn
MP y ck vp vp pmos w=1.8u l=.25u
MN1 y a x vn nmos w=.6u l=.25u
MN2 x b f vn nmos w=.6u l=.25u
MN3 f ck vn vn nmos w=.6u l=.25u
CY y vn 5f
CX x vn 5f
.ends
.subckt keep a b ck y x out vp vn MODE=0
XD a b ck y x vp vn dyn
XI y out vp vn inv
* MODE0: no keeper; MODE1: weak always-on; MODE2: feedback keeper.
EG kg vn vol='MODE==1 ? 0 : (MODE==2 ? v(out) : v(vp))'
MPK y kg vp vp pmos w=.3u l=2u
.ends
VDD vdd 0 1
VCLK clk 0 pwl(0 0 2n 0 2.2n 1 8n 1)
VA a 0 0
VB b 0 0
VN noise 0 pwl(0 0 4n 0 4.02n 1 8n 1)
XD1 a b clk y1 x1 vdd 0 dyn
XD2 a b clk y2 x2 vdd 0 dyn
* Two static NANDs: dynamic-node input at upper versus lower NMOS.
MP11 o1 y1 vdd vdd pmos w=1.8u l=.25u
MP12 o1 noise vdd vdd pmos w=1.8u l=.25u
MN11 o1 y1 m1 0 nmos w=.6u l=.25u
MN12 m1 noise 0 0 nmos w=.6u l=.25u
MP21 o2 y2 vdd vdd pmos w=1.8u l=.25u
MP22 o2 noise vdd vdd pmos w=1.8u l=.25u
MN21 o2 noise m2 0 nmos w=.6u l=.25u
MN22 m2 y2 0 0 nmos w=.6u l=.25u
CO1 o1 0 5f
CO2 o2 0 5f
.measure tran upper_before find v(y1) at=3.8n
.measure tran upper_after find v(y1) at=6n
.measure tran lower_before find v(y2) at=3.8n
.measure tran lower_after find v(y2) at=6n

.tran 2p 8n
.print tran v(clk) v(noise) v(y1) v(y2) v(m1) v(m2) v(o1) v(o2)


.end
