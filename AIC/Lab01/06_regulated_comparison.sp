* AIC Lab 01 - Regulated and complete regulated cascode mirrors
* Handout: AIC Lab.pdf, PDF pages 18-21 (one-based physical pages).
* supplied-model adaptation: 1 V is a teaching assumption, NOT a verified model rating.
* The original 0.35 um / 3.3 V numerical results are NOT supplied-model specifications.
* Device geometry is not blindly scaled to 90 nm.
* Nominal reference is 50 uA; separate 10 uA and 1 uA alters show headroom.
* Ideal current sources do NOT enforce supply compliance. Check every bias node.
.include '../../models/process.lib'
.option post=2 runlvl=5 accurate measdgt=8 numdgt=8 ingold=2
.temp 27
.param VDDVAL=1.0 IREFVAL=50u WUNIT=3u LUNIT=1.4u
.param NGAINMULT=1 PGAINMULT=3
VDD vdd 0 'VDDVAL'
VTEST out 0 0.8 ac 1
* Original regulated cascode p19: an extra current source loads gain device.
IR vdd rr 'IREFVAL'
IB vdd br 'IREFVAL'
MR0 rr rr 0 0 nmos w='WUNIT' l='LUNIT'
MR1 mr rr 0 0 nmos w='WUNIT' l='LUNIT' m=2
MR2 br mr 0 0 nmos w='WUNIT' l='LUNIT'
MR3 dr br mr 0 nmos w='WUNIT' l='LUNIT' m=2
VSR out dr 0
* Complete regulated cascode p20: M4-M6 generate the gain-stage bias.
* PMOS width9u is a documented new sizing starting point, not handout data.
IC vdd rc 'IREFVAL'
MC0 rc rc 0 0 nmos w='WUNIT' l='LUNIT'
MC4 pc rc 0 0 nmos w='WUNIT' l='LUNIT'
MC5 pc pc vdd vdd pmos w='PGAINMULT*WUNIT' l='LUNIT'
MC6 bc pc vdd vdd pmos w='PGAINMULT*WUNIT' l='LUNIT'
MC1 mc rc 0 0 nmos w='WUNIT' l='LUNIT' m=2
MC2 bc mc 0 0 nmos w='NGAINMULT*WUNIT' l='LUNIT'
MC3 dc bc mc 0 nmos w='WUNIT' l='LUNIT' m=2
VSC out dc 0
.op
.dc VTEST 0 'VDDVAL' 0.001
.ac dec 20 1 1meg
.print dc v(out) i(VSR) i(VSC) v(rr) v(br) v(mr)
+ v(rc) v(pc) v(bc) v(mc)
.print ac im(VSR) im(VSC)
.measure dc irout find i(VSR) at=0.8
.measure dc icout find i(VSC) at=0.8
.measure dc vrr find v(rr) at=0.8
.measure dc vbr find v(br) at=0.8
.measure dc vrc find v(rc) at=0.8
.measure dc vbc find v(bc) at=0.8
.measure dc vpc find v(pc) at=0.8
.measure dc isupply find i(VDD) at=0.8
.measure ac gr find im(VSR) at=1
.measure ac rrout param='1/gr'
.measure ac gc find im(VSC) at=1
.measure ac rcout param='1/gc'

.measure ac phase_vsr find ip(VSR) at=1

.measure ac phase_vsc find ip(VSC) at=1
.alter lower_current_10u
.param IREFVAL=10u WUNIT=3u
.alter lower_current_1u
.param IREFVAL=1u WUNIT=3u
.alter resized_50u_w30u
.param IREFVAL=50u WUNIT=30u

.alter complete_bias_resized_50u
.param IREFVAL=50u WUNIT=30u NGAINMULT=4 PGAINMULT=10
.end
