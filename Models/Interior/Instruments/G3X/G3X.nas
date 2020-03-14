# Garmin GTX 327 by D-ECHO based on

# A3XX Lower ECAM Canvas
# Joshua Davidson (it0uchpods)
#######################################

var G3X_only = nil;
var G3X_display = nil;
var page = "only";
var G3X_flight_counter = 0;
var G3X_flight_counter_stop = 0;
var G3X_up_counter = 0;
var G3X_down_counter = 0;
var rotation=-0.01744;
setprop("/engines/engine[0]/rpm", 0);
setprop("/instrumentation/transponder/inputs/digitnbr", 1);
setprop("/instrumentation/transponder/inputs/ident-btn", 0);
setprop("/instrumentation/transponder/inputs/ident-btn-2", 0);
setprop("/instrumentation/G3X/start", 0);
setprop("/instrumentation/G3X/stop", 0);
setprop("/instrumentation/G3X/func", 1);
setprop("/systems/electrical/volts", 0);
setprop("/test", 0);

#roundToNearest function used for alt tape, thanks @Soitanen (737-800)!
var roundToNearest = func(n, m) {
	var x = int(n/m)*m;
	if((math.mod(n,m)) > (m/2) and n > 0)
			x = x + m;
	if((m - (math.mod(n,m))) > (m/2) and n < 0)
			x = x - m;
	return x;
}


