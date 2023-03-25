# ==============================================================================
# Original Boeing 747-400 pfd by Gijs de Rooy
# Modified for 737-800 by Michael Soitanen
# Modified for EC145 by litzi
# ==============================================================================

# add sensor elements to air data computer. to avoid repeated readout of the same 
# property values we define sensors (originally seen in Thorstens Zivko Edge)
#  
# properties that change very frequently will be polled 
# to avoid listener overhead (see 'timer:') or
# which are tied properties and don't work with listeners
# the vital parameters are update with 30Hz
# =========================

adc["roll"] = Sensor.new({prop:"orientation/roll-deg", thres:0.1, timer:1/30, name:"proll"});
adc["pitch"] = Sensor.new({prop: "orientation/pitch-deg", thres:0.1, timer:1/30});
adc["ias"] = Sensor.new({prop: "instrumentation/airspeed-indicator/indicated-speed-kt", thres:0.1, timer:1/30});
adc["tas"] = Sensor.new({prop: "velocities/airspeed-kt", thres:0.1,timer:FAST});
adc["gs"] = Sensor.new({prop: "velocities/groundspeed-kt", thres:0.1,timer:FAST});

adc["iasTrend"] = Sensor.new({prop: "velocities/airspeed-delta-kt-sec", thres: 0.5, timer: FAST});
adc["alt"] = Sensor.new({prop: "instrumentation/altimeter/indicated-altitude-ft", thres: 0.1, name:"alt", timer:1/30});
adc["vs"] = Sensor.new({prop: "velocities/vertical-speed-fps", timer: 1/30, thres:0.01});
adc["agl"] = Sensor.new({prop: "position/altitude-agl-ft", thres:0.1, timer: FAST});
adc["heading"] = Sensor.new({prop: "orientation/heading-magnetic-deg", thres:0.1, timer: 1/30});

adc["qnh"] = Sensor.new({prop: "instrumentation/altimeter/setting-inhg"});
adc["slipskid"] = Sensor.new({prop: "instrumentation/slip-skid-ball/indicated-slip-skid", timer:FAST, thres:0.05});
adc["qnhDisplay"] = Sensor.new( {function: func {(adc.qnh.val == 29.92) ? "STD" : sprintf("%4.0f", adc.qnh.val*33.8639)}, timer: SLOW, type:"STRING" }); 

adc["winddir"] = Sensor.new({prop: "/environment/wind-from-heading-deg", timer: SLOW, thres:1} );
adc["relwinddir"] = Sensor.new({function: func {adc.winddir.val-adc.heading.val}, timer: SLOW, thres:1});
adc["windspeed"] = Sensor.new({prop: "/environment/wind-speed-kt", timer: SLOW, thres:1} );
adc["oat"] = Sensor.new({prop: "environment/temperature-degc", timer: SLOW, thres:0.5 });
adc["vsiNumVis"] = Sensor.new({ function: func { (adc.vs.val > 0) * -35 } });

## Navigation

adc["navsrc"] = {};
adc["bearsrc0"] = {};
adc["bearsrc1"] = {};
adc["mfdknob"] = {};

#activate only for 2 screens.

foreach(var j; [0,1]) { 
   adc["navsrc"][j]   = Sensor.new({prop: "instrumentation/mfd["~j~"]/nav-source", type:"STRING", timer:SLOW});
   adc["bearsrc0"][j] = Sensor.new({prop: "instrumentation/mfd["~j~"]/bearing-source[0]", type:"STRING"});
   adc["bearsrc1"][j] = Sensor.new({prop: "instrumentation/mfd["~j~"]/bearing-source[1]", type:"STRING"});
   adc["mfdknob"][j]  = Sensor.new({prop: "instrumentation/mfd["~j~"]/toggleknob", type:"STRING", timer:SLOW });
}

adc["comm0frq"] =  Sensor.new({prop: "instrumentation/comm[0]/frequencies/selected-mhz"});
adc["comm0stb"] =  Sensor.new({prop: "instrumentation/comm[0]/frequencies/standby-mhz"});

