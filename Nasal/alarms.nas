##alarms 

#activation de la stall horn (non gerer par yasim)
var stall_horn = func{
	var alert = 0;
	var kias = getprop("velocities/airspeed-kt");
	var wow0 = getprop("gear/gear[0]/wow");
	var wow1 = getprop("gear/gear[1]/wow");
	var wow2 = getprop("gear/gear[2]/wow");
	#var button_click = getprop("/controls/switches/stall_annunciator-click");
	if(getprop("/controls/electric/alimentation/stallwrn")){
		var stall_speed = 62 - (getprop("/controls/flight/flaps")*6);
		if(kias<stall_speed and !wow1 and !wow2 and !wow0){
			alert=1;
		}
	}
	
	setprop("/sim/alarms/stall-warning",alert);
}

var check_g_load = func(dt){
	var g_load = getprop("/accelerations/pilot-g");
	if(g_load!=nil and (g_load>3.58 or g_load<-1.43)){
		g_dt = g_dt + dt;
		setprop("/sim/sound/creak-gload",1);
	}else{
		g_dt = 0;
		setprop("/sim/sound/creak-gload",0);
	}

	if(g_dt>3 and getprop("/controls/flight/wing_destroyed")==0){
		setprop("/controls/flight/wing_destroyed",1);
		setprop("/sim/failure-manager/controls/flight/aileron/serviceable",0);
		setprop("/sim/failure-manager/controls/flight/elevator/serviceable",0);
		setprop("/sim/failure-manager/controls/flight/rudder/serviceable",0);
		setprop("/sim/failure-manager/controls/engines/engine[1]/serviceable",0);
		setprop("/sim/sound/crash",1);
		setprop("/sim/messages/copilot","Too much G load !!!!!!!!!!!!!");
	}
}

var check_vne_flaps = func{
	var kias = getprop("velocities/airspeed-kt");
	var flaps = getprop("/controls/flight/flaps");
	if(getprop("/sim/failure-manager/controls/flight/flaps/serviceable")==1){
		if(kias!=nil and flaps!=nil){
			if((flaps==1 and kias>111) or (flaps>0 and kias>137)){
				setprop("/sim/failure-manager/controls/flight/flaps/serviceable",0);
				setprop("/sim/sound/crash",1);
				setprop("/sim/messages/copilot","VNE for flaps exceed !!!!!!!!!!!!!");
			}
		}
	}
}

var	check_vne_structure = func{
	var kias = getprop("/velocities/airspeed-kt");
	var margin = 10;##10 kts de marge
	var vne = 194;

	if(kias!=nil and getprop("/controls/flight/wing_destroyed")==0){
		if(kias>(vne+margin)){
			setprop("/controls/flight/wing_destroyed",1);
			setprop("/sim/failure-manager/controls/flight/aileron/serviceable",0);
			setprop("/sim/failure-manager/controls/flight/elevator/serviceable",0);
			setprop("/sim/failure-manager/controls/flight/rudder/serviceable",0);
			setprop("/sim/failure-manager/controls/engines/engine[1]/serviceable",0);
			setprop("/sim/sound/crash",1);
			setprop("/sim/messages/copilot","VNE exceed !!!!!!!!!!!!!");
		}elsif(kias>vne){##quand on s'approche de la vne, les controls deviennent aleatoires ... };-)
			#setprop("/sim/messages/copilot","VNE approching !!!!!!!!!!!!!");
			
			var ecart = (1 - abs(kias-(vne+margin)) / margin)/10;
			if(rand()>0.5){
				ecart = - ecart;
			}
			setprop("/controls/flight/aileron",getprop("/controls/flight/aileron")+ecart);
			if(rand()>0.5){
				ecart = - ecart;
			}
			setprop("/controls/flight/elevator",getprop("/controls/flight/elevator")+ecart);
			if(rand()>0.5){
				ecart = - ecart;
			}
			setprop("/controls/flight/rudder",getprop("/controls/flight/rudder")+ecart);
			setprop("/sim/sound/creak-vne",abs(1-abs(kias-(vne+margin))/margin));
		}else{
			setprop("/sim/sound/creak-vne",0);
		}
	}
}

var check_pitot_icing = func{
	if(getprop("/sim/icing/pitot")>0.5){
		setprop("/systems/pitot/serviceable",0);
	}else{
		setprop("/systems/pitot/serviceable",1);
	}
}