var canvas_G3X_base = {
	init: func(canvas_group, file) {
		
		var font_mapper = func(family, weight) {
			#return "LiberationFonts/LiberationMono-Bold.ttf";
		};

		canvas.parsesvg(canvas_group, file, {'font-mapper': font_mapper});

		
		 var svg_keys = me.getKeys();
		 
		 
		foreach(var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
			var svg_keys = me.getKeys();
			foreach (var key; svg_keys) {
			me[key] = canvas_group.getElementById(key);
			var clip_el = canvas_group.getElementById(key ~ "_clip");
			if (clip_el != nil) {
				clip_el.setVisible(0);
				var tran_rect = clip_el.getTransformedBounds();
				var clip_rect = sprintf("rect(%d,%d, %d,%d)", 
				tran_rect[1], # 0 ys
				tran_rect[2], # 1 xe
				tran_rect[3], # 2 ye
				tran_rect[0]); #3 xs
				#   coordinates are top,right,bottom,left (ys, xe, ye, xs) ref: l621 of simgear/canvas/CanvasElement.cxx
				me[key].set("clip", clip_rect);
				me[key].set("clip-frame", canvas.Element.PARENT);
			}
			}
		}
		
		me.h_trans = me["horizon"].createTransform();
		me.h_rot = me["horizon"].createTransform();


		me.page = canvas_group;

		return me;
	},
	getKeys: func() {
		return [];
	},
	update: func() {
		if (getprop("/systems/electrical/volts") > 15 ) {
			G3X_only.page.show();
		} else {
			G3X_only.page.hide();
		}
		
		settimer(func me.update(), 0.02);
	},
};
	
	
var canvas_G3X_only = {
	new: func(canvas_group, file) {
		var m = { parents: [canvas_G3X_only , canvas_G3X_base] };
		m.init(canvas_group, file);

		return m;
	},
	getKeys: func() {
		return ["COM1Act","COM1Sby","RPM","compass","compass.text","compass.text.1","compass.text.2","compass.text.3","compass.text.4","compass.text.5","compass.text.6","compass.text.7","compass.text.8","compass.text.9","compass.text.10","compass.text.11","compass.text.12","heading","XPDR.code","XPDR.mode","XPDR.ident","fuelL","fuelR","oil.F","oil.PSI","ff.GPH","radial","OAT","GS","TAS","asi.10","asi.100","asi.rollingdigits","asi.tape","horizon","fd","ball","altTapeScale","altTextHigh1","altTextHigh2","altTextHigh3","altTextHigh4","altTextHigh5","altTextHigh6","altTextHigh7","altTextHigh8","altTextHigh9","altTextHigh10",
		"altTextLow1","altTextLow2","altTextLow3","altTextLow4","altTextLow5","altTextLow6","altTextLow7","altTextLow8","altTextLow9",
		"altTextHighSmall2","altTextHighSmall3","altTextHighSmall4","altTextHighSmall5","altTextHighSmall6","altTextHighSmall7","altTextHighSmall8","altTextHighSmall9","altTextHighSmall10",
		"altTextLowSmall1","altTextLowSmall2","altTextLowSmall3","altTextLowSmall4","altTextLowSmall5","altTextLowSmall6","altTextLowSmall7","altTextLowSmall8","altTextLowSmall9","alt.rollingdigits","alt.10000","alt.1000","alt.100","hdg.bug","hdg.bug.deg","alt.bug","alt.bug_small"];
	},
	update: func() {
	
		me["COM1Act"].setText(sprintf(getprop("/instrumentation/comm/frequencies/selected-mhz")));
		me["COM1Sby"].setText(sprintf(getprop("/instrumentation/comm/frequencies/standby-mhz")));
	
		me["RPM"].setText(sprintf("%s", math.round(getprop("/engines/engine[0]/rpm") or 0)));
		
		var hdg_bug=getprop("/instrumentation/heading-indicator/heading-bug-deg") or 0;
		var hdg=getprop("/instrumentation/heading-indicator/indicated-heading-deg") or 0;
		var hdg_bug_diff=hdg-hdg_bug;
		me["compass"].setRotation(hdg*-0.01744);
		me["compass.text"].setRotation(hdg*rotation);
		me["compass.text.1"].setRotation(hdg*(-rotation));
		me["compass.text.2"].setRotation(hdg*(-rotation));
		me["compass.text.3"].setRotation(hdg*(-rotation));
		me["compass.text.4"].setRotation(hdg*(-rotation));
		me["compass.text.5"].setRotation(hdg*(-rotation));
		me["compass.text.6"].setRotation(hdg*(-rotation));
		me["compass.text.7"].setRotation(hdg*(-rotation));
		me["compass.text.8"].setRotation(hdg*(-rotation));
		me["compass.text.9"].setRotation(hdg*(-rotation));
		me["compass.text.10"].setRotation(hdg*(-rotation));
		me["compass.text.11"].setRotation(hdg*(-rotation));
		me["compass.text.12"].setRotation(hdg*(-rotation));
		me["hdg.bug"].setRotation(hdg_bug_diff*(rotation));
		me["heading"].setText(sprintf("%s", math.round(hdg)));
		me["radial"].setText(sprintf("%s", math.round(getprop("/instrumentation/nav/radials/target-radial-deg") or 0)));
		me["hdg.bug.deg"].setText(sprintf("%s", math.round(hdg_bug)));
		

		me["XPDR.code"].setText(sprintf(getprop("/instrumentation/transponder/id-code")));
		var XPDRmode=getprop("/instrumentation/transponder/inputs/knob-mode");
		if(XPDRmode==0){
			me["XPDR.mode"].setText("OFF");
		}else if(XPDRmode==1){
			me["XPDR.mode"].setText("SBY");
		}else if(XPDRmode==2){
			me["XPDR.mode"].setText("TST");
		}else if(XPDRmode==3){
			me["XPDR.mode"].setText("GND");
		}else if(XPDRmode==4){
			me["XPDR.mode"].setText("ON");
		}else if(XPDRmode==5){
			me["XPDR.mode"].setText("ALT");
		}
		
		var XPDRident=getprop("/instrumentation/transponder/ident");
		if(XPDRident==1){
			me["XPDR.ident"].setColor(0,1,0);
		}else{
			me["XPDR.ident"].setColor(0.5,0.5,0.5);
		}
		
		me["ff.GPH"].setText(sprintf("%s", math.round(getprop("/engines/engine/fuel-flow-gph") or 0)));
		me["oil.F"].setText(sprintf("%s", math.round(getprop("/engines/engine/oil-temperature-degf") or 0)));
		me["oil.PSI"].setText(sprintf("%s", math.round(getprop("/engines/engine/oil-pressure-psi") or 0)));
		
		me["fuelL"].setTranslation((getprop("/consumables/fuel/tank[0]/level-norm") or 0)*102.3, 0);
		me["fuelR"].setTranslation((getprop("/consumables/fuel/tank[1]/level-norm") or 0)*102.3, 0);
		
		me["OAT"].setText(sprintf("%s", math.round(getprop("/environment/temperature-degc") or 0)));
		
		#Airspeed Indicator
		me["TAS"].setText(sprintf("%s", math.round(getprop("/instrumentation/airspeed-indicator/true-speed-kt") or 0)));
		me["GS"].setText(sprintf("%s", math.round(getprop("/velocities/groundspeed-kt") or 0)));
		
		var airspeed=getprop("/instrumentation/airspeed-indicator/indicated-speed-kt") or 0;
		var asi10=getprop("/instrumentation/pfd/asi-10") or 0;
		if(asi10!=0){
			me["asi.10"].show();
			me["asi.10"].setText(sprintf("%s", math.round((10*math.mod(asi10/10,1)))));
		}else{
			me["asi.10"].hide();
		}
		var asi100=getprop("/instrumentation/pfd/asi-100") or 0;
		if(asi100!=0){
			me["asi.100"].show();
			me["asi.100"].setText(sprintf("%s", math.round(asi100)));
		}else{
			me["asi.100"].hide();
		}
		#me["asi.10"].setText(sprintf("%s", math.round((10*math.mod(asi10/10,1)))));
		me["asi.rollingdigits"].setTranslation(0,math.round((10*math.mod(airspeed/10,1))*27.8, 0.1));
		
		me["asi.tape"].setTranslation(0,math.round(airspeed*3.09));
		
		#Attitude Indicator
		
		var pitch = (getprop("orientation/pitch-deg") or 0);
		var roll =  getprop("orientation/roll-deg") or 0;
		#var x=math.sin(-3.14/180*roll)*pitch*5.6;
		#var y=math.cos(-3.13/180*roll)*pitch*5.6;
		
		#me["horizon"].setTranslation(x,y);
		#me["horizon"].setCenter(me["fd"].getCenter());
		#me["horizon"].setRotation(roll*(rotation));
		
		#me["horizon"].setTranslation(0,math.round(getprop("/orientation/pitch-deg")*5.6));
		
		me.h_trans.setTranslation(0,pitch*11.2);
		me.h_rot.setRotation(-roll*-0.5*rotation,me["horizon"].getCenter());
		
		me["ball"].setTranslation(getprop("/instrumentation/slip-skid-ball/indicated-slip-skid")*20,0);
		
		#Altitude Indicator
		var alt = getprop("instrumentation/altimeter/indicated-altitude-ft");
		
		me["altTapeScale"].setTranslation(0,(alt - roundToNearest(alt, 1000))*0.445);
		
		if (roundToNearest(alt, 1000) == 0) {
			me["altTextLowSmall1"].setText(sprintf("%0.0f",100));
			me["altTextLowSmall2"].setText(sprintf("%0.0f",200));
			me["altTextLowSmall3"].setText(sprintf("%0.0f",300));
			me["altTextLowSmall4"].setText(sprintf("%0.0f",400));
			me["altTextLowSmall5"].setText(sprintf("%0.0f",500));
			me["altTextLowSmall6"].setText(sprintf("%0.0f",600));
			me["altTextLowSmall7"].setText(sprintf("%0.0f",700));
			me["altTextLowSmall8"].setText(sprintf("%0.0f",800));
			me["altTextLowSmall9"].setText(sprintf("%0.0f",900));
			me["altTextHighSmall2"].setText(sprintf("%0.0f",100));
			me["altTextHighSmall3"].setText(sprintf("%0.0f",200));
			me["altTextHighSmall4"].setText(sprintf("%0.0f",300));
			me["altTextHighSmall5"].setText(sprintf("%0.0f",400));
			me["altTextHighSmall6"].setText(sprintf("%0.0f",500));
			me["altTextHighSmall7"].setText(sprintf("%0.0f",600));
			me["altTextHighSmall8"].setText(sprintf("%0.0f",700));
			me["altTextHighSmall9"].setText(sprintf("%0.0f",800));
			me["altTextHighSmall10"].setText(sprintf("%0.0f",900));
			var altNumLow = "-";
			var altNumHigh = "";
			var altNumCenter = altNumHigh;
		} elsif (roundToNearest(alt, 1000) > 0) {
			me["altTextLowSmall1"].setText(sprintf("%0.0f",900));
			me["altTextLowSmall2"].setText(sprintf("%0.0f",800));
			me["altTextLowSmall3"].setText(sprintf("%0.0f",700));
			me["altTextLowSmall4"].setText(sprintf("%0.0f",600));
			me["altTextLowSmall5"].setText(sprintf("%0.0f",500));
			me["altTextLowSmall6"].setText(sprintf("%0.0f",400));
			me["altTextLowSmall7"].setText(sprintf("%0.0f",300));
			me["altTextLowSmall8"].setText(sprintf("%0.0f",200));
			me["altTextLowSmall9"].setText(sprintf("%0.0f",100));
			me["altTextHighSmall2"].setText(sprintf("%0.0f",100));
			me["altTextHighSmall3"].setText(sprintf("%0.0f",200));
			me["altTextHighSmall4"].setText(sprintf("%0.0f",300));
			me["altTextHighSmall5"].setText(sprintf("%0.0f",400));
			me["altTextHighSmall6"].setText(sprintf("%0.0f",500));
			me["altTextHighSmall7"].setText(sprintf("%0.0f",600));
			me["altTextHighSmall8"].setText(sprintf("%0.0f",700));
			me["altTextHighSmall9"].setText(sprintf("%0.0f",800));
			var altNumLow = roundToNearest(alt, 1000)/1000 - 1;
			var altNumHigh = roundToNearest(alt, 1000)/1000;
			var altNumCenter = altNumHigh;
		} elsif (roundToNearest(alt, 1000) < 0) {
			me["altTextLowSmall1"].setText(sprintf("%0.0f",100));
			me["altTextLowSmall2"].setText(sprintf("%0.0f",200));
			me["altTextLowSmall3"].setText(sprintf("%0.0f",300));
			me["altTextLowSmall4"].setText(sprintf("%0.0f",400));
			me["altTextLowSmall5"].setText(sprintf("%0.0f",500));
			me["altTextLowSmall6"].setText(sprintf("%0.0f",600));
			me["altTextLowSmall7"].setText(sprintf("%0.0f",700));
			me["altTextLowSmall8"].setText(sprintf("%0.0f",800));
			me["altTextLowSmall9"].setText(sprintf("%0.0f",900));
			me["altTextHighSmall2"].setText(sprintf("%0.0f",900));
			me["altTextHighSmall3"].setText(sprintf("%0.0f",800));
			me["altTextHighSmall4"].setText(sprintf("%0.0f",700));
			me["altTextHighSmall5"].setText(sprintf("%0.0f",600));
			me["altTextHighSmall6"].setText(sprintf("%0.0f",500));
			me["altTextHighSmall7"].setText(sprintf("%0.0f",400));
			me["altTextHighSmall8"].setText(sprintf("%0.0f",300));
			me["altTextHighSmall9"].setText(sprintf("%0.0f",200));
			me["altTextHighSmall10"].setText(sprintf("%0.0f",100));
			var altNumLow = roundToNearest(alt, 1000)/1000;
			var altNumHigh = roundToNearest(alt, 1000)/1000 + 1;
			var altNumCenter = altNumLow;
		}
		if ( altNumLow == 0 ) {
			altNumLow = "";
		}
		if ( altNumHigh == 0 and alt < 0) {
			altNumHigh = "-";
		}
		me["altTextLow1"].setText(sprintf("%s", altNumLow));
		me["altTextLow2"].setText(sprintf("%s", altNumLow));
		me["altTextLow3"].setText(sprintf("%s", altNumLow));
		me["altTextLow4"].setText(sprintf("%s", altNumLow));
		me["altTextLow5"].setText(sprintf("%s", altNumLow));
		me["altTextLow6"].setText(sprintf("%s", altNumLow));
		me["altTextLow7"].setText(sprintf("%s", altNumLow));
		me["altTextLow8"].setText(sprintf("%s", altNumLow));
		me["altTextLow9"].setText(sprintf("%s", altNumLow));
		me["altTextHigh1"].setText(sprintf("%s", altNumCenter));
		me["altTextHigh2"].setText(sprintf("%s", altNumHigh));
		me["altTextHigh3"].setText(sprintf("%s", altNumHigh));
		me["altTextHigh4"].setText(sprintf("%s", altNumHigh));
		me["altTextHigh5"].setText(sprintf("%s", altNumHigh));
		me["altTextHigh6"].setText(sprintf("%s", altNumHigh));
		me["altTextHigh7"].setText(sprintf("%s", altNumHigh));
		me["altTextHigh8"].setText(sprintf("%s", altNumHigh));
		me["altTextHigh9"].setText(sprintf("%s", altNumHigh));
		me["altTextHigh10"].setText(sprintf("%s", altNumHigh));
		
		
		
		var alt100=(getprop("/instrumentation/PFD/alt-1") or 0)/100;
		me["alt.rollingdigits"].setTranslation(0,math.round((10*math.mod(alt100,1))*19.58, 0.1));		
		
		var alt10000=(getprop("/instrumentation/PFD/alt-10000") or 0);
		if(alt10000!=0){
			me["alt.10000"].show();
			me["alt.10000"].setText(sprintf("%s", getprop("/instrumentation/PFD/alt-10000")));
		}else{
			me["alt.10000"].hide();
		}
		me["alt.1000"].setText(sprintf("%s", int(10*math.mod((getprop("/instrumentation/PFD/alt-1000") or 0)/10,1))));
		me["alt.100"].setText(sprintf("%s", int(10*math.mod((getprop("/instrumentation/PFD/alt-100") or 0)/10,1))));
		
		var alt_bug=getprop("/instrumentation/PFD/altitude-bug");
		var alt_bug_1000=getprop("/instrumentation/PFD/altitude-bug-1000") or 0;
		if(alt_bug_1000!=0){
			me["alt.bug"].show();
			me["alt.bug"].setText(sprintf("%s", alt_bug_1000));
		}else{
			me["alt.bug"].hide();
		}
		me["alt.bug_small"].setText(sprintf("%s", int(1000*math.mod(alt_bug/1000,1))));
		
		
		settimer(func me.update(), 0.02);
	},
};


var identoff = func {
	setprop("/instrumentation/transponder/inputs/ident-btn", 0);
}

setlistener("/instrumentation/transponder/inputs/ident-btn-2", func{
	setprop("/instrumentation/transponder/inputs/ident-btn", 1);
	settimer(identoff, 18);
});


setlistener("sim/signals/fdm-initialized", func {
	G3X_display = canvas.new({
		"name": "G3X",
		"size": [2048, 1226],
		"view": [1024, 613],
		"mipmapping": 1
	});
	G3X_display.addPlacement({"node": "G3X.screen"});
	var groupOnly = G3X_display.createGroup();

	G3X_only = canvas_G3X_only.new(groupOnly, "Aircraft/SR22T/Models/Interior/Instruments/G3X/G3X.svg");

	G3X_only.update();
	canvas_G3X_base.update();
});

var showG3X = func {
	var dlg = canvas.Window.new([512, 307], "dialog").set("resize", 1);
	dlg.setCanvas(G3X_display);
}
