* AIC Lab 4: Input common-mode range with device checks
* Handout PDF pages 42.
* Supply: 1 V teaching adaptation; not a verified device rating.
* Model library is supplied separately by the user.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Each alter has a separate .op. ICMR is extracted from all relevant MOS |VDS| >= |VDSAT|.
* All three topologies use the same 0.5 uA reference for this explicit comparison.
* This is not the 50 uA basic-amplifier operating point of deck 01.
.param iref=.5u scale=1 cmval=0
VDD vdd 0 1
VSS vss 0 0
VCM cm 0 'cmval'
VBIAS bias 0 .6
IREb vdd bbn 'iref'
MbREF bbn bbn vss vss nmos w=85u l=.3u
MbTAIL btail bbn vss vss nmos w=870u l=.3u
Mb1 bleft cm btail vss nmos w='425u*scale' l='.3u*scale'
Mb2 bout cm btail vss nmos w='425u*scale' l='.3u*scale'
Mb3 bleft bleft vdd vdd pmos w='1350u*scale' l='.3u*scale'
Mb4 bout bleft vdd vdd pmos w='1350u*scale' l='.3u*scale'
CLb bout 0 10p
IREc vdd cbn 'iref'
McREF cbn cbn vss vss nmos w=85u l=.3u
McTAIL ctail cbn vss vss nmos w=870u l=.3u
Mc1 cleft cm ctail vss nmos w='425u*scale' l='.3u*scale'
Mc2 cout cm ctail vss nmos w='425u*scale' l='.3u*scale'
Mc5 cpb cpb vdd vdd pmos w='1350u*scale' l='.3u*scale'
Mc6 cpr cpb vdd vdd pmos w='1350u*scale' l='.3u*scale'
Mc3 cleft cleft cpb vdd pmos w='1350u*scale' l='.3u*scale'
Mc4 cout cleft cpr vdd pmos w='1350u*scale' l='.3u*scale'
CLc cout 0 10p
IREf vdd fbn 'iref'
MfREF fbn fbn vss vss nmos w=85u l=.3u
MfTAIL ftail fbn vss vss nmos w=870u l=.3u
Mf1 fd1 cm ftail vss nmos w='425u*scale' l='.3u*scale'
Mf2 fd2 cm ftail vss nmos w='425u*scale' l='.3u*scale'
MfC1 fleft bias fd1 vss nmos w='425u*scale' l='.3u*scale'
MfC2 fout bias fd2 vss nmos w='425u*scale' l='.3u*scale'
Mf5 fpb fpb vdd vdd pmos w='1350u*scale' l='.3u*scale'
Mf6 fpr fpb vdd vdd pmos w='1350u*scale' l='.3u*scale'
Mf3 fleft fleft fpb vdd pmos w='1350u*scale' l='.3u*scale'
Mf4 fout fleft fpr vdd pmos w='1350u*scale' l='.3u*scale'
CLf fout 0 10p

.op
.dc VCM 'cmval' 'cmval' .01
.print dc v(bout) v(cout) v(fout) v(btail) v(ctail) v(ftail)
.measure dc common_mode find v(cm) at='cmval' 

.alter common_mode_01
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.05

.alter common_mode_02
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.10

.alter common_mode_03
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.15

.alter common_mode_04
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.20

.alter common_mode_05
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.25

.alter common_mode_06
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.30

.alter common_mode_07
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.35

.alter common_mode_08
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.40

.alter common_mode_09
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.45

.alter common_mode_10
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.50

.alter common_mode_11
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.55

.alter common_mode_12
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.60

.alter common_mode_13
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.65

.alter common_mode_14
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.70

.alter common_mode_15
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.75

.alter common_mode_16
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.80

.alter common_mode_17
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.85

.alter common_mode_18
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.90

.alter common_mode_19
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=0.95

.alter common_mode_20
.temp 27
.param iref=.5u scale=1 cmval=0
.param cmval=1.00

.end
