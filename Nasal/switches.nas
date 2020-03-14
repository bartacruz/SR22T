##
## 
##  modified by D-ECHO for C4
##  Clément de l'Hamaide - PAF Team - http://equipe-flightgear.forumactif.com
##  This file is licensed under the GPL license version 2 or later.
##
###############################################################################

setlistener("/controls/electric/battery1-switch", func(v) {
  if(v.getValue()){
    interpolate("/controls/electric/battery1-switch-pos", 1, 0.25);
  }else{
    interpolate("/controls/electric/battery1-switch-pos", 0, 0.25);
  }
});

setlistener("/controls/electric/battery2-switch", func(v) {
  if(v.getValue()){
    interpolate("/controls/electric/battery2-switch-pos", 1, 0.25);
  }else{
    interpolate("/controls/electric/battery2-switch-pos", 0, 0.25);
  }
});

setlistener("/controls/engines/engine[0]/alt1", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine[0]/alt1-pos", 1, 0.25);
  }else{
    interpolate("/controls/engines/engine[0]/alt1-pos", 0, 0.25);
  }
});

setlistener("/controls/engines/engine[0]/alt2", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine[0]/alt2-pos", 1, 0.25);
  }else{
    interpolate("/controls/engines/engine[0]/alt2-pos", 0, 0.25);
  }
});


setlistener("/controls/electric/avionics-switch", func(v) {
  if(v.getValue()){
    interpolate("/controls/electric/avionics-switch-pos", 1, 0.25);
  }else{
    interpolate("/controls/electric/avionics-switch-pos", 0, 0.25);
  }
});

setlistener("/controls/engines/engine/starter_cmd", func(v) {
  if(v.getValue()){
    interpolate("/controls/engines/engine/starter_cmd-pos", 1, 0.25);
  }else{
    interpolate("/controls/engines/engine/starter_cmd-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/landing-lights", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/landing-lights-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/landing-lights-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/strobe-lights", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/strobe-lights-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/strobe-lights-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/nav-lights", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/nav-lights-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/nav-lights-pos", 0, 0.25);
  }
});

setlistener("/controls/gear/brake-parking", func(v) {
  if(v.getValue()){
    interpolate("/controls/gear/brake-parking-pos", 1, 0.25);
  }else{
    interpolate("/controls/gear/brake-parking-pos", 0, 0.25);
  }
});

setlistener("/controls/anti-ice/pitot-heat", func(v) {
  if(v.getValue()){
    interpolate("/controls/anti-ice/pitot-heat-pos", 1, 0.25);
  }else{
    interpolate("/controls/anti-ice/pitot-heat-pos", 0, 0.25);
  }
});

setlistener("/controls/fuel/selected-tank", func(v) {
  if(v.getValue() == 0){
    interpolate("/controls/fuel/selected-tank-pos", 0, 0.25);
    setprop("fdm/jsbsim/propulsion/tank[0]/priority", 0);
    setprop("fdm/jsbsim/propulsion/tank[1]/priority", 0);
  }elsif(v.getValue() == -1){
    interpolate("/controls/fuel/selected-tank-pos", -1, 0.25);
    setprop("fdm/jsbsim/propulsion/tank[0]/priority", 0);
    setprop("fdm/jsbsim/propulsion/tank[1]/priority", 1);
  }elsif(v.getValue() == 1){
    interpolate("/controls/fuel/selected-tank-pos", 1, 0.25);
    setprop("fdm/jsbsim/propulsion/tank[0]/priority", 1);
    setprop("fdm/jsbsim/propulsion/tank[1]/priority", 0);
  }
});


setlistener("/controls/fuel/tank/boost-pump", func(v) {
  if(v.getValue()){
    interpolate("/controls/fuel/tank/boost-pump-pos", 1, 0.25);
  }else{
    interpolate("/controls/fuel/tank/boost-pump-pos", 0, 0.25);
  }
});

setlistener("/controls/lighting/warning-test", func(v) {
  if(v.getValue()){
    interpolate("/controls/lighting/warning-test-pos", 1, 0.25);
  }else{
    interpolate("/controls/lighting/warning-test-pos", 0, 0.25);
  }
});

setlistener("/controls/engines/engine/magnetos", func(v) {
    interpolate("/controls/engines/engine/magnetos-pos", v.getValue(), 0.25);
    if(v.getValue()!=0){
	setprop("/controls/engines/key", 1);
    }
});

setlistener("/controls/engines/engine/starter", func(v) {
    interpolate("/controls/engines/engine/starter-pos", v.getValue(), 0.25);
    if(v.getValue()!=0){
	setprop("/controls/engines/key", 1);
    }
});

setlistener("/controls/flight/flaps-cmd", func(v) {
    interpolate("/controls/flight/flaps-cmd-pos", v.getValue(), 0.25);
});

