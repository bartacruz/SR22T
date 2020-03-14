var mapsLonMinus = func {
	var lon = getLon();
	lon = lon - 1;
	if(lon<-180){
		lon = 180;
	}
	setprop("/controls/books/maps/coords/lon",lon);
}

var mapsLonMaxus = func {
	var lon = getLon();
	lon = lon + 1;
	if(lon>180){
		lon = -180;
	}
	setprop("/controls/books/maps/coords/lon",lon);
}

var mapsLatMinus = func {
	var lat = getLat();
	lat = lat - 1;
	if(lat<-180){
		lay = 180;
	}
	setprop("/controls/books/maps/coords/lat",lat);
}

var mapsLatMaxus = func {
	var lat = getLat();
	lat = lat + 1;
	if(lat>180){
		lay = -180;
	}
	setprop("/controls/books/maps/coords/lat",lat);
}

var getLon = func {
	var result = getprop("/controls/books/maps/coords/lon");
	if(result < -180){
		result = getprop("/position/longitude-deg");
		setprop("/controls/books/maps/coords/lon",result);
	}
	return result;
}

var getLat = func {
	var result = getprop("/controls/books/maps/coords/lat");
	if(result < -180){
		result = getprop("/position/latitude-deg");
		setprop("/controls/books/maps/coords/lat",result);
	}
	return result;
}

var update_map = func {
	var lon = getLon();
	var lat = getLat();
	
	##calcul et chargement repris du zkv1000
	
	var map = sprintf("%s%03i%s%02i",
        (lon > 0)? "e" : "w",
        (lon > 0)? lon : (abs(lon) + 1),
        (lat > 0)? "n" : "s",
        (lat > 0)? lat : (abs(lat) + 1)
    );
	
	if (io.stat(mapsAbsolutePath ~ "/terrain/" ~ map ~ ".png") != nil) {
		setprop("/controls/books/maps/terrain-path", mapsRelativePath ~ "/terrain/" ~ map ~ ".png");
	}else{
		setprop("/controls/books/maps/terrain-path","");
	}
	
}

setlistener("/controls/books/maps/coords/lon",update_map);
setlistener("/controls/books/maps/coords/lat",update_map);
setlistener("/controls/books/maps/visible",update_map);

var mapsAbsolutePath = "";
var mapsRelativePath = "";

var init_map = func {
    var maps = "/zkv1000/maps";
    var root_l = common_l = common_c = 0;

    var home = string.normpath(getprop("/sim/fg-home"));
    var home_s = size(home);
    
    var root = string.normpath(getprop("/sim/fg-root"));
    var root_s = size(root);
    
    for (var i = 0; i < root_s; i += 1) 
        if (root[i] == `/`)
            root_l += 1;
    
    for (var i = 0; i < root_s and i < home_s; i += 1) {
        (home[i] == root[i]) or break;
        common_c += 1;
        if (home[i] == `/`) common_l += 1;
    }
    
    mapsRelativePath = "../../../../../../../";
    for (var i = 0; i < root_l - common_l; i += 1)
        mapsRelativePath ~= "../";
		
	mapsRelativePath ~= substr(home, common_c, home_s) ~ maps;
    mapsAbsolutePath = home ~ maps;
}

setlistener("sim/signals/fdm-initialized",init_map);

var init_coords = func {
	setprop("/controls/books/maps/coords/lon",-500);
	setprop("/controls/books/maps/coords/lat",-500);
}