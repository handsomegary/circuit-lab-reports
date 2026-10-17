MOS DC example - flat model library
* Run from this directory, or replace the quoted path with an absolute path.
* The library is supplied separately and must define nmos and pmos.
.include '../models/process.lib'
* Absolute-path alternative (uncomment it and remove the line above):
* .include 'D:/models/process.lib'
.option post=2
.temp 25
VGS gate 0 0.6
VDS drain 0 0
M1 drain gate 0 0 nmos W=0.6u L=0.25u
.dc VDS 0 1 0.01
.print dc V(drain) I(VDS)
.end
