MOS DC example - flat model library
* The library is supplied separately and must define nmos and pmos.
* Add the local model configuration to a private execution copy.
* MODEL_SETUP_REQUIRED
.option post=2
.temp 25
VGS gate 0 0.6
VDS drain 0 0
M1 drain gate 0 0 nmos W=0.6u L=0.25u
.dc VDS 0 1 0.01
.print dc V(drain) I(VDS)
.end
