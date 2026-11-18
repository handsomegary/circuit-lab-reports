* DIC Lab 23: Hierarchical decoder transition comparison
* Handout PDF pages 93. 1 V teaching adaptation.
* MODEL_SETUP_REQUIRED
.option post=2 runlvl=5 accurate ingold=2 numdgt=8 measdgt=8
.temp 27
* Timing comparison isolates 0-to-1-to-0 path; additional mixed addresses verify dynamic behavior.
* Counts exclude test sources and capacitors; counts do not establish layout area.
.param cl=10f
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
VT vt 0 1
VH vh 0 1
XtI0 a0 tb0 vt 0 inv
XtI1 a1 tb1 vt 0 inv
XtI2 a2 tb2 vt 0 inv
XtI3 a3 tb3 vt 0 inv
XtI4 a4 tb4 vt 0 inv
XtI5 a5 tb5 vt 0 inv
XtI6 a6 tb6 vt 0 inv
XtI7 a7 tb7 vt 0 inv
XtP0_0n tb0 tb1 tb2 tb3 tP0_0b vt 0 nand4 k=2
XtP0_0i tP0_0b tp0_0 vt 0 inv k=2
XtP0_1n a0 tb1 tb2 tb3 tP0_1b vt 0 nand4 k=2
XtP0_1i tP0_1b tp0_1 vt 0 inv k=2
XtP0_2n tb0 a1 tb2 tb3 tP0_2b vt 0 nand4 k=2
XtP0_2i tP0_2b tp0_2 vt 0 inv k=2
XtP0_3n a0 a1 tb2 tb3 tP0_3b vt 0 nand4 k=2
XtP0_3i tP0_3b tp0_3 vt 0 inv k=2
XtP0_4n tb0 tb1 a2 tb3 tP0_4b vt 0 nand4 k=2
XtP0_4i tP0_4b tp0_4 vt 0 inv k=2
XtP0_5n a0 tb1 a2 tb3 tP0_5b vt 0 nand4 k=2
XtP0_5i tP0_5b tp0_5 vt 0 inv k=2
XtP0_6n tb0 a1 a2 tb3 tP0_6b vt 0 nand4 k=2
XtP0_6i tP0_6b tp0_6 vt 0 inv k=2
XtP0_7n a0 a1 a2 tb3 tP0_7b vt 0 nand4 k=2
XtP0_7i tP0_7b tp0_7 vt 0 inv k=2
XtP0_8n tb0 tb1 tb2 a3 tP0_8b vt 0 nand4 k=2
XtP0_8i tP0_8b tp0_8 vt 0 inv k=2
XtP0_9n a0 tb1 tb2 a3 tP0_9b vt 0 nand4 k=2
XtP0_9i tP0_9b tp0_9 vt 0 inv k=2
XtP0_10n tb0 a1 tb2 a3 tP0_10b vt 0 nand4 k=2
XtP0_10i tP0_10b tp0_10 vt 0 inv k=2
XtP0_11n a0 a1 tb2 a3 tP0_11b vt 0 nand4 k=2
XtP0_11i tP0_11b tp0_11 vt 0 inv k=2
XtP0_12n tb0 tb1 a2 a3 tP0_12b vt 0 nand4 k=2
XtP0_12i tP0_12b tp0_12 vt 0 inv k=2
XtP0_13n a0 tb1 a2 a3 tP0_13b vt 0 nand4 k=2
XtP0_13i tP0_13b tp0_13 vt 0 inv k=2
XtP0_14n tb0 a1 a2 a3 tP0_14b vt 0 nand4 k=2
XtP0_14i tP0_14b tp0_14 vt 0 inv k=2
XtP0_15n a0 a1 a2 a3 tP0_15b vt 0 nand4 k=2
XtP0_15i tP0_15b tp0_15 vt 0 inv k=2
XtP1_0n tb4 tb5 tb6 tb7 tP1_0b vt 0 nand4 k=2
XtP1_0i tP1_0b tp1_0 vt 0 inv k=2
XtP1_1n a4 tb5 tb6 tb7 tP1_1b vt 0 nand4 k=2
XtP1_1i tP1_1b tp1_1 vt 0 inv k=2
XtP1_2n tb4 a5 tb6 tb7 tP1_2b vt 0 nand4 k=2
XtP1_2i tP1_2b tp1_2 vt 0 inv k=2
XtP1_3n a4 a5 tb6 tb7 tP1_3b vt 0 nand4 k=2
XtP1_3i tP1_3b tp1_3 vt 0 inv k=2
XtP1_4n tb4 tb5 a6 tb7 tP1_4b vt 0 nand4 k=2
XtP1_4i tP1_4b tp1_4 vt 0 inv k=2
XtP1_5n a4 tb5 a6 tb7 tP1_5b vt 0 nand4 k=2
XtP1_5i tP1_5b tp1_5 vt 0 inv k=2
XtP1_6n tb4 a5 a6 tb7 tP1_6b vt 0 nand4 k=2
XtP1_6i tP1_6b tp1_6 vt 0 inv k=2
XtP1_7n a4 a5 a6 tb7 tP1_7b vt 0 nand4 k=2
XtP1_7i tP1_7b tp1_7 vt 0 inv k=2
XtP1_8n tb4 tb5 tb6 a7 tP1_8b vt 0 nand4 k=2
XtP1_8i tP1_8b tp1_8 vt 0 inv k=2
XtP1_9n a4 tb5 tb6 a7 tP1_9b vt 0 nand4 k=2
XtP1_9i tP1_9b tp1_9 vt 0 inv k=2
XtP1_10n tb4 a5 tb6 a7 tP1_10b vt 0 nand4 k=2
XtP1_10i tP1_10b tp1_10 vt 0 inv k=2
XtP1_11n a4 a5 tb6 a7 tP1_11b vt 0 nand4 k=2
XtP1_11i tP1_11b tp1_11 vt 0 inv k=2
XtP1_12n tb4 tb5 a6 a7 tP1_12b vt 0 nand4 k=2
XtP1_12i tP1_12b tp1_12 vt 0 inv k=2
XtP1_13n a4 tb5 a6 a7 tP1_13b vt 0 nand4 k=2
XtP1_13i tP1_13b tp1_13 vt 0 inv k=2
XtP1_14n tb4 a5 a6 a7 tP1_14b vt 0 nand4 k=2
XtP1_14i tP1_14b tp1_14 vt 0 inv k=2
XtP1_15n a4 a5 a6 a7 tP1_15b vt 0 nand4 k=2
XtP1_15i tP1_15b tp1_15 vt 0 inv k=2
XtF0n tp0_0 tp1_0 tF0b vt 0 nand2 k=1
XtF0i tF0b t0 vt 0 inv k=1
Ct0 t0 0 'cl'
XtF1n tp0_1 tp1_0 tF1b vt 0 nand2 k=1
XtF1i tF1b t1 vt 0 inv k=1
Ct1 t1 0 'cl'
XtF2n tp0_2 tp1_0 tF2b vt 0 nand2 k=1
XtF2i tF2b t2 vt 0 inv k=1
Ct2 t2 0 'cl'
XtF3n tp0_3 tp1_0 tF3b vt 0 nand2 k=1
XtF3i tF3b t3 vt 0 inv k=1
Ct3 t3 0 'cl'
XtF4n tp0_4 tp1_0 tF4b vt 0 nand2 k=1
XtF4i tF4b t4 vt 0 inv k=1
Ct4 t4 0 'cl'
XtF5n tp0_5 tp1_0 tF5b vt 0 nand2 k=1
XtF5i tF5b t5 vt 0 inv k=1
Ct5 t5 0 'cl'
XtF6n tp0_6 tp1_0 tF6b vt 0 nand2 k=1
XtF6i tF6b t6 vt 0 inv k=1
Ct6 t6 0 'cl'
XtF7n tp0_7 tp1_0 tF7b vt 0 nand2 k=1
XtF7i tF7b t7 vt 0 inv k=1
Ct7 t7 0 'cl'
XtF8n tp0_8 tp1_0 tF8b vt 0 nand2 k=1
XtF8i tF8b t8 vt 0 inv k=1
Ct8 t8 0 'cl'
XtF9n tp0_9 tp1_0 tF9b vt 0 nand2 k=1
XtF9i tF9b t9 vt 0 inv k=1
Ct9 t9 0 'cl'
XtF10n tp0_10 tp1_0 tF10b vt 0 nand2 k=1
XtF10i tF10b t10 vt 0 inv k=1
Ct10 t10 0 'cl'
XtF11n tp0_11 tp1_0 tF11b vt 0 nand2 k=1
XtF11i tF11b t11 vt 0 inv k=1
Ct11 t11 0 'cl'
XtF12n tp0_12 tp1_0 tF12b vt 0 nand2 k=1
XtF12i tF12b t12 vt 0 inv k=1
Ct12 t12 0 'cl'
XtF13n tp0_13 tp1_0 tF13b vt 0 nand2 k=1
XtF13i tF13b t13 vt 0 inv k=1
Ct13 t13 0 'cl'
XtF14n tp0_14 tp1_0 tF14b vt 0 nand2 k=1
XtF14i tF14b t14 vt 0 inv k=1
Ct14 t14 0 'cl'
XtF15n tp0_15 tp1_0 tF15b vt 0 nand2 k=1
XtF15i tF15b t15 vt 0 inv k=1
Ct15 t15 0 'cl'
XtF16n tp0_0 tp1_1 tF16b vt 0 nand2 k=1
XtF16i tF16b t16 vt 0 inv k=1
Ct16 t16 0 'cl'
XtF17n tp0_1 tp1_1 tF17b vt 0 nand2 k=1
XtF17i tF17b t17 vt 0 inv k=1
Ct17 t17 0 'cl'
XtF18n tp0_2 tp1_1 tF18b vt 0 nand2 k=1
XtF18i tF18b t18 vt 0 inv k=1
Ct18 t18 0 'cl'
XtF19n tp0_3 tp1_1 tF19b vt 0 nand2 k=1
XtF19i tF19b t19 vt 0 inv k=1
Ct19 t19 0 'cl'
XtF20n tp0_4 tp1_1 tF20b vt 0 nand2 k=1
XtF20i tF20b t20 vt 0 inv k=1
Ct20 t20 0 'cl'
XtF21n tp0_5 tp1_1 tF21b vt 0 nand2 k=1
XtF21i tF21b t21 vt 0 inv k=1
Ct21 t21 0 'cl'
XtF22n tp0_6 tp1_1 tF22b vt 0 nand2 k=1
XtF22i tF22b t22 vt 0 inv k=1
Ct22 t22 0 'cl'
XtF23n tp0_7 tp1_1 tF23b vt 0 nand2 k=1
XtF23i tF23b t23 vt 0 inv k=1
Ct23 t23 0 'cl'
XtF24n tp0_8 tp1_1 tF24b vt 0 nand2 k=1
XtF24i tF24b t24 vt 0 inv k=1
Ct24 t24 0 'cl'
XtF25n tp0_9 tp1_1 tF25b vt 0 nand2 k=1
XtF25i tF25b t25 vt 0 inv k=1
Ct25 t25 0 'cl'
XtF26n tp0_10 tp1_1 tF26b vt 0 nand2 k=1
XtF26i tF26b t26 vt 0 inv k=1
Ct26 t26 0 'cl'
XtF27n tp0_11 tp1_1 tF27b vt 0 nand2 k=1
XtF27i tF27b t27 vt 0 inv k=1
Ct27 t27 0 'cl'
XtF28n tp0_12 tp1_1 tF28b vt 0 nand2 k=1
XtF28i tF28b t28 vt 0 inv k=1
Ct28 t28 0 'cl'
XtF29n tp0_13 tp1_1 tF29b vt 0 nand2 k=1
XtF29i tF29b t29 vt 0 inv k=1
Ct29 t29 0 'cl'
XtF30n tp0_14 tp1_1 tF30b vt 0 nand2 k=1
XtF30i tF30b t30 vt 0 inv k=1
Ct30 t30 0 'cl'
XtF31n tp0_15 tp1_1 tF31b vt 0 nand2 k=1
XtF31i tF31b t31 vt 0 inv k=1
Ct31 t31 0 'cl'
XtF32n tp0_0 tp1_2 tF32b vt 0 nand2 k=1
XtF32i tF32b t32 vt 0 inv k=1
Ct32 t32 0 'cl'
XtF33n tp0_1 tp1_2 tF33b vt 0 nand2 k=1
XtF33i tF33b t33 vt 0 inv k=1
Ct33 t33 0 'cl'
XtF34n tp0_2 tp1_2 tF34b vt 0 nand2 k=1
XtF34i tF34b t34 vt 0 inv k=1
Ct34 t34 0 'cl'
XtF35n tp0_3 tp1_2 tF35b vt 0 nand2 k=1
XtF35i tF35b t35 vt 0 inv k=1
Ct35 t35 0 'cl'
XtF36n tp0_4 tp1_2 tF36b vt 0 nand2 k=1
XtF36i tF36b t36 vt 0 inv k=1
Ct36 t36 0 'cl'
XtF37n tp0_5 tp1_2 tF37b vt 0 nand2 k=1
XtF37i tF37b t37 vt 0 inv k=1
Ct37 t37 0 'cl'
XtF38n tp0_6 tp1_2 tF38b vt 0 nand2 k=1
XtF38i tF38b t38 vt 0 inv k=1
Ct38 t38 0 'cl'
XtF39n tp0_7 tp1_2 tF39b vt 0 nand2 k=1
XtF39i tF39b t39 vt 0 inv k=1
Ct39 t39 0 'cl'
XtF40n tp0_8 tp1_2 tF40b vt 0 nand2 k=1
XtF40i tF40b t40 vt 0 inv k=1
Ct40 t40 0 'cl'
XtF41n tp0_9 tp1_2 tF41b vt 0 nand2 k=1
XtF41i tF41b t41 vt 0 inv k=1
Ct41 t41 0 'cl'
XtF42n tp0_10 tp1_2 tF42b vt 0 nand2 k=1
XtF42i tF42b t42 vt 0 inv k=1
Ct42 t42 0 'cl'
XtF43n tp0_11 tp1_2 tF43b vt 0 nand2 k=1
XtF43i tF43b t43 vt 0 inv k=1
Ct43 t43 0 'cl'
XtF44n tp0_12 tp1_2 tF44b vt 0 nand2 k=1
XtF44i tF44b t44 vt 0 inv k=1
Ct44 t44 0 'cl'
XtF45n tp0_13 tp1_2 tF45b vt 0 nand2 k=1
XtF45i tF45b t45 vt 0 inv k=1
Ct45 t45 0 'cl'
XtF46n tp0_14 tp1_2 tF46b vt 0 nand2 k=1
XtF46i tF46b t46 vt 0 inv k=1
Ct46 t46 0 'cl'
XtF47n tp0_15 tp1_2 tF47b vt 0 nand2 k=1
XtF47i tF47b t47 vt 0 inv k=1
Ct47 t47 0 'cl'
XtF48n tp0_0 tp1_3 tF48b vt 0 nand2 k=1
XtF48i tF48b t48 vt 0 inv k=1
Ct48 t48 0 'cl'
XtF49n tp0_1 tp1_3 tF49b vt 0 nand2 k=1
XtF49i tF49b t49 vt 0 inv k=1
Ct49 t49 0 'cl'
XtF50n tp0_2 tp1_3 tF50b vt 0 nand2 k=1
XtF50i tF50b t50 vt 0 inv k=1
Ct50 t50 0 'cl'
XtF51n tp0_3 tp1_3 tF51b vt 0 nand2 k=1
XtF51i tF51b t51 vt 0 inv k=1
Ct51 t51 0 'cl'
XtF52n tp0_4 tp1_3 tF52b vt 0 nand2 k=1
XtF52i tF52b t52 vt 0 inv k=1
Ct52 t52 0 'cl'
XtF53n tp0_5 tp1_3 tF53b vt 0 nand2 k=1
XtF53i tF53b t53 vt 0 inv k=1
Ct53 t53 0 'cl'
XtF54n tp0_6 tp1_3 tF54b vt 0 nand2 k=1
XtF54i tF54b t54 vt 0 inv k=1
Ct54 t54 0 'cl'
XtF55n tp0_7 tp1_3 tF55b vt 0 nand2 k=1
XtF55i tF55b t55 vt 0 inv k=1
Ct55 t55 0 'cl'
XtF56n tp0_8 tp1_3 tF56b vt 0 nand2 k=1
XtF56i tF56b t56 vt 0 inv k=1
Ct56 t56 0 'cl'
XtF57n tp0_9 tp1_3 tF57b vt 0 nand2 k=1
XtF57i tF57b t57 vt 0 inv k=1
Ct57 t57 0 'cl'
XtF58n tp0_10 tp1_3 tF58b vt 0 nand2 k=1
XtF58i tF58b t58 vt 0 inv k=1
Ct58 t58 0 'cl'
XtF59n tp0_11 tp1_3 tF59b vt 0 nand2 k=1
XtF59i tF59b t59 vt 0 inv k=1
Ct59 t59 0 'cl'
XtF60n tp0_12 tp1_3 tF60b vt 0 nand2 k=1
XtF60i tF60b t60 vt 0 inv k=1
Ct60 t60 0 'cl'
XtF61n tp0_13 tp1_3 tF61b vt 0 nand2 k=1
XtF61i tF61b t61 vt 0 inv k=1
Ct61 t61 0 'cl'
XtF62n tp0_14 tp1_3 tF62b vt 0 nand2 k=1
XtF62i tF62b t62 vt 0 inv k=1
Ct62 t62 0 'cl'
XtF63n tp0_15 tp1_3 tF63b vt 0 nand2 k=1
XtF63i tF63b t63 vt 0 inv k=1
Ct63 t63 0 'cl'
XtF64n tp0_0 tp1_4 tF64b vt 0 nand2 k=1
XtF64i tF64b t64 vt 0 inv k=1
Ct64 t64 0 'cl'
XtF65n tp0_1 tp1_4 tF65b vt 0 nand2 k=1
XtF65i tF65b t65 vt 0 inv k=1
Ct65 t65 0 'cl'
XtF66n tp0_2 tp1_4 tF66b vt 0 nand2 k=1
XtF66i tF66b t66 vt 0 inv k=1
Ct66 t66 0 'cl'
XtF67n tp0_3 tp1_4 tF67b vt 0 nand2 k=1
XtF67i tF67b t67 vt 0 inv k=1
Ct67 t67 0 'cl'
XtF68n tp0_4 tp1_4 tF68b vt 0 nand2 k=1
XtF68i tF68b t68 vt 0 inv k=1
Ct68 t68 0 'cl'
XtF69n tp0_5 tp1_4 tF69b vt 0 nand2 k=1
XtF69i tF69b t69 vt 0 inv k=1
Ct69 t69 0 'cl'
XtF70n tp0_6 tp1_4 tF70b vt 0 nand2 k=1
XtF70i tF70b t70 vt 0 inv k=1
Ct70 t70 0 'cl'
XtF71n tp0_7 tp1_4 tF71b vt 0 nand2 k=1
XtF71i tF71b t71 vt 0 inv k=1
Ct71 t71 0 'cl'
XtF72n tp0_8 tp1_4 tF72b vt 0 nand2 k=1
XtF72i tF72b t72 vt 0 inv k=1
Ct72 t72 0 'cl'
XtF73n tp0_9 tp1_4 tF73b vt 0 nand2 k=1
XtF73i tF73b t73 vt 0 inv k=1
Ct73 t73 0 'cl'
XtF74n tp0_10 tp1_4 tF74b vt 0 nand2 k=1
XtF74i tF74b t74 vt 0 inv k=1
Ct74 t74 0 'cl'
XtF75n tp0_11 tp1_4 tF75b vt 0 nand2 k=1
XtF75i tF75b t75 vt 0 inv k=1
Ct75 t75 0 'cl'
XtF76n tp0_12 tp1_4 tF76b vt 0 nand2 k=1
XtF76i tF76b t76 vt 0 inv k=1
Ct76 t76 0 'cl'
XtF77n tp0_13 tp1_4 tF77b vt 0 nand2 k=1
XtF77i tF77b t77 vt 0 inv k=1
Ct77 t77 0 'cl'
XtF78n tp0_14 tp1_4 tF78b vt 0 nand2 k=1
XtF78i tF78b t78 vt 0 inv k=1
Ct78 t78 0 'cl'
XtF79n tp0_15 tp1_4 tF79b vt 0 nand2 k=1
XtF79i tF79b t79 vt 0 inv k=1
Ct79 t79 0 'cl'
XtF80n tp0_0 tp1_5 tF80b vt 0 nand2 k=1
XtF80i tF80b t80 vt 0 inv k=1
Ct80 t80 0 'cl'
XtF81n tp0_1 tp1_5 tF81b vt 0 nand2 k=1
XtF81i tF81b t81 vt 0 inv k=1
Ct81 t81 0 'cl'
XtF82n tp0_2 tp1_5 tF82b vt 0 nand2 k=1
XtF82i tF82b t82 vt 0 inv k=1
Ct82 t82 0 'cl'
XtF83n tp0_3 tp1_5 tF83b vt 0 nand2 k=1
XtF83i tF83b t83 vt 0 inv k=1
Ct83 t83 0 'cl'
XtF84n tp0_4 tp1_5 tF84b vt 0 nand2 k=1
XtF84i tF84b t84 vt 0 inv k=1
Ct84 t84 0 'cl'
XtF85n tp0_5 tp1_5 tF85b vt 0 nand2 k=1
XtF85i tF85b t85 vt 0 inv k=1
Ct85 t85 0 'cl'
XtF86n tp0_6 tp1_5 tF86b vt 0 nand2 k=1
XtF86i tF86b t86 vt 0 inv k=1
Ct86 t86 0 'cl'
XtF87n tp0_7 tp1_5 tF87b vt 0 nand2 k=1
XtF87i tF87b t87 vt 0 inv k=1
Ct87 t87 0 'cl'
XtF88n tp0_8 tp1_5 tF88b vt 0 nand2 k=1
XtF88i tF88b t88 vt 0 inv k=1
Ct88 t88 0 'cl'
XtF89n tp0_9 tp1_5 tF89b vt 0 nand2 k=1
XtF89i tF89b t89 vt 0 inv k=1
Ct89 t89 0 'cl'
XtF90n tp0_10 tp1_5 tF90b vt 0 nand2 k=1
XtF90i tF90b t90 vt 0 inv k=1
Ct90 t90 0 'cl'
XtF91n tp0_11 tp1_5 tF91b vt 0 nand2 k=1
XtF91i tF91b t91 vt 0 inv k=1
Ct91 t91 0 'cl'
XtF92n tp0_12 tp1_5 tF92b vt 0 nand2 k=1
XtF92i tF92b t92 vt 0 inv k=1
Ct92 t92 0 'cl'
XtF93n tp0_13 tp1_5 tF93b vt 0 nand2 k=1
XtF93i tF93b t93 vt 0 inv k=1
Ct93 t93 0 'cl'
XtF94n tp0_14 tp1_5 tF94b vt 0 nand2 k=1
XtF94i tF94b t94 vt 0 inv k=1
Ct94 t94 0 'cl'
XtF95n tp0_15 tp1_5 tF95b vt 0 nand2 k=1
XtF95i tF95b t95 vt 0 inv k=1
Ct95 t95 0 'cl'
XtF96n tp0_0 tp1_6 tF96b vt 0 nand2 k=1
XtF96i tF96b t96 vt 0 inv k=1
Ct96 t96 0 'cl'
XtF97n tp0_1 tp1_6 tF97b vt 0 nand2 k=1
XtF97i tF97b t97 vt 0 inv k=1
Ct97 t97 0 'cl'
XtF98n tp0_2 tp1_6 tF98b vt 0 nand2 k=1
XtF98i tF98b t98 vt 0 inv k=1
Ct98 t98 0 'cl'
XtF99n tp0_3 tp1_6 tF99b vt 0 nand2 k=1
XtF99i tF99b t99 vt 0 inv k=1
Ct99 t99 0 'cl'
XtF100n tp0_4 tp1_6 tF100b vt 0 nand2 k=1
XtF100i tF100b t100 vt 0 inv k=1
Ct100 t100 0 'cl'
XtF101n tp0_5 tp1_6 tF101b vt 0 nand2 k=1
XtF101i tF101b t101 vt 0 inv k=1
Ct101 t101 0 'cl'
XtF102n tp0_6 tp1_6 tF102b vt 0 nand2 k=1
XtF102i tF102b t102 vt 0 inv k=1
Ct102 t102 0 'cl'
XtF103n tp0_7 tp1_6 tF103b vt 0 nand2 k=1
XtF103i tF103b t103 vt 0 inv k=1
Ct103 t103 0 'cl'
XtF104n tp0_8 tp1_6 tF104b vt 0 nand2 k=1
XtF104i tF104b t104 vt 0 inv k=1
Ct104 t104 0 'cl'
XtF105n tp0_9 tp1_6 tF105b vt 0 nand2 k=1
XtF105i tF105b t105 vt 0 inv k=1
Ct105 t105 0 'cl'
XtF106n tp0_10 tp1_6 tF106b vt 0 nand2 k=1
XtF106i tF106b t106 vt 0 inv k=1
Ct106 t106 0 'cl'
XtF107n tp0_11 tp1_6 tF107b vt 0 nand2 k=1
XtF107i tF107b t107 vt 0 inv k=1
Ct107 t107 0 'cl'
XtF108n tp0_12 tp1_6 tF108b vt 0 nand2 k=1
XtF108i tF108b t108 vt 0 inv k=1
Ct108 t108 0 'cl'
XtF109n tp0_13 tp1_6 tF109b vt 0 nand2 k=1
XtF109i tF109b t109 vt 0 inv k=1
Ct109 t109 0 'cl'
XtF110n tp0_14 tp1_6 tF110b vt 0 nand2 k=1
XtF110i tF110b t110 vt 0 inv k=1
Ct110 t110 0 'cl'
XtF111n tp0_15 tp1_6 tF111b vt 0 nand2 k=1
XtF111i tF111b t111 vt 0 inv k=1
Ct111 t111 0 'cl'
XtF112n tp0_0 tp1_7 tF112b vt 0 nand2 k=1
XtF112i tF112b t112 vt 0 inv k=1
Ct112 t112 0 'cl'
XtF113n tp0_1 tp1_7 tF113b vt 0 nand2 k=1
XtF113i tF113b t113 vt 0 inv k=1
Ct113 t113 0 'cl'
XtF114n tp0_2 tp1_7 tF114b vt 0 nand2 k=1
XtF114i tF114b t114 vt 0 inv k=1
Ct114 t114 0 'cl'
XtF115n tp0_3 tp1_7 tF115b vt 0 nand2 k=1
XtF115i tF115b t115 vt 0 inv k=1
Ct115 t115 0 'cl'
XtF116n tp0_4 tp1_7 tF116b vt 0 nand2 k=1
XtF116i tF116b t116 vt 0 inv k=1
Ct116 t116 0 'cl'
XtF117n tp0_5 tp1_7 tF117b vt 0 nand2 k=1
XtF117i tF117b t117 vt 0 inv k=1
Ct117 t117 0 'cl'
XtF118n tp0_6 tp1_7 tF118b vt 0 nand2 k=1
XtF118i tF118b t118 vt 0 inv k=1
Ct118 t118 0 'cl'
XtF119n tp0_7 tp1_7 tF119b vt 0 nand2 k=1
XtF119i tF119b t119 vt 0 inv k=1
Ct119 t119 0 'cl'
XtF120n tp0_8 tp1_7 tF120b vt 0 nand2 k=1
XtF120i tF120b t120 vt 0 inv k=1
Ct120 t120 0 'cl'
XtF121n tp0_9 tp1_7 tF121b vt 0 nand2 k=1
XtF121i tF121b t121 vt 0 inv k=1
Ct121 t121 0 'cl'
XtF122n tp0_10 tp1_7 tF122b vt 0 nand2 k=1
XtF122i tF122b t122 vt 0 inv k=1
Ct122 t122 0 'cl'
XtF123n tp0_11 tp1_7 tF123b vt 0 nand2 k=1
XtF123i tF123b t123 vt 0 inv k=1
Ct123 t123 0 'cl'
XtF124n tp0_12 tp1_7 tF124b vt 0 nand2 k=1
XtF124i tF124b t124 vt 0 inv k=1
Ct124 t124 0 'cl'
XtF125n tp0_13 tp1_7 tF125b vt 0 nand2 k=1
XtF125i tF125b t125 vt 0 inv k=1
Ct125 t125 0 'cl'
XtF126n tp0_14 tp1_7 tF126b vt 0 nand2 k=1
XtF126i tF126b t126 vt 0 inv k=1
Ct126 t126 0 'cl'
XtF127n tp0_15 tp1_7 tF127b vt 0 nand2 k=1
XtF127i tF127b t127 vt 0 inv k=1
Ct127 t127 0 'cl'
XtF128n tp0_0 tp1_8 tF128b vt 0 nand2 k=1
XtF128i tF128b t128 vt 0 inv k=1
Ct128 t128 0 'cl'
XtF129n tp0_1 tp1_8 tF129b vt 0 nand2 k=1
XtF129i tF129b t129 vt 0 inv k=1
Ct129 t129 0 'cl'
XtF130n tp0_2 tp1_8 tF130b vt 0 nand2 k=1
XtF130i tF130b t130 vt 0 inv k=1
Ct130 t130 0 'cl'
XtF131n tp0_3 tp1_8 tF131b vt 0 nand2 k=1
XtF131i tF131b t131 vt 0 inv k=1
Ct131 t131 0 'cl'
XtF132n tp0_4 tp1_8 tF132b vt 0 nand2 k=1
XtF132i tF132b t132 vt 0 inv k=1
Ct132 t132 0 'cl'
XtF133n tp0_5 tp1_8 tF133b vt 0 nand2 k=1
XtF133i tF133b t133 vt 0 inv k=1
Ct133 t133 0 'cl'
XtF134n tp0_6 tp1_8 tF134b vt 0 nand2 k=1
XtF134i tF134b t134 vt 0 inv k=1
Ct134 t134 0 'cl'
XtF135n tp0_7 tp1_8 tF135b vt 0 nand2 k=1
XtF135i tF135b t135 vt 0 inv k=1
Ct135 t135 0 'cl'
XtF136n tp0_8 tp1_8 tF136b vt 0 nand2 k=1
XtF136i tF136b t136 vt 0 inv k=1
Ct136 t136 0 'cl'
XtF137n tp0_9 tp1_8 tF137b vt 0 nand2 k=1
XtF137i tF137b t137 vt 0 inv k=1
Ct137 t137 0 'cl'
XtF138n tp0_10 tp1_8 tF138b vt 0 nand2 k=1
XtF138i tF138b t138 vt 0 inv k=1
Ct138 t138 0 'cl'
XtF139n tp0_11 tp1_8 tF139b vt 0 nand2 k=1
XtF139i tF139b t139 vt 0 inv k=1
Ct139 t139 0 'cl'
XtF140n tp0_12 tp1_8 tF140b vt 0 nand2 k=1
XtF140i tF140b t140 vt 0 inv k=1
Ct140 t140 0 'cl'
XtF141n tp0_13 tp1_8 tF141b vt 0 nand2 k=1
XtF141i tF141b t141 vt 0 inv k=1
Ct141 t141 0 'cl'
XtF142n tp0_14 tp1_8 tF142b vt 0 nand2 k=1
XtF142i tF142b t142 vt 0 inv k=1
Ct142 t142 0 'cl'
XtF143n tp0_15 tp1_8 tF143b vt 0 nand2 k=1
XtF143i tF143b t143 vt 0 inv k=1
Ct143 t143 0 'cl'
XtF144n tp0_0 tp1_9 tF144b vt 0 nand2 k=1
XtF144i tF144b t144 vt 0 inv k=1
Ct144 t144 0 'cl'
XtF145n tp0_1 tp1_9 tF145b vt 0 nand2 k=1
XtF145i tF145b t145 vt 0 inv k=1
Ct145 t145 0 'cl'
XtF146n tp0_2 tp1_9 tF146b vt 0 nand2 k=1
XtF146i tF146b t146 vt 0 inv k=1
Ct146 t146 0 'cl'
XtF147n tp0_3 tp1_9 tF147b vt 0 nand2 k=1
XtF147i tF147b t147 vt 0 inv k=1
Ct147 t147 0 'cl'
XtF148n tp0_4 tp1_9 tF148b vt 0 nand2 k=1
XtF148i tF148b t148 vt 0 inv k=1
Ct148 t148 0 'cl'
XtF149n tp0_5 tp1_9 tF149b vt 0 nand2 k=1
XtF149i tF149b t149 vt 0 inv k=1
Ct149 t149 0 'cl'
XtF150n tp0_6 tp1_9 tF150b vt 0 nand2 k=1
XtF150i tF150b t150 vt 0 inv k=1
Ct150 t150 0 'cl'
XtF151n tp0_7 tp1_9 tF151b vt 0 nand2 k=1
XtF151i tF151b t151 vt 0 inv k=1
Ct151 t151 0 'cl'
XtF152n tp0_8 tp1_9 tF152b vt 0 nand2 k=1
XtF152i tF152b t152 vt 0 inv k=1
Ct152 t152 0 'cl'
XtF153n tp0_9 tp1_9 tF153b vt 0 nand2 k=1
XtF153i tF153b t153 vt 0 inv k=1
Ct153 t153 0 'cl'
XtF154n tp0_10 tp1_9 tF154b vt 0 nand2 k=1
XtF154i tF154b t154 vt 0 inv k=1
Ct154 t154 0 'cl'
XtF155n tp0_11 tp1_9 tF155b vt 0 nand2 k=1
XtF155i tF155b t155 vt 0 inv k=1
Ct155 t155 0 'cl'
XtF156n tp0_12 tp1_9 tF156b vt 0 nand2 k=1
XtF156i tF156b t156 vt 0 inv k=1
Ct156 t156 0 'cl'
XtF157n tp0_13 tp1_9 tF157b vt 0 nand2 k=1
XtF157i tF157b t157 vt 0 inv k=1
Ct157 t157 0 'cl'
XtF158n tp0_14 tp1_9 tF158b vt 0 nand2 k=1
XtF158i tF158b t158 vt 0 inv k=1
Ct158 t158 0 'cl'
XtF159n tp0_15 tp1_9 tF159b vt 0 nand2 k=1
XtF159i tF159b t159 vt 0 inv k=1
Ct159 t159 0 'cl'
XtF160n tp0_0 tp1_10 tF160b vt 0 nand2 k=1
XtF160i tF160b t160 vt 0 inv k=1
Ct160 t160 0 'cl'
XtF161n tp0_1 tp1_10 tF161b vt 0 nand2 k=1
XtF161i tF161b t161 vt 0 inv k=1
Ct161 t161 0 'cl'
XtF162n tp0_2 tp1_10 tF162b vt 0 nand2 k=1
XtF162i tF162b t162 vt 0 inv k=1
Ct162 t162 0 'cl'
XtF163n tp0_3 tp1_10 tF163b vt 0 nand2 k=1
XtF163i tF163b t163 vt 0 inv k=1
Ct163 t163 0 'cl'
XtF164n tp0_4 tp1_10 tF164b vt 0 nand2 k=1
XtF164i tF164b t164 vt 0 inv k=1
Ct164 t164 0 'cl'
XtF165n tp0_5 tp1_10 tF165b vt 0 nand2 k=1
XtF165i tF165b t165 vt 0 inv k=1
Ct165 t165 0 'cl'
XtF166n tp0_6 tp1_10 tF166b vt 0 nand2 k=1
XtF166i tF166b t166 vt 0 inv k=1
Ct166 t166 0 'cl'
XtF167n tp0_7 tp1_10 tF167b vt 0 nand2 k=1
XtF167i tF167b t167 vt 0 inv k=1
Ct167 t167 0 'cl'
XtF168n tp0_8 tp1_10 tF168b vt 0 nand2 k=1
XtF168i tF168b t168 vt 0 inv k=1
Ct168 t168 0 'cl'
XtF169n tp0_9 tp1_10 tF169b vt 0 nand2 k=1
XtF169i tF169b t169 vt 0 inv k=1
Ct169 t169 0 'cl'
XtF170n tp0_10 tp1_10 tF170b vt 0 nand2 k=1
XtF170i tF170b t170 vt 0 inv k=1
Ct170 t170 0 'cl'
XtF171n tp0_11 tp1_10 tF171b vt 0 nand2 k=1
XtF171i tF171b t171 vt 0 inv k=1
Ct171 t171 0 'cl'
XtF172n tp0_12 tp1_10 tF172b vt 0 nand2 k=1
XtF172i tF172b t172 vt 0 inv k=1
Ct172 t172 0 'cl'
XtF173n tp0_13 tp1_10 tF173b vt 0 nand2 k=1
XtF173i tF173b t173 vt 0 inv k=1
Ct173 t173 0 'cl'
XtF174n tp0_14 tp1_10 tF174b vt 0 nand2 k=1
XtF174i tF174b t174 vt 0 inv k=1
Ct174 t174 0 'cl'
XtF175n tp0_15 tp1_10 tF175b vt 0 nand2 k=1
XtF175i tF175b t175 vt 0 inv k=1
Ct175 t175 0 'cl'
XtF176n tp0_0 tp1_11 tF176b vt 0 nand2 k=1
XtF176i tF176b t176 vt 0 inv k=1
Ct176 t176 0 'cl'
XtF177n tp0_1 tp1_11 tF177b vt 0 nand2 k=1
XtF177i tF177b t177 vt 0 inv k=1
Ct177 t177 0 'cl'
XtF178n tp0_2 tp1_11 tF178b vt 0 nand2 k=1
XtF178i tF178b t178 vt 0 inv k=1
Ct178 t178 0 'cl'
XtF179n tp0_3 tp1_11 tF179b vt 0 nand2 k=1
XtF179i tF179b t179 vt 0 inv k=1
Ct179 t179 0 'cl'
XtF180n tp0_4 tp1_11 tF180b vt 0 nand2 k=1
XtF180i tF180b t180 vt 0 inv k=1
Ct180 t180 0 'cl'
XtF181n tp0_5 tp1_11 tF181b vt 0 nand2 k=1
XtF181i tF181b t181 vt 0 inv k=1
Ct181 t181 0 'cl'
XtF182n tp0_6 tp1_11 tF182b vt 0 nand2 k=1
XtF182i tF182b t182 vt 0 inv k=1
Ct182 t182 0 'cl'
XtF183n tp0_7 tp1_11 tF183b vt 0 nand2 k=1
XtF183i tF183b t183 vt 0 inv k=1
Ct183 t183 0 'cl'
XtF184n tp0_8 tp1_11 tF184b vt 0 nand2 k=1
XtF184i tF184b t184 vt 0 inv k=1
Ct184 t184 0 'cl'
XtF185n tp0_9 tp1_11 tF185b vt 0 nand2 k=1
XtF185i tF185b t185 vt 0 inv k=1
Ct185 t185 0 'cl'
XtF186n tp0_10 tp1_11 tF186b vt 0 nand2 k=1
XtF186i tF186b t186 vt 0 inv k=1
Ct186 t186 0 'cl'
XtF187n tp0_11 tp1_11 tF187b vt 0 nand2 k=1
XtF187i tF187b t187 vt 0 inv k=1
Ct187 t187 0 'cl'
XtF188n tp0_12 tp1_11 tF188b vt 0 nand2 k=1
XtF188i tF188b t188 vt 0 inv k=1
Ct188 t188 0 'cl'
XtF189n tp0_13 tp1_11 tF189b vt 0 nand2 k=1
XtF189i tF189b t189 vt 0 inv k=1
Ct189 t189 0 'cl'
XtF190n tp0_14 tp1_11 tF190b vt 0 nand2 k=1
XtF190i tF190b t190 vt 0 inv k=1
Ct190 t190 0 'cl'
XtF191n tp0_15 tp1_11 tF191b vt 0 nand2 k=1
XtF191i tF191b t191 vt 0 inv k=1
Ct191 t191 0 'cl'
XtF192n tp0_0 tp1_12 tF192b vt 0 nand2 k=1
XtF192i tF192b t192 vt 0 inv k=1
Ct192 t192 0 'cl'
XtF193n tp0_1 tp1_12 tF193b vt 0 nand2 k=1
XtF193i tF193b t193 vt 0 inv k=1
Ct193 t193 0 'cl'
XtF194n tp0_2 tp1_12 tF194b vt 0 nand2 k=1
XtF194i tF194b t194 vt 0 inv k=1
Ct194 t194 0 'cl'
XtF195n tp0_3 tp1_12 tF195b vt 0 nand2 k=1
XtF195i tF195b t195 vt 0 inv k=1
Ct195 t195 0 'cl'
XtF196n tp0_4 tp1_12 tF196b vt 0 nand2 k=1
XtF196i tF196b t196 vt 0 inv k=1
Ct196 t196 0 'cl'
XtF197n tp0_5 tp1_12 tF197b vt 0 nand2 k=1
XtF197i tF197b t197 vt 0 inv k=1
Ct197 t197 0 'cl'
XtF198n tp0_6 tp1_12 tF198b vt 0 nand2 k=1
XtF198i tF198b t198 vt 0 inv k=1
Ct198 t198 0 'cl'
XtF199n tp0_7 tp1_12 tF199b vt 0 nand2 k=1
XtF199i tF199b t199 vt 0 inv k=1
Ct199 t199 0 'cl'
XtF200n tp0_8 tp1_12 tF200b vt 0 nand2 k=1
XtF200i tF200b t200 vt 0 inv k=1
Ct200 t200 0 'cl'
XtF201n tp0_9 tp1_12 tF201b vt 0 nand2 k=1
XtF201i tF201b t201 vt 0 inv k=1
Ct201 t201 0 'cl'
XtF202n tp0_10 tp1_12 tF202b vt 0 nand2 k=1
XtF202i tF202b t202 vt 0 inv k=1
Ct202 t202 0 'cl'
XtF203n tp0_11 tp1_12 tF203b vt 0 nand2 k=1
XtF203i tF203b t203 vt 0 inv k=1
Ct203 t203 0 'cl'
XtF204n tp0_12 tp1_12 tF204b vt 0 nand2 k=1
XtF204i tF204b t204 vt 0 inv k=1
Ct204 t204 0 'cl'
XtF205n tp0_13 tp1_12 tF205b vt 0 nand2 k=1
XtF205i tF205b t205 vt 0 inv k=1
Ct205 t205 0 'cl'
XtF206n tp0_14 tp1_12 tF206b vt 0 nand2 k=1
XtF206i tF206b t206 vt 0 inv k=1
Ct206 t206 0 'cl'
XtF207n tp0_15 tp1_12 tF207b vt 0 nand2 k=1
XtF207i tF207b t207 vt 0 inv k=1
Ct207 t207 0 'cl'
XtF208n tp0_0 tp1_13 tF208b vt 0 nand2 k=1
XtF208i tF208b t208 vt 0 inv k=1
Ct208 t208 0 'cl'
XtF209n tp0_1 tp1_13 tF209b vt 0 nand2 k=1
XtF209i tF209b t209 vt 0 inv k=1
Ct209 t209 0 'cl'
XtF210n tp0_2 tp1_13 tF210b vt 0 nand2 k=1
XtF210i tF210b t210 vt 0 inv k=1
Ct210 t210 0 'cl'
XtF211n tp0_3 tp1_13 tF211b vt 0 nand2 k=1
XtF211i tF211b t211 vt 0 inv k=1
Ct211 t211 0 'cl'
XtF212n tp0_4 tp1_13 tF212b vt 0 nand2 k=1
XtF212i tF212b t212 vt 0 inv k=1
Ct212 t212 0 'cl'
XtF213n tp0_5 tp1_13 tF213b vt 0 nand2 k=1
XtF213i tF213b t213 vt 0 inv k=1
Ct213 t213 0 'cl'
XtF214n tp0_6 tp1_13 tF214b vt 0 nand2 k=1
XtF214i tF214b t214 vt 0 inv k=1
Ct214 t214 0 'cl'
XtF215n tp0_7 tp1_13 tF215b vt 0 nand2 k=1
XtF215i tF215b t215 vt 0 inv k=1
Ct215 t215 0 'cl'
XtF216n tp0_8 tp1_13 tF216b vt 0 nand2 k=1
XtF216i tF216b t216 vt 0 inv k=1
Ct216 t216 0 'cl'
XtF217n tp0_9 tp1_13 tF217b vt 0 nand2 k=1
XtF217i tF217b t217 vt 0 inv k=1
Ct217 t217 0 'cl'
XtF218n tp0_10 tp1_13 tF218b vt 0 nand2 k=1
XtF218i tF218b t218 vt 0 inv k=1
Ct218 t218 0 'cl'
XtF219n tp0_11 tp1_13 tF219b vt 0 nand2 k=1
XtF219i tF219b t219 vt 0 inv k=1
Ct219 t219 0 'cl'
XtF220n tp0_12 tp1_13 tF220b vt 0 nand2 k=1
XtF220i tF220b t220 vt 0 inv k=1
Ct220 t220 0 'cl'
XtF221n tp0_13 tp1_13 tF221b vt 0 nand2 k=1
XtF221i tF221b t221 vt 0 inv k=1
Ct221 t221 0 'cl'
XtF222n tp0_14 tp1_13 tF222b vt 0 nand2 k=1
XtF222i tF222b t222 vt 0 inv k=1
Ct222 t222 0 'cl'
XtF223n tp0_15 tp1_13 tF223b vt 0 nand2 k=1
XtF223i tF223b t223 vt 0 inv k=1
Ct223 t223 0 'cl'
XtF224n tp0_0 tp1_14 tF224b vt 0 nand2 k=1
XtF224i tF224b t224 vt 0 inv k=1
Ct224 t224 0 'cl'
XtF225n tp0_1 tp1_14 tF225b vt 0 nand2 k=1
XtF225i tF225b t225 vt 0 inv k=1
Ct225 t225 0 'cl'
XtF226n tp0_2 tp1_14 tF226b vt 0 nand2 k=1
XtF226i tF226b t226 vt 0 inv k=1
Ct226 t226 0 'cl'
XtF227n tp0_3 tp1_14 tF227b vt 0 nand2 k=1
XtF227i tF227b t227 vt 0 inv k=1
Ct227 t227 0 'cl'
XtF228n tp0_4 tp1_14 tF228b vt 0 nand2 k=1
XtF228i tF228b t228 vt 0 inv k=1
Ct228 t228 0 'cl'
XtF229n tp0_5 tp1_14 tF229b vt 0 nand2 k=1
XtF229i tF229b t229 vt 0 inv k=1
Ct229 t229 0 'cl'
XtF230n tp0_6 tp1_14 tF230b vt 0 nand2 k=1
XtF230i tF230b t230 vt 0 inv k=1
Ct230 t230 0 'cl'
XtF231n tp0_7 tp1_14 tF231b vt 0 nand2 k=1
XtF231i tF231b t231 vt 0 inv k=1
Ct231 t231 0 'cl'
XtF232n tp0_8 tp1_14 tF232b vt 0 nand2 k=1
XtF232i tF232b t232 vt 0 inv k=1
Ct232 t232 0 'cl'
XtF233n tp0_9 tp1_14 tF233b vt 0 nand2 k=1
XtF233i tF233b t233 vt 0 inv k=1
Ct233 t233 0 'cl'
XtF234n tp0_10 tp1_14 tF234b vt 0 nand2 k=1
XtF234i tF234b t234 vt 0 inv k=1
Ct234 t234 0 'cl'
XtF235n tp0_11 tp1_14 tF235b vt 0 nand2 k=1
XtF235i tF235b t235 vt 0 inv k=1
Ct235 t235 0 'cl'
XtF236n tp0_12 tp1_14 tF236b vt 0 nand2 k=1
XtF236i tF236b t236 vt 0 inv k=1
Ct236 t236 0 'cl'
XtF237n tp0_13 tp1_14 tF237b vt 0 nand2 k=1
XtF237i tF237b t237 vt 0 inv k=1
Ct237 t237 0 'cl'
XtF238n tp0_14 tp1_14 tF238b vt 0 nand2 k=1
XtF238i tF238b t238 vt 0 inv k=1
Ct238 t238 0 'cl'
XtF239n tp0_15 tp1_14 tF239b vt 0 nand2 k=1
XtF239i tF239b t239 vt 0 inv k=1
Ct239 t239 0 'cl'
XtF240n tp0_0 tp1_15 tF240b vt 0 nand2 k=1
XtF240i tF240b t240 vt 0 inv k=1
Ct240 t240 0 'cl'
XtF241n tp0_1 tp1_15 tF241b vt 0 nand2 k=1
XtF241i tF241b t241 vt 0 inv k=1
Ct241 t241 0 'cl'
XtF242n tp0_2 tp1_15 tF242b vt 0 nand2 k=1
XtF242i tF242b t242 vt 0 inv k=1
Ct242 t242 0 'cl'
XtF243n tp0_3 tp1_15 tF243b vt 0 nand2 k=1
XtF243i tF243b t243 vt 0 inv k=1
Ct243 t243 0 'cl'
XtF244n tp0_4 tp1_15 tF244b vt 0 nand2 k=1
XtF244i tF244b t244 vt 0 inv k=1
Ct244 t244 0 'cl'
XtF245n tp0_5 tp1_15 tF245b vt 0 nand2 k=1
XtF245i tF245b t245 vt 0 inv k=1
Ct245 t245 0 'cl'
XtF246n tp0_6 tp1_15 tF246b vt 0 nand2 k=1
XtF246i tF246b t246 vt 0 inv k=1
Ct246 t246 0 'cl'
XtF247n tp0_7 tp1_15 tF247b vt 0 nand2 k=1
XtF247i tF247b t247 vt 0 inv k=1
Ct247 t247 0 'cl'
XtF248n tp0_8 tp1_15 tF248b vt 0 nand2 k=1
XtF248i tF248b t248 vt 0 inv k=1
Ct248 t248 0 'cl'
XtF249n tp0_9 tp1_15 tF249b vt 0 nand2 k=1
XtF249i tF249b t249 vt 0 inv k=1
Ct249 t249 0 'cl'
XtF250n tp0_10 tp1_15 tF250b vt 0 nand2 k=1
XtF250i tF250b t250 vt 0 inv k=1
Ct250 t250 0 'cl'
XtF251n tp0_11 tp1_15 tF251b vt 0 nand2 k=1
XtF251i tF251b t251 vt 0 inv k=1
Ct251 t251 0 'cl'
XtF252n tp0_12 tp1_15 tF252b vt 0 nand2 k=1
XtF252i tF252b t252 vt 0 inv k=1
Ct252 t252 0 'cl'
XtF253n tp0_13 tp1_15 tF253b vt 0 nand2 k=1
XtF253i tF253b t253 vt 0 inv k=1
Ct253 t253 0 'cl'
XtF254n tp0_14 tp1_15 tF254b vt 0 nand2 k=1
XtF254i tF254b t254 vt 0 inv k=1
Ct254 t254 0 'cl'
XtF255n tp0_15 tp1_15 tF255b vt 0 nand2 k=1
XtF255i tF255b t255 vt 0 inv k=1
Ct255 t255 0 'cl'
XhI0 a0 hb0 vh 0 inv
XhI1 a1 hb1 vh 0 inv
XhI2 a2 hb2 vh 0 inv
XhI3 a3 hb3 vh 0 inv
XhI4 a4 hb4 vh 0 inv
XhI5 a5 hb5 vh 0 inv
XhI6 a6 hb6 vh 0 inv
XhI7 a7 hb7 vh 0 inv
XhG0_0n hb0 hb1 hG0_0b vh 0 nand2 k=1
XhG0_0i hG0_0b hg0_0 vh 0 inv k=1
XhG0_1n a0 hb1 hG0_1b vh 0 nand2 k=1
XhG0_1i hG0_1b hg0_1 vh 0 inv k=1
XhG0_2n hb0 a1 hG0_2b vh 0 nand2 k=1
XhG0_2i hG0_2b hg0_2 vh 0 inv k=1
XhG0_3n a0 a1 hG0_3b vh 0 nand2 k=1
XhG0_3i hG0_3b hg0_3 vh 0 inv k=1
XhG1_0n hb2 hb3 hG1_0b vh 0 nand2 k=1
XhG1_0i hG1_0b hg1_0 vh 0 inv k=1
XhG1_1n a2 hb3 hG1_1b vh 0 nand2 k=1
XhG1_1i hG1_1b hg1_1 vh 0 inv k=1
XhG1_2n hb2 a3 hG1_2b vh 0 nand2 k=1
XhG1_2i hG1_2b hg1_2 vh 0 inv k=1
XhG1_3n a2 a3 hG1_3b vh 0 nand2 k=1
XhG1_3i hG1_3b hg1_3 vh 0 inv k=1
XhG2_0n hb4 hb5 hG2_0b vh 0 nand2 k=1
XhG2_0i hG2_0b hg2_0 vh 0 inv k=1
XhG2_1n a4 hb5 hG2_1b vh 0 nand2 k=1
XhG2_1i hG2_1b hg2_1 vh 0 inv k=1
XhG2_2n hb4 a5 hG2_2b vh 0 nand2 k=1
XhG2_2i hG2_2b hg2_2 vh 0 inv k=1
XhG2_3n a4 a5 hG2_3b vh 0 nand2 k=1
XhG2_3i hG2_3b hg2_3 vh 0 inv k=1
XhG3_0n hb6 hb7 hG3_0b vh 0 nand2 k=1
XhG3_0i hG3_0b hg3_0 vh 0 inv k=1
XhG3_1n a6 hb7 hG3_1b vh 0 nand2 k=1
XhG3_1i hG3_1b hg3_1 vh 0 inv k=1
XhG3_2n hb6 a7 hG3_2b vh 0 nand2 k=1
XhG3_2i hG3_2b hg3_2 vh 0 inv k=1
XhG3_3n a6 a7 hG3_3b vh 0 nand2 k=1
XhG3_3i hG3_3b hg3_3 vh 0 inv k=1
XhP0_0n hg0_0 hg1_0 hP0_0b vh 0 nand2 k=2
XhP0_0i hP0_0b hp0_0 vh 0 inv k=2
XhP0_1n hg0_1 hg1_0 hP0_1b vh 0 nand2 k=2
XhP0_1i hP0_1b hp0_1 vh 0 inv k=2
XhP0_2n hg0_2 hg1_0 hP0_2b vh 0 nand2 k=2
XhP0_2i hP0_2b hp0_2 vh 0 inv k=2
XhP0_3n hg0_3 hg1_0 hP0_3b vh 0 nand2 k=2
XhP0_3i hP0_3b hp0_3 vh 0 inv k=2
XhP0_4n hg0_0 hg1_1 hP0_4b vh 0 nand2 k=2
XhP0_4i hP0_4b hp0_4 vh 0 inv k=2
XhP0_5n hg0_1 hg1_1 hP0_5b vh 0 nand2 k=2
XhP0_5i hP0_5b hp0_5 vh 0 inv k=2
XhP0_6n hg0_2 hg1_1 hP0_6b vh 0 nand2 k=2
XhP0_6i hP0_6b hp0_6 vh 0 inv k=2
XhP0_7n hg0_3 hg1_1 hP0_7b vh 0 nand2 k=2
XhP0_7i hP0_7b hp0_7 vh 0 inv k=2
XhP0_8n hg0_0 hg1_2 hP0_8b vh 0 nand2 k=2
XhP0_8i hP0_8b hp0_8 vh 0 inv k=2
XhP0_9n hg0_1 hg1_2 hP0_9b vh 0 nand2 k=2
XhP0_9i hP0_9b hp0_9 vh 0 inv k=2
XhP0_10n hg0_2 hg1_2 hP0_10b vh 0 nand2 k=2
XhP0_10i hP0_10b hp0_10 vh 0 inv k=2
XhP0_11n hg0_3 hg1_2 hP0_11b vh 0 nand2 k=2
XhP0_11i hP0_11b hp0_11 vh 0 inv k=2
XhP0_12n hg0_0 hg1_3 hP0_12b vh 0 nand2 k=2
XhP0_12i hP0_12b hp0_12 vh 0 inv k=2
XhP0_13n hg0_1 hg1_3 hP0_13b vh 0 nand2 k=2
XhP0_13i hP0_13b hp0_13 vh 0 inv k=2
XhP0_14n hg0_2 hg1_3 hP0_14b vh 0 nand2 k=2
XhP0_14i hP0_14b hp0_14 vh 0 inv k=2
XhP0_15n hg0_3 hg1_3 hP0_15b vh 0 nand2 k=2
XhP0_15i hP0_15b hp0_15 vh 0 inv k=2
XhP1_0n hg2_0 hg3_0 hP1_0b vh 0 nand2 k=2
XhP1_0i hP1_0b hp1_0 vh 0 inv k=2
XhP1_1n hg2_1 hg3_0 hP1_1b vh 0 nand2 k=2
XhP1_1i hP1_1b hp1_1 vh 0 inv k=2
XhP1_2n hg2_2 hg3_0 hP1_2b vh 0 nand2 k=2
XhP1_2i hP1_2b hp1_2 vh 0 inv k=2
XhP1_3n hg2_3 hg3_0 hP1_3b vh 0 nand2 k=2
XhP1_3i hP1_3b hp1_3 vh 0 inv k=2
XhP1_4n hg2_0 hg3_1 hP1_4b vh 0 nand2 k=2
XhP1_4i hP1_4b hp1_4 vh 0 inv k=2
XhP1_5n hg2_1 hg3_1 hP1_5b vh 0 nand2 k=2
XhP1_5i hP1_5b hp1_5 vh 0 inv k=2
XhP1_6n hg2_2 hg3_1 hP1_6b vh 0 nand2 k=2
XhP1_6i hP1_6b hp1_6 vh 0 inv k=2
XhP1_7n hg2_3 hg3_1 hP1_7b vh 0 nand2 k=2
XhP1_7i hP1_7b hp1_7 vh 0 inv k=2
XhP1_8n hg2_0 hg3_2 hP1_8b vh 0 nand2 k=2
XhP1_8i hP1_8b hp1_8 vh 0 inv k=2
XhP1_9n hg2_1 hg3_2 hP1_9b vh 0 nand2 k=2
XhP1_9i hP1_9b hp1_9 vh 0 inv k=2
XhP1_10n hg2_2 hg3_2 hP1_10b vh 0 nand2 k=2
XhP1_10i hP1_10b hp1_10 vh 0 inv k=2
XhP1_11n hg2_3 hg3_2 hP1_11b vh 0 nand2 k=2
XhP1_11i hP1_11b hp1_11 vh 0 inv k=2
XhP1_12n hg2_0 hg3_3 hP1_12b vh 0 nand2 k=2
XhP1_12i hP1_12b hp1_12 vh 0 inv k=2
XhP1_13n hg2_1 hg3_3 hP1_13b vh 0 nand2 k=2
XhP1_13i hP1_13b hp1_13 vh 0 inv k=2
XhP1_14n hg2_2 hg3_3 hP1_14b vh 0 nand2 k=2
XhP1_14i hP1_14b hp1_14 vh 0 inv k=2
XhP1_15n hg2_3 hg3_3 hP1_15b vh 0 nand2 k=2
XhP1_15i hP1_15b hp1_15 vh 0 inv k=2
XhF0n hp0_0 hp1_0 hF0b vh 0 nand2 k=1
XhF0i hF0b h0 vh 0 inv k=1
Ch0 h0 0 'cl'
XhF1n hp0_1 hp1_0 hF1b vh 0 nand2 k=1
XhF1i hF1b h1 vh 0 inv k=1
Ch1 h1 0 'cl'
XhF2n hp0_2 hp1_0 hF2b vh 0 nand2 k=1
XhF2i hF2b h2 vh 0 inv k=1
Ch2 h2 0 'cl'
XhF3n hp0_3 hp1_0 hF3b vh 0 nand2 k=1
XhF3i hF3b h3 vh 0 inv k=1
Ch3 h3 0 'cl'
XhF4n hp0_4 hp1_0 hF4b vh 0 nand2 k=1
XhF4i hF4b h4 vh 0 inv k=1
Ch4 h4 0 'cl'
XhF5n hp0_5 hp1_0 hF5b vh 0 nand2 k=1
XhF5i hF5b h5 vh 0 inv k=1
Ch5 h5 0 'cl'
XhF6n hp0_6 hp1_0 hF6b vh 0 nand2 k=1
XhF6i hF6b h6 vh 0 inv k=1
Ch6 h6 0 'cl'
XhF7n hp0_7 hp1_0 hF7b vh 0 nand2 k=1
XhF7i hF7b h7 vh 0 inv k=1
Ch7 h7 0 'cl'
XhF8n hp0_8 hp1_0 hF8b vh 0 nand2 k=1
XhF8i hF8b h8 vh 0 inv k=1
Ch8 h8 0 'cl'
XhF9n hp0_9 hp1_0 hF9b vh 0 nand2 k=1
XhF9i hF9b h9 vh 0 inv k=1
Ch9 h9 0 'cl'
XhF10n hp0_10 hp1_0 hF10b vh 0 nand2 k=1
XhF10i hF10b h10 vh 0 inv k=1
Ch10 h10 0 'cl'
XhF11n hp0_11 hp1_0 hF11b vh 0 nand2 k=1
XhF11i hF11b h11 vh 0 inv k=1
Ch11 h11 0 'cl'
XhF12n hp0_12 hp1_0 hF12b vh 0 nand2 k=1
XhF12i hF12b h12 vh 0 inv k=1
Ch12 h12 0 'cl'
XhF13n hp0_13 hp1_0 hF13b vh 0 nand2 k=1
XhF13i hF13b h13 vh 0 inv k=1
Ch13 h13 0 'cl'
XhF14n hp0_14 hp1_0 hF14b vh 0 nand2 k=1
XhF14i hF14b h14 vh 0 inv k=1
Ch14 h14 0 'cl'
XhF15n hp0_15 hp1_0 hF15b vh 0 nand2 k=1
XhF15i hF15b h15 vh 0 inv k=1
Ch15 h15 0 'cl'
XhF16n hp0_0 hp1_1 hF16b vh 0 nand2 k=1
XhF16i hF16b h16 vh 0 inv k=1
Ch16 h16 0 'cl'
XhF17n hp0_1 hp1_1 hF17b vh 0 nand2 k=1
XhF17i hF17b h17 vh 0 inv k=1
Ch17 h17 0 'cl'
XhF18n hp0_2 hp1_1 hF18b vh 0 nand2 k=1
XhF18i hF18b h18 vh 0 inv k=1
Ch18 h18 0 'cl'
XhF19n hp0_3 hp1_1 hF19b vh 0 nand2 k=1
XhF19i hF19b h19 vh 0 inv k=1
Ch19 h19 0 'cl'
XhF20n hp0_4 hp1_1 hF20b vh 0 nand2 k=1
XhF20i hF20b h20 vh 0 inv k=1
Ch20 h20 0 'cl'
XhF21n hp0_5 hp1_1 hF21b vh 0 nand2 k=1
XhF21i hF21b h21 vh 0 inv k=1
Ch21 h21 0 'cl'
XhF22n hp0_6 hp1_1 hF22b vh 0 nand2 k=1
XhF22i hF22b h22 vh 0 inv k=1
Ch22 h22 0 'cl'
XhF23n hp0_7 hp1_1 hF23b vh 0 nand2 k=1
XhF23i hF23b h23 vh 0 inv k=1
Ch23 h23 0 'cl'
XhF24n hp0_8 hp1_1 hF24b vh 0 nand2 k=1
XhF24i hF24b h24 vh 0 inv k=1
Ch24 h24 0 'cl'
XhF25n hp0_9 hp1_1 hF25b vh 0 nand2 k=1
XhF25i hF25b h25 vh 0 inv k=1
Ch25 h25 0 'cl'
XhF26n hp0_10 hp1_1 hF26b vh 0 nand2 k=1
XhF26i hF26b h26 vh 0 inv k=1
Ch26 h26 0 'cl'
XhF27n hp0_11 hp1_1 hF27b vh 0 nand2 k=1
XhF27i hF27b h27 vh 0 inv k=1
Ch27 h27 0 'cl'
XhF28n hp0_12 hp1_1 hF28b vh 0 nand2 k=1
XhF28i hF28b h28 vh 0 inv k=1
Ch28 h28 0 'cl'
XhF29n hp0_13 hp1_1 hF29b vh 0 nand2 k=1
XhF29i hF29b h29 vh 0 inv k=1
Ch29 h29 0 'cl'
XhF30n hp0_14 hp1_1 hF30b vh 0 nand2 k=1
XhF30i hF30b h30 vh 0 inv k=1
Ch30 h30 0 'cl'
XhF31n hp0_15 hp1_1 hF31b vh 0 nand2 k=1
XhF31i hF31b h31 vh 0 inv k=1
Ch31 h31 0 'cl'
XhF32n hp0_0 hp1_2 hF32b vh 0 nand2 k=1
XhF32i hF32b h32 vh 0 inv k=1
Ch32 h32 0 'cl'
XhF33n hp0_1 hp1_2 hF33b vh 0 nand2 k=1
XhF33i hF33b h33 vh 0 inv k=1
Ch33 h33 0 'cl'
XhF34n hp0_2 hp1_2 hF34b vh 0 nand2 k=1
XhF34i hF34b h34 vh 0 inv k=1
Ch34 h34 0 'cl'
XhF35n hp0_3 hp1_2 hF35b vh 0 nand2 k=1
XhF35i hF35b h35 vh 0 inv k=1
Ch35 h35 0 'cl'
XhF36n hp0_4 hp1_2 hF36b vh 0 nand2 k=1
XhF36i hF36b h36 vh 0 inv k=1
Ch36 h36 0 'cl'
XhF37n hp0_5 hp1_2 hF37b vh 0 nand2 k=1
XhF37i hF37b h37 vh 0 inv k=1
Ch37 h37 0 'cl'
XhF38n hp0_6 hp1_2 hF38b vh 0 nand2 k=1
XhF38i hF38b h38 vh 0 inv k=1
Ch38 h38 0 'cl'
XhF39n hp0_7 hp1_2 hF39b vh 0 nand2 k=1
XhF39i hF39b h39 vh 0 inv k=1
Ch39 h39 0 'cl'
XhF40n hp0_8 hp1_2 hF40b vh 0 nand2 k=1
XhF40i hF40b h40 vh 0 inv k=1
Ch40 h40 0 'cl'
XhF41n hp0_9 hp1_2 hF41b vh 0 nand2 k=1
XhF41i hF41b h41 vh 0 inv k=1
Ch41 h41 0 'cl'
XhF42n hp0_10 hp1_2 hF42b vh 0 nand2 k=1
XhF42i hF42b h42 vh 0 inv k=1
Ch42 h42 0 'cl'
XhF43n hp0_11 hp1_2 hF43b vh 0 nand2 k=1
XhF43i hF43b h43 vh 0 inv k=1
Ch43 h43 0 'cl'
XhF44n hp0_12 hp1_2 hF44b vh 0 nand2 k=1
XhF44i hF44b h44 vh 0 inv k=1
Ch44 h44 0 'cl'
XhF45n hp0_13 hp1_2 hF45b vh 0 nand2 k=1
XhF45i hF45b h45 vh 0 inv k=1
Ch45 h45 0 'cl'
XhF46n hp0_14 hp1_2 hF46b vh 0 nand2 k=1
XhF46i hF46b h46 vh 0 inv k=1
Ch46 h46 0 'cl'
XhF47n hp0_15 hp1_2 hF47b vh 0 nand2 k=1
XhF47i hF47b h47 vh 0 inv k=1
Ch47 h47 0 'cl'
XhF48n hp0_0 hp1_3 hF48b vh 0 nand2 k=1
XhF48i hF48b h48 vh 0 inv k=1
Ch48 h48 0 'cl'
XhF49n hp0_1 hp1_3 hF49b vh 0 nand2 k=1
XhF49i hF49b h49 vh 0 inv k=1
Ch49 h49 0 'cl'
XhF50n hp0_2 hp1_3 hF50b vh 0 nand2 k=1
XhF50i hF50b h50 vh 0 inv k=1
Ch50 h50 0 'cl'
XhF51n hp0_3 hp1_3 hF51b vh 0 nand2 k=1
XhF51i hF51b h51 vh 0 inv k=1
Ch51 h51 0 'cl'
XhF52n hp0_4 hp1_3 hF52b vh 0 nand2 k=1
XhF52i hF52b h52 vh 0 inv k=1
Ch52 h52 0 'cl'
XhF53n hp0_5 hp1_3 hF53b vh 0 nand2 k=1
XhF53i hF53b h53 vh 0 inv k=1
Ch53 h53 0 'cl'
XhF54n hp0_6 hp1_3 hF54b vh 0 nand2 k=1
XhF54i hF54b h54 vh 0 inv k=1
Ch54 h54 0 'cl'
XhF55n hp0_7 hp1_3 hF55b vh 0 nand2 k=1
XhF55i hF55b h55 vh 0 inv k=1
Ch55 h55 0 'cl'
XhF56n hp0_8 hp1_3 hF56b vh 0 nand2 k=1
XhF56i hF56b h56 vh 0 inv k=1
Ch56 h56 0 'cl'
XhF57n hp0_9 hp1_3 hF57b vh 0 nand2 k=1
XhF57i hF57b h57 vh 0 inv k=1
Ch57 h57 0 'cl'
XhF58n hp0_10 hp1_3 hF58b vh 0 nand2 k=1
XhF58i hF58b h58 vh 0 inv k=1
Ch58 h58 0 'cl'
XhF59n hp0_11 hp1_3 hF59b vh 0 nand2 k=1
XhF59i hF59b h59 vh 0 inv k=1
Ch59 h59 0 'cl'
XhF60n hp0_12 hp1_3 hF60b vh 0 nand2 k=1
XhF60i hF60b h60 vh 0 inv k=1
Ch60 h60 0 'cl'
XhF61n hp0_13 hp1_3 hF61b vh 0 nand2 k=1
XhF61i hF61b h61 vh 0 inv k=1
Ch61 h61 0 'cl'
XhF62n hp0_14 hp1_3 hF62b vh 0 nand2 k=1
XhF62i hF62b h62 vh 0 inv k=1
Ch62 h62 0 'cl'
XhF63n hp0_15 hp1_3 hF63b vh 0 nand2 k=1
XhF63i hF63b h63 vh 0 inv k=1
Ch63 h63 0 'cl'
XhF64n hp0_0 hp1_4 hF64b vh 0 nand2 k=1
XhF64i hF64b h64 vh 0 inv k=1
Ch64 h64 0 'cl'
XhF65n hp0_1 hp1_4 hF65b vh 0 nand2 k=1
XhF65i hF65b h65 vh 0 inv k=1
Ch65 h65 0 'cl'
XhF66n hp0_2 hp1_4 hF66b vh 0 nand2 k=1
XhF66i hF66b h66 vh 0 inv k=1
Ch66 h66 0 'cl'
XhF67n hp0_3 hp1_4 hF67b vh 0 nand2 k=1
XhF67i hF67b h67 vh 0 inv k=1
Ch67 h67 0 'cl'
XhF68n hp0_4 hp1_4 hF68b vh 0 nand2 k=1
XhF68i hF68b h68 vh 0 inv k=1
Ch68 h68 0 'cl'
XhF69n hp0_5 hp1_4 hF69b vh 0 nand2 k=1
XhF69i hF69b h69 vh 0 inv k=1
Ch69 h69 0 'cl'
XhF70n hp0_6 hp1_4 hF70b vh 0 nand2 k=1
XhF70i hF70b h70 vh 0 inv k=1
Ch70 h70 0 'cl'
XhF71n hp0_7 hp1_4 hF71b vh 0 nand2 k=1
XhF71i hF71b h71 vh 0 inv k=1
Ch71 h71 0 'cl'
XhF72n hp0_8 hp1_4 hF72b vh 0 nand2 k=1
XhF72i hF72b h72 vh 0 inv k=1
Ch72 h72 0 'cl'
XhF73n hp0_9 hp1_4 hF73b vh 0 nand2 k=1
XhF73i hF73b h73 vh 0 inv k=1
Ch73 h73 0 'cl'
XhF74n hp0_10 hp1_4 hF74b vh 0 nand2 k=1
XhF74i hF74b h74 vh 0 inv k=1
Ch74 h74 0 'cl'
XhF75n hp0_11 hp1_4 hF75b vh 0 nand2 k=1
XhF75i hF75b h75 vh 0 inv k=1
Ch75 h75 0 'cl'
XhF76n hp0_12 hp1_4 hF76b vh 0 nand2 k=1
XhF76i hF76b h76 vh 0 inv k=1
Ch76 h76 0 'cl'
XhF77n hp0_13 hp1_4 hF77b vh 0 nand2 k=1
XhF77i hF77b h77 vh 0 inv k=1
Ch77 h77 0 'cl'
XhF78n hp0_14 hp1_4 hF78b vh 0 nand2 k=1
XhF78i hF78b h78 vh 0 inv k=1
Ch78 h78 0 'cl'
XhF79n hp0_15 hp1_4 hF79b vh 0 nand2 k=1
XhF79i hF79b h79 vh 0 inv k=1
Ch79 h79 0 'cl'
XhF80n hp0_0 hp1_5 hF80b vh 0 nand2 k=1
XhF80i hF80b h80 vh 0 inv k=1
Ch80 h80 0 'cl'
XhF81n hp0_1 hp1_5 hF81b vh 0 nand2 k=1
XhF81i hF81b h81 vh 0 inv k=1
Ch81 h81 0 'cl'
XhF82n hp0_2 hp1_5 hF82b vh 0 nand2 k=1
XhF82i hF82b h82 vh 0 inv k=1
Ch82 h82 0 'cl'
XhF83n hp0_3 hp1_5 hF83b vh 0 nand2 k=1
XhF83i hF83b h83 vh 0 inv k=1
Ch83 h83 0 'cl'
XhF84n hp0_4 hp1_5 hF84b vh 0 nand2 k=1
XhF84i hF84b h84 vh 0 inv k=1
Ch84 h84 0 'cl'
XhF85n hp0_5 hp1_5 hF85b vh 0 nand2 k=1
XhF85i hF85b h85 vh 0 inv k=1
Ch85 h85 0 'cl'
XhF86n hp0_6 hp1_5 hF86b vh 0 nand2 k=1
XhF86i hF86b h86 vh 0 inv k=1
Ch86 h86 0 'cl'
XhF87n hp0_7 hp1_5 hF87b vh 0 nand2 k=1
XhF87i hF87b h87 vh 0 inv k=1
Ch87 h87 0 'cl'
XhF88n hp0_8 hp1_5 hF88b vh 0 nand2 k=1
XhF88i hF88b h88 vh 0 inv k=1
Ch88 h88 0 'cl'
XhF89n hp0_9 hp1_5 hF89b vh 0 nand2 k=1
XhF89i hF89b h89 vh 0 inv k=1
Ch89 h89 0 'cl'
XhF90n hp0_10 hp1_5 hF90b vh 0 nand2 k=1
XhF90i hF90b h90 vh 0 inv k=1
Ch90 h90 0 'cl'
XhF91n hp0_11 hp1_5 hF91b vh 0 nand2 k=1
XhF91i hF91b h91 vh 0 inv k=1
Ch91 h91 0 'cl'
XhF92n hp0_12 hp1_5 hF92b vh 0 nand2 k=1
XhF92i hF92b h92 vh 0 inv k=1
Ch92 h92 0 'cl'
XhF93n hp0_13 hp1_5 hF93b vh 0 nand2 k=1
XhF93i hF93b h93 vh 0 inv k=1
Ch93 h93 0 'cl'
XhF94n hp0_14 hp1_5 hF94b vh 0 nand2 k=1
XhF94i hF94b h94 vh 0 inv k=1
Ch94 h94 0 'cl'
XhF95n hp0_15 hp1_5 hF95b vh 0 nand2 k=1
XhF95i hF95b h95 vh 0 inv k=1
Ch95 h95 0 'cl'
XhF96n hp0_0 hp1_6 hF96b vh 0 nand2 k=1
XhF96i hF96b h96 vh 0 inv k=1
Ch96 h96 0 'cl'
XhF97n hp0_1 hp1_6 hF97b vh 0 nand2 k=1
XhF97i hF97b h97 vh 0 inv k=1
Ch97 h97 0 'cl'
XhF98n hp0_2 hp1_6 hF98b vh 0 nand2 k=1
XhF98i hF98b h98 vh 0 inv k=1
Ch98 h98 0 'cl'
XhF99n hp0_3 hp1_6 hF99b vh 0 nand2 k=1
XhF99i hF99b h99 vh 0 inv k=1
Ch99 h99 0 'cl'
XhF100n hp0_4 hp1_6 hF100b vh 0 nand2 k=1
XhF100i hF100b h100 vh 0 inv k=1
Ch100 h100 0 'cl'
XhF101n hp0_5 hp1_6 hF101b vh 0 nand2 k=1
XhF101i hF101b h101 vh 0 inv k=1
Ch101 h101 0 'cl'
XhF102n hp0_6 hp1_6 hF102b vh 0 nand2 k=1
XhF102i hF102b h102 vh 0 inv k=1
Ch102 h102 0 'cl'
XhF103n hp0_7 hp1_6 hF103b vh 0 nand2 k=1
XhF103i hF103b h103 vh 0 inv k=1
Ch103 h103 0 'cl'
XhF104n hp0_8 hp1_6 hF104b vh 0 nand2 k=1
XhF104i hF104b h104 vh 0 inv k=1
Ch104 h104 0 'cl'
XhF105n hp0_9 hp1_6 hF105b vh 0 nand2 k=1
XhF105i hF105b h105 vh 0 inv k=1
Ch105 h105 0 'cl'
XhF106n hp0_10 hp1_6 hF106b vh 0 nand2 k=1
XhF106i hF106b h106 vh 0 inv k=1
Ch106 h106 0 'cl'
XhF107n hp0_11 hp1_6 hF107b vh 0 nand2 k=1
XhF107i hF107b h107 vh 0 inv k=1
Ch107 h107 0 'cl'
XhF108n hp0_12 hp1_6 hF108b vh 0 nand2 k=1
XhF108i hF108b h108 vh 0 inv k=1
Ch108 h108 0 'cl'
XhF109n hp0_13 hp1_6 hF109b vh 0 nand2 k=1
XhF109i hF109b h109 vh 0 inv k=1
Ch109 h109 0 'cl'
XhF110n hp0_14 hp1_6 hF110b vh 0 nand2 k=1
XhF110i hF110b h110 vh 0 inv k=1
Ch110 h110 0 'cl'
XhF111n hp0_15 hp1_6 hF111b vh 0 nand2 k=1
XhF111i hF111b h111 vh 0 inv k=1
Ch111 h111 0 'cl'
XhF112n hp0_0 hp1_7 hF112b vh 0 nand2 k=1
XhF112i hF112b h112 vh 0 inv k=1
Ch112 h112 0 'cl'
XhF113n hp0_1 hp1_7 hF113b vh 0 nand2 k=1
XhF113i hF113b h113 vh 0 inv k=1
Ch113 h113 0 'cl'
XhF114n hp0_2 hp1_7 hF114b vh 0 nand2 k=1
XhF114i hF114b h114 vh 0 inv k=1
Ch114 h114 0 'cl'
XhF115n hp0_3 hp1_7 hF115b vh 0 nand2 k=1
XhF115i hF115b h115 vh 0 inv k=1
Ch115 h115 0 'cl'
XhF116n hp0_4 hp1_7 hF116b vh 0 nand2 k=1
XhF116i hF116b h116 vh 0 inv k=1
Ch116 h116 0 'cl'
XhF117n hp0_5 hp1_7 hF117b vh 0 nand2 k=1
XhF117i hF117b h117 vh 0 inv k=1
Ch117 h117 0 'cl'
XhF118n hp0_6 hp1_7 hF118b vh 0 nand2 k=1
XhF118i hF118b h118 vh 0 inv k=1
Ch118 h118 0 'cl'
XhF119n hp0_7 hp1_7 hF119b vh 0 nand2 k=1
XhF119i hF119b h119 vh 0 inv k=1
Ch119 h119 0 'cl'
XhF120n hp0_8 hp1_7 hF120b vh 0 nand2 k=1
XhF120i hF120b h120 vh 0 inv k=1
Ch120 h120 0 'cl'
XhF121n hp0_9 hp1_7 hF121b vh 0 nand2 k=1
XhF121i hF121b h121 vh 0 inv k=1
Ch121 h121 0 'cl'
XhF122n hp0_10 hp1_7 hF122b vh 0 nand2 k=1
XhF122i hF122b h122 vh 0 inv k=1
Ch122 h122 0 'cl'
XhF123n hp0_11 hp1_7 hF123b vh 0 nand2 k=1
XhF123i hF123b h123 vh 0 inv k=1
Ch123 h123 0 'cl'
XhF124n hp0_12 hp1_7 hF124b vh 0 nand2 k=1
XhF124i hF124b h124 vh 0 inv k=1
Ch124 h124 0 'cl'
XhF125n hp0_13 hp1_7 hF125b vh 0 nand2 k=1
XhF125i hF125b h125 vh 0 inv k=1
Ch125 h125 0 'cl'
XhF126n hp0_14 hp1_7 hF126b vh 0 nand2 k=1
XhF126i hF126b h126 vh 0 inv k=1
Ch126 h126 0 'cl'
XhF127n hp0_15 hp1_7 hF127b vh 0 nand2 k=1
XhF127i hF127b h127 vh 0 inv k=1
Ch127 h127 0 'cl'
XhF128n hp0_0 hp1_8 hF128b vh 0 nand2 k=1
XhF128i hF128b h128 vh 0 inv k=1
Ch128 h128 0 'cl'
XhF129n hp0_1 hp1_8 hF129b vh 0 nand2 k=1
XhF129i hF129b h129 vh 0 inv k=1
Ch129 h129 0 'cl'
XhF130n hp0_2 hp1_8 hF130b vh 0 nand2 k=1
XhF130i hF130b h130 vh 0 inv k=1
Ch130 h130 0 'cl'
XhF131n hp0_3 hp1_8 hF131b vh 0 nand2 k=1
XhF131i hF131b h131 vh 0 inv k=1
Ch131 h131 0 'cl'
XhF132n hp0_4 hp1_8 hF132b vh 0 nand2 k=1
XhF132i hF132b h132 vh 0 inv k=1
Ch132 h132 0 'cl'
XhF133n hp0_5 hp1_8 hF133b vh 0 nand2 k=1
XhF133i hF133b h133 vh 0 inv k=1
Ch133 h133 0 'cl'
XhF134n hp0_6 hp1_8 hF134b vh 0 nand2 k=1
XhF134i hF134b h134 vh 0 inv k=1
Ch134 h134 0 'cl'
XhF135n hp0_7 hp1_8 hF135b vh 0 nand2 k=1
XhF135i hF135b h135 vh 0 inv k=1
Ch135 h135 0 'cl'
XhF136n hp0_8 hp1_8 hF136b vh 0 nand2 k=1
XhF136i hF136b h136 vh 0 inv k=1
Ch136 h136 0 'cl'
XhF137n hp0_9 hp1_8 hF137b vh 0 nand2 k=1
XhF137i hF137b h137 vh 0 inv k=1
Ch137 h137 0 'cl'
XhF138n hp0_10 hp1_8 hF138b vh 0 nand2 k=1
XhF138i hF138b h138 vh 0 inv k=1
Ch138 h138 0 'cl'
XhF139n hp0_11 hp1_8 hF139b vh 0 nand2 k=1
XhF139i hF139b h139 vh 0 inv k=1
Ch139 h139 0 'cl'
XhF140n hp0_12 hp1_8 hF140b vh 0 nand2 k=1
XhF140i hF140b h140 vh 0 inv k=1
Ch140 h140 0 'cl'
XhF141n hp0_13 hp1_8 hF141b vh 0 nand2 k=1
XhF141i hF141b h141 vh 0 inv k=1
Ch141 h141 0 'cl'
XhF142n hp0_14 hp1_8 hF142b vh 0 nand2 k=1
XhF142i hF142b h142 vh 0 inv k=1
Ch142 h142 0 'cl'
XhF143n hp0_15 hp1_8 hF143b vh 0 nand2 k=1
XhF143i hF143b h143 vh 0 inv k=1
Ch143 h143 0 'cl'
XhF144n hp0_0 hp1_9 hF144b vh 0 nand2 k=1
XhF144i hF144b h144 vh 0 inv k=1
Ch144 h144 0 'cl'
XhF145n hp0_1 hp1_9 hF145b vh 0 nand2 k=1
XhF145i hF145b h145 vh 0 inv k=1
Ch145 h145 0 'cl'
XhF146n hp0_2 hp1_9 hF146b vh 0 nand2 k=1
XhF146i hF146b h146 vh 0 inv k=1
Ch146 h146 0 'cl'
XhF147n hp0_3 hp1_9 hF147b vh 0 nand2 k=1
XhF147i hF147b h147 vh 0 inv k=1
Ch147 h147 0 'cl'
XhF148n hp0_4 hp1_9 hF148b vh 0 nand2 k=1
XhF148i hF148b h148 vh 0 inv k=1
Ch148 h148 0 'cl'
XhF149n hp0_5 hp1_9 hF149b vh 0 nand2 k=1
XhF149i hF149b h149 vh 0 inv k=1
Ch149 h149 0 'cl'
XhF150n hp0_6 hp1_9 hF150b vh 0 nand2 k=1
XhF150i hF150b h150 vh 0 inv k=1
Ch150 h150 0 'cl'
XhF151n hp0_7 hp1_9 hF151b vh 0 nand2 k=1
XhF151i hF151b h151 vh 0 inv k=1
Ch151 h151 0 'cl'
XhF152n hp0_8 hp1_9 hF152b vh 0 nand2 k=1
XhF152i hF152b h152 vh 0 inv k=1
Ch152 h152 0 'cl'
XhF153n hp0_9 hp1_9 hF153b vh 0 nand2 k=1
XhF153i hF153b h153 vh 0 inv k=1
Ch153 h153 0 'cl'
XhF154n hp0_10 hp1_9 hF154b vh 0 nand2 k=1
XhF154i hF154b h154 vh 0 inv k=1
Ch154 h154 0 'cl'
XhF155n hp0_11 hp1_9 hF155b vh 0 nand2 k=1
XhF155i hF155b h155 vh 0 inv k=1
Ch155 h155 0 'cl'
XhF156n hp0_12 hp1_9 hF156b vh 0 nand2 k=1
XhF156i hF156b h156 vh 0 inv k=1
Ch156 h156 0 'cl'
XhF157n hp0_13 hp1_9 hF157b vh 0 nand2 k=1
XhF157i hF157b h157 vh 0 inv k=1
Ch157 h157 0 'cl'
XhF158n hp0_14 hp1_9 hF158b vh 0 nand2 k=1
XhF158i hF158b h158 vh 0 inv k=1
Ch158 h158 0 'cl'
XhF159n hp0_15 hp1_9 hF159b vh 0 nand2 k=1
XhF159i hF159b h159 vh 0 inv k=1
Ch159 h159 0 'cl'
XhF160n hp0_0 hp1_10 hF160b vh 0 nand2 k=1
XhF160i hF160b h160 vh 0 inv k=1
Ch160 h160 0 'cl'
XhF161n hp0_1 hp1_10 hF161b vh 0 nand2 k=1
XhF161i hF161b h161 vh 0 inv k=1
Ch161 h161 0 'cl'
XhF162n hp0_2 hp1_10 hF162b vh 0 nand2 k=1
XhF162i hF162b h162 vh 0 inv k=1
Ch162 h162 0 'cl'
XhF163n hp0_3 hp1_10 hF163b vh 0 nand2 k=1
XhF163i hF163b h163 vh 0 inv k=1
Ch163 h163 0 'cl'
XhF164n hp0_4 hp1_10 hF164b vh 0 nand2 k=1
XhF164i hF164b h164 vh 0 inv k=1
Ch164 h164 0 'cl'
XhF165n hp0_5 hp1_10 hF165b vh 0 nand2 k=1
XhF165i hF165b h165 vh 0 inv k=1
Ch165 h165 0 'cl'
XhF166n hp0_6 hp1_10 hF166b vh 0 nand2 k=1
XhF166i hF166b h166 vh 0 inv k=1
Ch166 h166 0 'cl'
XhF167n hp0_7 hp1_10 hF167b vh 0 nand2 k=1
XhF167i hF167b h167 vh 0 inv k=1
Ch167 h167 0 'cl'
XhF168n hp0_8 hp1_10 hF168b vh 0 nand2 k=1
XhF168i hF168b h168 vh 0 inv k=1
Ch168 h168 0 'cl'
XhF169n hp0_9 hp1_10 hF169b vh 0 nand2 k=1
XhF169i hF169b h169 vh 0 inv k=1
Ch169 h169 0 'cl'
XhF170n hp0_10 hp1_10 hF170b vh 0 nand2 k=1
XhF170i hF170b h170 vh 0 inv k=1
Ch170 h170 0 'cl'
XhF171n hp0_11 hp1_10 hF171b vh 0 nand2 k=1
XhF171i hF171b h171 vh 0 inv k=1
Ch171 h171 0 'cl'
XhF172n hp0_12 hp1_10 hF172b vh 0 nand2 k=1
XhF172i hF172b h172 vh 0 inv k=1
Ch172 h172 0 'cl'
XhF173n hp0_13 hp1_10 hF173b vh 0 nand2 k=1
XhF173i hF173b h173 vh 0 inv k=1
Ch173 h173 0 'cl'
XhF174n hp0_14 hp1_10 hF174b vh 0 nand2 k=1
XhF174i hF174b h174 vh 0 inv k=1
Ch174 h174 0 'cl'
XhF175n hp0_15 hp1_10 hF175b vh 0 nand2 k=1
XhF175i hF175b h175 vh 0 inv k=1
Ch175 h175 0 'cl'
XhF176n hp0_0 hp1_11 hF176b vh 0 nand2 k=1
XhF176i hF176b h176 vh 0 inv k=1
Ch176 h176 0 'cl'
XhF177n hp0_1 hp1_11 hF177b vh 0 nand2 k=1
XhF177i hF177b h177 vh 0 inv k=1
Ch177 h177 0 'cl'
XhF178n hp0_2 hp1_11 hF178b vh 0 nand2 k=1
XhF178i hF178b h178 vh 0 inv k=1
Ch178 h178 0 'cl'
XhF179n hp0_3 hp1_11 hF179b vh 0 nand2 k=1
XhF179i hF179b h179 vh 0 inv k=1
Ch179 h179 0 'cl'
XhF180n hp0_4 hp1_11 hF180b vh 0 nand2 k=1
XhF180i hF180b h180 vh 0 inv k=1
Ch180 h180 0 'cl'
XhF181n hp0_5 hp1_11 hF181b vh 0 nand2 k=1
XhF181i hF181b h181 vh 0 inv k=1
Ch181 h181 0 'cl'
XhF182n hp0_6 hp1_11 hF182b vh 0 nand2 k=1
XhF182i hF182b h182 vh 0 inv k=1
Ch182 h182 0 'cl'
XhF183n hp0_7 hp1_11 hF183b vh 0 nand2 k=1
XhF183i hF183b h183 vh 0 inv k=1
Ch183 h183 0 'cl'
XhF184n hp0_8 hp1_11 hF184b vh 0 nand2 k=1
XhF184i hF184b h184 vh 0 inv k=1
Ch184 h184 0 'cl'
XhF185n hp0_9 hp1_11 hF185b vh 0 nand2 k=1
XhF185i hF185b h185 vh 0 inv k=1
Ch185 h185 0 'cl'
XhF186n hp0_10 hp1_11 hF186b vh 0 nand2 k=1
XhF186i hF186b h186 vh 0 inv k=1
Ch186 h186 0 'cl'
XhF187n hp0_11 hp1_11 hF187b vh 0 nand2 k=1
XhF187i hF187b h187 vh 0 inv k=1
Ch187 h187 0 'cl'
XhF188n hp0_12 hp1_11 hF188b vh 0 nand2 k=1
XhF188i hF188b h188 vh 0 inv k=1
Ch188 h188 0 'cl'
XhF189n hp0_13 hp1_11 hF189b vh 0 nand2 k=1
XhF189i hF189b h189 vh 0 inv k=1
Ch189 h189 0 'cl'
XhF190n hp0_14 hp1_11 hF190b vh 0 nand2 k=1
XhF190i hF190b h190 vh 0 inv k=1
Ch190 h190 0 'cl'
XhF191n hp0_15 hp1_11 hF191b vh 0 nand2 k=1
XhF191i hF191b h191 vh 0 inv k=1
Ch191 h191 0 'cl'
XhF192n hp0_0 hp1_12 hF192b vh 0 nand2 k=1
XhF192i hF192b h192 vh 0 inv k=1
Ch192 h192 0 'cl'
XhF193n hp0_1 hp1_12 hF193b vh 0 nand2 k=1
XhF193i hF193b h193 vh 0 inv k=1
Ch193 h193 0 'cl'
XhF194n hp0_2 hp1_12 hF194b vh 0 nand2 k=1
XhF194i hF194b h194 vh 0 inv k=1
Ch194 h194 0 'cl'
XhF195n hp0_3 hp1_12 hF195b vh 0 nand2 k=1
XhF195i hF195b h195 vh 0 inv k=1
Ch195 h195 0 'cl'
XhF196n hp0_4 hp1_12 hF196b vh 0 nand2 k=1
XhF196i hF196b h196 vh 0 inv k=1
Ch196 h196 0 'cl'
XhF197n hp0_5 hp1_12 hF197b vh 0 nand2 k=1
XhF197i hF197b h197 vh 0 inv k=1
Ch197 h197 0 'cl'
XhF198n hp0_6 hp1_12 hF198b vh 0 nand2 k=1
XhF198i hF198b h198 vh 0 inv k=1
Ch198 h198 0 'cl'
XhF199n hp0_7 hp1_12 hF199b vh 0 nand2 k=1
XhF199i hF199b h199 vh 0 inv k=1
Ch199 h199 0 'cl'
XhF200n hp0_8 hp1_12 hF200b vh 0 nand2 k=1
XhF200i hF200b h200 vh 0 inv k=1
Ch200 h200 0 'cl'
XhF201n hp0_9 hp1_12 hF201b vh 0 nand2 k=1
XhF201i hF201b h201 vh 0 inv k=1
Ch201 h201 0 'cl'
XhF202n hp0_10 hp1_12 hF202b vh 0 nand2 k=1
XhF202i hF202b h202 vh 0 inv k=1
Ch202 h202 0 'cl'
XhF203n hp0_11 hp1_12 hF203b vh 0 nand2 k=1
XhF203i hF203b h203 vh 0 inv k=1
Ch203 h203 0 'cl'
XhF204n hp0_12 hp1_12 hF204b vh 0 nand2 k=1
XhF204i hF204b h204 vh 0 inv k=1
Ch204 h204 0 'cl'
XhF205n hp0_13 hp1_12 hF205b vh 0 nand2 k=1
XhF205i hF205b h205 vh 0 inv k=1
Ch205 h205 0 'cl'
XhF206n hp0_14 hp1_12 hF206b vh 0 nand2 k=1
XhF206i hF206b h206 vh 0 inv k=1
Ch206 h206 0 'cl'
XhF207n hp0_15 hp1_12 hF207b vh 0 nand2 k=1
XhF207i hF207b h207 vh 0 inv k=1
Ch207 h207 0 'cl'
XhF208n hp0_0 hp1_13 hF208b vh 0 nand2 k=1
XhF208i hF208b h208 vh 0 inv k=1
Ch208 h208 0 'cl'
XhF209n hp0_1 hp1_13 hF209b vh 0 nand2 k=1
XhF209i hF209b h209 vh 0 inv k=1
Ch209 h209 0 'cl'
XhF210n hp0_2 hp1_13 hF210b vh 0 nand2 k=1
XhF210i hF210b h210 vh 0 inv k=1
Ch210 h210 0 'cl'
XhF211n hp0_3 hp1_13 hF211b vh 0 nand2 k=1
XhF211i hF211b h211 vh 0 inv k=1
Ch211 h211 0 'cl'
XhF212n hp0_4 hp1_13 hF212b vh 0 nand2 k=1
XhF212i hF212b h212 vh 0 inv k=1
Ch212 h212 0 'cl'
XhF213n hp0_5 hp1_13 hF213b vh 0 nand2 k=1
XhF213i hF213b h213 vh 0 inv k=1
Ch213 h213 0 'cl'
XhF214n hp0_6 hp1_13 hF214b vh 0 nand2 k=1
XhF214i hF214b h214 vh 0 inv k=1
Ch214 h214 0 'cl'
XhF215n hp0_7 hp1_13 hF215b vh 0 nand2 k=1
XhF215i hF215b h215 vh 0 inv k=1
Ch215 h215 0 'cl'
XhF216n hp0_8 hp1_13 hF216b vh 0 nand2 k=1
XhF216i hF216b h216 vh 0 inv k=1
Ch216 h216 0 'cl'
XhF217n hp0_9 hp1_13 hF217b vh 0 nand2 k=1
XhF217i hF217b h217 vh 0 inv k=1
Ch217 h217 0 'cl'
XhF218n hp0_10 hp1_13 hF218b vh 0 nand2 k=1
XhF218i hF218b h218 vh 0 inv k=1
Ch218 h218 0 'cl'
XhF219n hp0_11 hp1_13 hF219b vh 0 nand2 k=1
XhF219i hF219b h219 vh 0 inv k=1
Ch219 h219 0 'cl'
XhF220n hp0_12 hp1_13 hF220b vh 0 nand2 k=1
XhF220i hF220b h220 vh 0 inv k=1
Ch220 h220 0 'cl'
XhF221n hp0_13 hp1_13 hF221b vh 0 nand2 k=1
XhF221i hF221b h221 vh 0 inv k=1
Ch221 h221 0 'cl'
XhF222n hp0_14 hp1_13 hF222b vh 0 nand2 k=1
XhF222i hF222b h222 vh 0 inv k=1
Ch222 h222 0 'cl'
XhF223n hp0_15 hp1_13 hF223b vh 0 nand2 k=1
XhF223i hF223b h223 vh 0 inv k=1
Ch223 h223 0 'cl'
XhF224n hp0_0 hp1_14 hF224b vh 0 nand2 k=1
XhF224i hF224b h224 vh 0 inv k=1
Ch224 h224 0 'cl'
XhF225n hp0_1 hp1_14 hF225b vh 0 nand2 k=1
XhF225i hF225b h225 vh 0 inv k=1
Ch225 h225 0 'cl'
XhF226n hp0_2 hp1_14 hF226b vh 0 nand2 k=1
XhF226i hF226b h226 vh 0 inv k=1
Ch226 h226 0 'cl'
XhF227n hp0_3 hp1_14 hF227b vh 0 nand2 k=1
XhF227i hF227b h227 vh 0 inv k=1
Ch227 h227 0 'cl'
XhF228n hp0_4 hp1_14 hF228b vh 0 nand2 k=1
XhF228i hF228b h228 vh 0 inv k=1
Ch228 h228 0 'cl'
XhF229n hp0_5 hp1_14 hF229b vh 0 nand2 k=1
XhF229i hF229b h229 vh 0 inv k=1
Ch229 h229 0 'cl'
XhF230n hp0_6 hp1_14 hF230b vh 0 nand2 k=1
XhF230i hF230b h230 vh 0 inv k=1
Ch230 h230 0 'cl'
XhF231n hp0_7 hp1_14 hF231b vh 0 nand2 k=1
XhF231i hF231b h231 vh 0 inv k=1
Ch231 h231 0 'cl'
XhF232n hp0_8 hp1_14 hF232b vh 0 nand2 k=1
XhF232i hF232b h232 vh 0 inv k=1
Ch232 h232 0 'cl'
XhF233n hp0_9 hp1_14 hF233b vh 0 nand2 k=1
XhF233i hF233b h233 vh 0 inv k=1
Ch233 h233 0 'cl'
XhF234n hp0_10 hp1_14 hF234b vh 0 nand2 k=1
XhF234i hF234b h234 vh 0 inv k=1
Ch234 h234 0 'cl'
XhF235n hp0_11 hp1_14 hF235b vh 0 nand2 k=1
XhF235i hF235b h235 vh 0 inv k=1
Ch235 h235 0 'cl'
XhF236n hp0_12 hp1_14 hF236b vh 0 nand2 k=1
XhF236i hF236b h236 vh 0 inv k=1
Ch236 h236 0 'cl'
XhF237n hp0_13 hp1_14 hF237b vh 0 nand2 k=1
XhF237i hF237b h237 vh 0 inv k=1
Ch237 h237 0 'cl'
XhF238n hp0_14 hp1_14 hF238b vh 0 nand2 k=1
XhF238i hF238b h238 vh 0 inv k=1
Ch238 h238 0 'cl'
XhF239n hp0_15 hp1_14 hF239b vh 0 nand2 k=1
XhF239i hF239b h239 vh 0 inv k=1
Ch239 h239 0 'cl'
XhF240n hp0_0 hp1_15 hF240b vh 0 nand2 k=1
XhF240i hF240b h240 vh 0 inv k=1
Ch240 h240 0 'cl'
XhF241n hp0_1 hp1_15 hF241b vh 0 nand2 k=1
XhF241i hF241b h241 vh 0 inv k=1
Ch241 h241 0 'cl'
XhF242n hp0_2 hp1_15 hF242b vh 0 nand2 k=1
XhF242i hF242b h242 vh 0 inv k=1
Ch242 h242 0 'cl'
XhF243n hp0_3 hp1_15 hF243b vh 0 nand2 k=1
XhF243i hF243b h243 vh 0 inv k=1
Ch243 h243 0 'cl'
XhF244n hp0_4 hp1_15 hF244b vh 0 nand2 k=1
XhF244i hF244b h244 vh 0 inv k=1
Ch244 h244 0 'cl'
XhF245n hp0_5 hp1_15 hF245b vh 0 nand2 k=1
XhF245i hF245b h245 vh 0 inv k=1
Ch245 h245 0 'cl'
XhF246n hp0_6 hp1_15 hF246b vh 0 nand2 k=1
XhF246i hF246b h246 vh 0 inv k=1
Ch246 h246 0 'cl'
XhF247n hp0_7 hp1_15 hF247b vh 0 nand2 k=1
XhF247i hF247b h247 vh 0 inv k=1
Ch247 h247 0 'cl'
XhF248n hp0_8 hp1_15 hF248b vh 0 nand2 k=1
XhF248i hF248b h248 vh 0 inv k=1
Ch248 h248 0 'cl'
XhF249n hp0_9 hp1_15 hF249b vh 0 nand2 k=1
XhF249i hF249b h249 vh 0 inv k=1
Ch249 h249 0 'cl'
XhF250n hp0_10 hp1_15 hF250b vh 0 nand2 k=1
XhF250i hF250b h250 vh 0 inv k=1
Ch250 h250 0 'cl'
XhF251n hp0_11 hp1_15 hF251b vh 0 nand2 k=1
XhF251i hF251b h251 vh 0 inv k=1
Ch251 h251 0 'cl'
XhF252n hp0_12 hp1_15 hF252b vh 0 nand2 k=1
XhF252i hF252b h252 vh 0 inv k=1
Ch252 h252 0 'cl'
XhF253n hp0_13 hp1_15 hF253b vh 0 nand2 k=1
XhF253i hF253b h253 vh 0 inv k=1
Ch253 h253 0 'cl'
XhF254n hp0_14 hp1_15 hF254b vh 0 nand2 k=1
XhF254i hF254b h254 vh 0 inv k=1
Ch254 h254 0 'cl'
XhF255n hp0_15 hp1_15 hF255b vh 0 nand2 k=1
XhF255i hF255b h255 vh 0 inv k=1
Ch255 h255 0 'cl'
Va0 a0 0 pwl(0 0 5e-09 0 5.02e-09 1 1e-08 1 1.002e-08 0 1.5e-08 0 1.502e-08 1 2e-08 1 2.002e-08 1 2.5e-08 1 2.502e-08 0 3e-08 0 3.002e-08 0 3.5e-08 0 3.502e-08 0)
Va1 a1 0 pwl(0 0 5e-09 0 5.02e-09 0 1e-08 0 1.002e-08 0 1.5e-08 0 1.502e-08 1 2e-08 1 2.002e-08 1 2.5e-08 1 2.502e-08 0 3e-08 0 3.002e-08 0 3.5e-08 0 3.502e-08 0)
Va2 a2 0 pwl(0 0 5e-09 0 5.02e-09 0 1e-08 0 1.002e-08 0 1.5e-08 0 1.502e-08 1 2e-08 1 2.002e-08 1 2.5e-08 1 2.502e-08 0 3e-08 0 3.002e-08 0 3.5e-08 0 3.502e-08 0)
Va3 a3 0 pwl(0 0 5e-09 0 5.02e-09 0 1e-08 0 1.002e-08 0 1.5e-08 0 1.502e-08 1 2e-08 1 2.002e-08 1 2.5e-08 1 2.502e-08 0 3e-08 0 3.002e-08 0 3.5e-08 0 3.502e-08 0)
Va4 a4 0 pwl(0 0 5e-09 0 5.02e-09 0 1e-08 0 1.002e-08 0 1.5e-08 0 1.502e-08 0 2e-08 0 2.002e-08 1 2.5e-08 1 2.502e-08 0 3e-08 0 3.002e-08 1 3.5e-08 1 3.502e-08 0)
Va5 a5 0 pwl(0 0 5e-09 0 5.02e-09 0 1e-08 0 1.002e-08 0 1.5e-08 0 1.502e-08 0 2e-08 0 2.002e-08 1 2.5e-08 1 2.502e-08 0 3e-08 0 3.002e-08 0 3.5e-08 0 3.502e-08 0)
Va6 a6 0 pwl(0 0 5e-09 0 5.02e-09 0 1e-08 0 1.002e-08 0 1.5e-08 0 1.502e-08 0 2e-08 0 2.002e-08 1 2.5e-08 1 2.502e-08 0 3e-08 0 3.002e-08 0 3.5e-08 0 3.502e-08 0)
Va7 a7 0 pwl(0 0 5e-09 0 5.02e-09 0 1e-08 0 1.002e-08 0 1.5e-08 0 1.502e-08 0 2e-08 0 2.002e-08 1 2.5e-08 1 2.502e-08 0 3e-08 0 3.002e-08 0 3.5e-08 0 3.502e-08 0)

.tran 2p 40n 0 2p
.print tran v(a0) v(a4) v(t0) v(t1) v(t15) v(t16) v(t255) v(h0)
+ v(h1) v(h15) v(h16) v(h255)
.measure tran rise_t trig v(a0) val=.5 rise=1 targ v(t1) val=.5 rise=1
.measure tran fall_t trig v(a0) val=.5 fall=1 targ v(t1) val=.5 fall=1
.measure tran power_t avg par('-i(VT)') from=5n to=40n
.measure tran rise_h trig v(a0) val=.5 rise=1 targ v(h1) val=.5 rise=1
.measure tran fall_h trig v(a0) val=.5 fall=1 targ v(h1) val=.5 fall=1
.measure tran power_h avg par('-i(VH)') from=5n to=40n


.alter load_100f
.temp 27
.param cl=10f
.param cl=100f

.end