adc["nav0frq"] =  Sensor.new({prop: "instrumentation/nav[0]/frequencies/selected-mhz"});
adc["nav0stb"] =  Sensor.new({prop: "instrumentation/nav[0]/frequencies/standby-mhz"});
adc["nav0id"] = Sensor.new({prop: "instrumentation/nav[0]/nav-id",type:"STRING", timer:SLOW});
adc["nav0bear"] = Sensor.new({prop: "instrumentation/nav[0]/heading-deg", thres:0.01}); 
adc["nav0crs"] = Sensor.new({prop: "instrumentation/nav[0]/radials/selected-deg", timer:SLOW });
adc["nav0inrange"] = Sensor.new({prop: "instrumentation/nav[0]/in-range", type:"BOOL", timer:SLOW});
adc["nav0hasgs"] = Sensor.new({prop: "instrumentation/nav[0]/has-gs", type:"BOOL", timer:SLOW});
adc["nav0gsinrange"] = Sensor.new({prop: "instrumentation/nav[0]/gs-in-range", type:"BOOL", timer:SLOW});
adc["nav0gsdef"] = Sensor.new({prop: "instrumentation/nav[0]/gs-needle-deflection-norm", thres:0.01, timer:FAST});
adc["nav0from"] = Sensor.new({prop: "instrumentation/nav[0]/from-flag",timer:SLOW});
adc["nav0defl"] = Sensor.new({prop: "instrumentation/nav[0]/heading-needle-deflection", thres:0.01, timer:FAST});
adc["nav0dmeinrange"] = Sensor.new({prop: "instrumentation/nav[0]/dme-in-range", type:"BOOL", timer:SLOW});
adc["nav0dist"] = Sensor.new({prop: "instrumentation/nav[0]/nav-distance",timer:SLOW});
adc["nav0ttg"] = Sensor.new({prop: "instrumentation/nav[0]/time-to-intercept-sec",timer:SLOW});

adc["comm1frq"] =  Sensor.new({prop: "instrumentation/comm[1]/frequencies/selected-mhz"});
adc["comm1stb"] =  Sensor.new({prop: "instrumentation/comm[1]/frequencies/standby-mhz"});

adc["nav1frq"] =  Sensor.new({prop: "instrumentation/nav[1]/frequencies/selected-mhz", timer:SLOW});
adc["nav1stb"] =  Sensor.new({prop: "instrumentation/nav[1]/frequencies/standby-mhz", timer:SLOW});
adc["nav1id"] = Sensor.new({prop: "instrumentation/nav[1]/nav-id",type:"STRING", timer:SLOW});
adc["nav1bear"] = Sensor.new({prop: "instrumentation/nav[1]/heading-deg", thres:0.01}); 
adc["nav1crs"] = Sensor.new({prop: "instrumentation/nav[1]/radials/selected-deg"});
adc["nav1dmeinrange"] = Sensor.new({prop: "instrumentation/nav[1]/dme-in-range", type:"BOOL",timer:SLOW});
adc["nav1inrange"] = Sensor.new({prop: "instrumentation/nav[1]/in-range", type:"BOOL",timer:SLOW});
adc["nav1hasgs"] = Sensor.new({prop: "instrumentation/nav[1]/has-gs", type:"BOOL",timer:SLOW});
adc["nav1gsinrange"] = Sensor.new({prop: "instrumentation/nav[1]/gs-in-range", type:"BOOL",timer:SLOW});
adc["nav1gsdef"] = Sensor.new({prop: "instrumentation/nav[1]/gs-needle-deflection-norm", thres:0.01, timer:FAST});
adc["nav1from"] = Sensor.new({prop: "instrumentation/nav[1]/from-flag",timer:SLOW});
adc["nav1defl"] = Sensor.new({prop: "instrumentation/nav[1]/heading-needle-deflection", thres:0.01, timer:FAST});
adc["nav1dist"] = Sensor.new({prop: "instrumentation/nav[1]/nav-distance", timer:SLOW});
adc["nav1ttg"] = Sensor.new({prop: "instrumentation/nav[1]/time-to-intercept-sec", timer:SLOW});

adc["ilsin"] =  Sensor.new({prop: "instrumentation/marker-beacon/inner", timer:0.1});
adc["ilsmid"] =  Sensor.new({prop: "instrumentation/marker-beacon/middle", timer:0.1});
adc["ilsout"] =  Sensor.new({prop: "instrumentation/marker-beacon/outer", timer:0.1});
adc["ilsmarker"] = Sensor.new({function: func { (adc.ilsin.val or adc.ilsmid.val or adc.ilsout.val) }, timer: 0.2 });

