# This is a generic approach to canvas MFD's

# aircraft-name must be replaced by correct path!

var HELIONIXPATH = "Aircraft/aircraft-name/Models/instruments/g5-mfd/";

io.include(HELIONIXPATH ~ "Nasal/common.nas");
io.include(HELIONIXPATH ~ "Nasal/mfd_control.nas");

# list of allowed of modules (=pages) names
var MODULES = ["pfd","hsi"];

# load the page code
foreach (var x; MODULES) 
     io.include(HELIONIXPATH~"Nasal/"~x~"_page.nas");
     
mfd_add([1024, 1024], [1024, 1024]); # mfd0 plt PFD
mfd_add([1024, 1024], [1024, 1024]); # mfd1 plt HSI

# init the startup
setlistener("sim/signals/fdm-initialized", func {
  
    print("Initializing MFDs ...");
    
    for (var i=0; i<size(mfd); i += 1) {
      
        # setup all pages on each MFD
        mfd[i].display.addPlacement({"node": "xmfd"~i~"screen"});
        mfd[i].pages = split(",", getprop("/instrumentation/mfd["~i~"]/mode-list"));;
        
        foreach (var pg; mfd[i].pages) {
            # put page p on mfd index i
            if (isin(pg, MODULES) > -1) {
                  page_setup[pg](i);
                  print(i,".",pg);
                  
            }
        }
            
        # start the button and modes handling            
        if (mfdctrl[i] != nil) {
           mfdctrl[i] = EUcoptermfd.new(i);
           mfdctrl[i].run(0.2);
        }           
    }  
    
    # force a refresh of all sensors 
    # to init the screen animations
    adc._refresh_();
    if (USE_CENTRAL_UPDATE_LOOP)
       adc.initUpdates(0);
        
    print(" ... Done.");
});


setlistener("sim/signals/reinit", func {
  adc._del_();
});

# in debug update callback statistics every 5 sec
if (DEBUG) {
  var dtimer = maketimer(5, func {
     adc._benchmark_();    
     debugloop += 1;
  });
  dtimer.start();
};
