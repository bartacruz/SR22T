var vol_comm1 = 0;
var vol_comm2 = 0;
var last_audio = 0;

_setlistener("/sim/signals/fdm-initialized", func {
	vol_comm1 = getprop("/instrumentation/comm[0]/volume");
	vol_comm2 = getprop("/instrumentation/comm[1]/volume");
	last_audio = getprop("/instrumentation/audio/serviceable");
});

_setlistener("/controls/switches/mixer/adf", func {
	setprop("/instrumentation/adf[0]/ident-audible",getprop("/controls/switches/mixer/adf"));
});

_setlistener("/controls/switches/mixer/nav1", func {
	setprop("/instrumentation/nav[0]/audio-btn",getprop("/controls/switches/mixer/nav1"));
});

_setlistener("/controls/switches/mixer/nav2", func {
	setprop("/instrumentation/nav[1]/audio-btn",getprop("/controls/switches/mixer/nav2"));
});

_setlistener("/controls/switches/mixer/com1", func {
	if(getprop("/controls/switches/mixer/com1")==0){
		vol_comm1 = getprop("/instrumentation/comm[0]/volume");
		setprop("/instrumentation/comm[0]/volume",0);
	}else{
		setprop("/instrumentation/comm[0]/volume",vol_comm1);
	}
});

_setlistener("/controls/switches/mixer/com2", func {
	if(getprop("/controls/switches/mixer/com2")==0){
		vol_comm2 = getprop("/instrumentation/comm[1]/volume");
		setprop("/instrumentation/comm[1]/volume",0);
	}else{
		setprop("/instrumentation/comm[1]/volume",vol_comm2);
	}
});

_setlistener("/controls/switches/mixer/mkrmute", func {
	setprop("/instrumentation/marker-beacon/audio-btn",getprop("/controls/switches/mixer/mkrmute"));
});

_setlistener("/instrumentation/audio/serviceable", func {
	if(last_audio==getprop("/instrumentation/audio/serviceable")){
		return;
	}else{
		if(getprop("/instrumentation/audio/serviceable")==1){
			setprop("/instrumentation/comm[0]/volume",vol_comm1);
			setprop("/instrumentation/comm[1]/volume",vol_comm2);
			setprop("/instrumentation/nav[0]/audio-btn",getprop("/controls/switches/mixer/nav1"));
			setprop("/instrumentation/nav[1]/audio-btn",getprop("/controls/switches/mixer/nav2"));
			setprop("/instrumentation/adf[0]/ident-audible",getprop("/controls/switches/mixer/adf"));
			setprop("/instrumentation/marker-beacon/audio-btn",getprop("/controls/switches/mixer/mkrmute"));
		}else{
			vol_comm1 = getprop("/instrumentation/comm[0]/volume");
			vol_comm2 = getprop("/instrumentation/comm[1]/volume");
			setprop("/instrumentation/comm[0]/volume",0);
			setprop("/instrumentation/comm[1]/volume",0);
			setprop("/instrumentation/nav[0]/audio-btn",0);
			setprop("/instrumentation/nav[1]/audio-btn",0);
			setprop("/instrumentation/adf[0]/ident-audible",0);
			setprop("/instrumentation/marker-beacon/audio-btn",0);
		}
		last_audio = getprop("/instrumentation/audio/serviceable");
	}
});

_setlistener("/instrumentation/comm[0]/volume", func {
	setprop("/instrumentation/comm[0]/display-volume",1);
	settimer(func { setprop("/instrumentation/comm[0]/display-volume",0) }, 2);
});

_setlistener("/instrumentation/comm[1]/volume", func {
	setprop("/instrumentation/comm[1]/display-volume",1);
	settimer(func { setprop("/instrumentation/comm[1]/display-volume",0) }, 2);
});

_setlistener("/instrumentation/nav[0]/volume", func {
	setprop("/instrumentation/nav[0]/display-volume",1);
	settimer(func { setprop("/instrumentation/nav[0]/display-volume",0) }, 2);
});

_setlistener("/instrumentation/nav[1]/volume", func {
	setprop("/instrumentation/nav[1]/display-volume",1);
	settimer(func { setprop("/instrumentation/nav[1]/display-volume",0) }, 2);
});




















