##fuel gestion

var tankSelection = func{
	var no_moteur_tank_0 = getprop("/controls/fuel/tank[0]/position");
	var no_moteur_tank_1 = getprop("/controls/fuel/tank[1]/position");

	var tank0_selected = 0;
	var tank1_selected = 0;
	#choix du reservoir utilise
	if(no_moteur_tank_0==2 or no_moteur_tank_1==1){
		tank0_selected = 1;
	}
	if(no_moteur_tank_1==2 or no_moteur_tank_0==1){
		tank1_selected = 1;
	}
	
	var tank0_mixture = 0;
	var tank1_mixture = 0;
	#le moteur est il alimente
	if((no_moteur_tank_0==2 and getprop("/consumables/fuel/tank[0]/empty")==0) or (no_moteur_tank_0==1 and getprop("/consumables/fuel/tank[1]/empty")==0)){
		tank0_mixture = 1;
		setprop("/engines/engine[0]/out-of-fuel",0);
	}
	if((no_moteur_tank_1==2 and getprop("/consumables/fuel/tank[1]/empty")==0) or (no_moteur_tank_1==1 and getprop("/consumables/fuel/tank[0]/empty")==0)){
		tank1_mixture = 1;
		setprop("/engines/engine[1]/out-of-fuel",0);
	}
	
	setprop("/consumables/fuel/tank[0]/selected",tank0_selected);
	setprop("/consumables/fuel/tank[1]/selected",tank1_selected);
	setprop("/controls/engines/engine[0]/mixture",tank0_mixture);
	setprop("/controls/engines/engine[1]/mixture",tank1_mixture);
}
setlistener("/controls/fuel/tank[0]/position", tankSelection);
setlistener("/controls/fuel/tank[1]/position", tankSelection);

##calcul de la consommation de carburant, pour le systeme de gestion du carburant du zkv1000
var fuel_consumtion_calcul = func(dt){

	##update for fuel level saving
	setprop("/consumables/fuel/tank[0]/level-gal_us-for_save",getprop("/consumables/fuel/tank[0]/level-gal_us"));
	setprop("/consumables/fuel/tank[1]/level-gal_us-for_save",getprop("/consumables/fuel/tank[1]/level-gal_us"));

	if(getprop("/instrumentation/enginstr/serviceable")==1){
		var fuel_used = getprop("/consumables/fuel/fuel-gest/fuel-used");
		var fuel_remaining = getprop("/consumables/fuel/fuel-gest/fuel-remaining");
		var fuel_gph_total = 0;
		for(var i=0; i < 2; i = i + 1) {
			if(getprop("/engines/engine[1]/fuel-flow-gph")!=nil){
				fuel_gph_total = fuel_gph_total + getprop("/engines/engine["~i~"]/fuel-flow-gph");
			}
		}
		
		var fuel_gph_total_par_secondes = fuel_gph_total * dt / 3600;
		fuel_remaining = fuel_remaining - fuel_gph_total_par_secondes;
		fuel_used = fuel_used + fuel_gph_total_par_secondes;
		if(fuel_remaining<0){
			fuel_remaining = 0;
		}
		
		var time_remaining = 0;
		if(fuel_gph_total>0){
			time_remaining = fuel_remaining / fuel_gph_total;
		}
		
		var hours_remaining = int(time_remaining);
		var minutes_remaining = int((time_remaining - hours_remaining) * 60);

		if(hours_remaining>99){
			hours_remaining = 99;
			minutes_remaining = 99;
		}
		if(hours_remaining<10){
			hours_remaining = sprintf("0%1.f",hours_remaining);
		}else{
			hours_remaining = sprintf("%1.f",hours_remaining);
		}
		if(minutes_remaining<10){
			minutes_remaining = sprintf("0%1.f",minutes_remaining);
		}else{
			minutes_remaining = sprintf("%1.f",minutes_remaining);
		}

		var speed = getprop("/velocities/airspeed-kt");
		var range = speed * time_remaining;
		if(range>9999){
			range = 9999;
		}
		
		setprop("/consumables/fuel/fuel-gest/fuel-used",fuel_used);
		setprop("/consumables/fuel/fuel-gest/fuel-remaining",fuel_remaining);
		setprop("/consumables/fuel/fuel-gest/endurance-hours",hours_remaining);
		setprop("/consumables/fuel/fuel-gest/endurance-minutes",minutes_remaining);
		setprop("/consumables/fuel/fuel-gest/range",range);
	}
}