adc["adf0frq"] =   Sensor.new({prop: "instrumentation/adf[0]/frequencies/selected-khz", timer:SLOW});
adc["adf0inrange"] = Sensor.new({prop:"instrumentation/adf[0]/in-range", type:"BOOL", timer:SLOW});
adc["adf0bear"] = Sensor.new({function: func {return getprop("instrumentation/adf[0]/indicated-bearing-deg") + adc.heading.val;}, timer:FAST });

adc["gpslat"] = Sensor.new({prop: "position/latitude-deg",timer:SLOW});
adc["gpslon"] = Sensor.new({prop: "position/longitude-deg",timer:SLOW});
adc["gpsgs"] = Sensor.new({prop: "instrumentation/gps/indicated-ground-speed-kt",timer:SLOW});
adc["gpstrk"] = Sensor.new({prop: "instrumentation/gps/indicated-track-magnetic-deg",timer:FAST});

## Navigation FMS

adc["fmsinrange"] = Sensor.new({"prop": "instrumentation/gps/wp/wp[1]/valid", "type":"BOOL","timer":SLOW});
adc["fmsfrom"] = Sensor.new({"prop": "instrumentation/gps/wp/wp[1]/from-flag", "type":"BOOL","timer":SLOW});
adc["fmscrs"] = Sensor.new({"prop": "instrumentation/gps/wp/wp[1]/desired-course-deg","timer":SLOW});
adc["fmstoid"] = Sensor.new({"prop": "instrumentation/gps/wp/wp[1]/ID","type":"STRING","timer":SLOW});
adc["fmsfromid"] = Sensor.new({"prop": "instrumentation/gps/wp/wp[0]/ID","type":"STRING","timer":SLOW});
adc["fmsbear"] = Sensor.new({"prop": "instrumentation/gps/wp/wp[1]/bearing-mag-deg","timer":SLOW});
adc["fmsdist"] = Sensor.new({"prop": "instrumentation/gps/wp/wp[1]/distance-nm","timer":SLOW});
adc["fmsdefl"] = Sensor.new({"prop": "instrumentation/gps/wp/wp[1]/course-error-nm","timer":SLOW});
adc["fmsttg"] = Sensor.new({"prop": "instrumentation/gps/wp/wp[1]/TTW-sec","timer":SLOW});

adc["gpsLatNS"] = Sensor.new({function: func {adc.gpslat.val>0 ? "N" : "S"}, timer:SLOW, type:"STRING"});
adc["gpsLonWE"] = Sensor.new({function: func {adc.gpslon.val>0 ? "E" : "W"}, timer:SLOW, type:"STRING"});

## Autopilot

adc["headbug"] = Sensor.new({prop: "autopilot/settings/heading-bug-deg", timer:FAST});
adc["aptargetAlt"] = Sensor.new({prop: "autopilot/settings/target-altitude-ft", timer:FAST});
adc["aptargetSpeed"] = Sensor.new({prop: "autopilot/settings/target-speed-kt", timer:FAST});
adc["aptargetRoc"] = Sensor.new({prop: "autopilot/internal/target-climb-rate-fps", timer:FAST});
adc["aptargetAgl"] = Sensor.new({prop: "autopilot/settings/target-agl-ft", timer:FAST});

adc["aproll"] = Sensor.new({prop: "autopilot/locks/heading", type: "STRING", timer:SLOW });
adc["apalt"] = Sensor.new({prop: "autopilot/locks/altitude", type: "STRING", timer:SLOW });
adc["aprollarm"] = Sensor.new({prop: "autopilot/locks/heading-arm", type: "STRING", timer:SLOW});
adc["apaltarm"] = Sensor.new({prop: "autopilot/locks/altitude-arm", type: "STRING", timer:SLOW});
adc["apspeed"] = Sensor.new({prop: "autopilot/locks/speed", type: "STRING", timer:SLOW});
adc["apcoll"] = Sensor.new({prop: "autopilot/internal/use-collective-for-alt", timer:SLOW});
adc["apnavsrc"] = Sensor.new({prop: "instrumentation/efis/fnd/nav-source", timer:SLOW, type: "STRING"});
adc["vsBugVis"] = Sensor.new({function: func { (adc.apalt.val == "vertical-speed-hold" or adc.apalt.val == "altitude-hold") }, timer: SLOW });
adc["aglTargetVis"] = Sensor.new({function: func { (adc.apalt.val == "agl-hold" or adc.apaltarm.val == "agl-hold") } });
adc["altTargetVis"] = Sensor.new({function: func { (adc.apalt.val == "altitude-hold" or adc.apaltarm.val == "altitude-hold") } });



