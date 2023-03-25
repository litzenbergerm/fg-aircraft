# mfd.nas to drive gauges of the VMD MFD #

### MFD panel control class ###

var EUcoptermfd = {
    new: func(i) {
        var m = { parents: [Timerloop.new(), EUcoptermfd] };
        m.id = i;
        m.idx = 0;
        m.pwr_state = 0;
        
        #split the modes list
        m.list = split(",", getprop("/instrumentation/mfd["~i~"]/mode-list"));
        
        #handle empty mode list, no pages return nil
        if (m.list[0] == "")
           return nil;
        
        m.l = size(m.list);
        m.supply = getprop("instrumentation/mfd["~i~"]/supply");
        m.supply = m.supply == nil ? "systems/electrical/volts" : m.supply;        
        m.pwr_sw = "instrumentation/mfd["~i~"]/pwr-sw-pos";
        m.mode = "instrumentation/mfd["~i~"]/mode";
        m.initstep = "instrumentation/mfd["~i~"]/initstep";       
        m.knob = "instrumentation/mfd["~i~"]/toggleknob";       
        m.navsrprop = "instrumentation/mfd["~i~"]/nav-source";
        m.bear0prop = "instrumentation/mfd["~i~"]/bearing-source[0]";       
        m.bear1prop = "instrumentation/mfd["~i~"]/bearing-source[1]";
        m.efbpageprop = "instrumentation/efis/efb/page";
        
        m.volt = 21; # mfd min. voltage demand (just a guess)
        setprop(m.mode, m.list[0] );
        setprop(m.navsrprop, "NAV1"); 

        setprop(m.initstep, 1 );
        return m;
        },
        
    update: func() {
      var v = getprop(me.supply);
      v = v == nil ? 0 : v;
      
         
      if (!me.pwr_state and getprop(me.pwr_sw) and v >= me.volt) {
      
        # start with the first page mode in list
        setprop(me.mode, me.list[0]);
        me.idx = 0;
        me.pwr_state = 1;        
        
      } else if (!getprop(me.pwr_sw) or v < me.volt) {
      
        me.pwr_state=0;
        setprop(me.mode, "off"); # show blank screen
        
      }
      
      # special procedure for the init screen animation
      
      if (getprop(me.mode) == "init" and me.idx==0) {         
        me.idx = 1;
        
        #show the 2nd test pattern, 1.5 sec later
        settimer(func {setprop(me.initstep,2)}, 1.5 );
        
        if (me.list[1]=="fnd") {
          # timers to show the FND AI Alignment screen
          settimer(func {setprop(me.initstep,3)}, 3.0 );
          settimer(func {me.modeprop(); },        8.0 );
          settimer(func {setprop(me.initstep,1)}, 9.0 );
        } else {
          settimer(func {me.modeprop(); },        3.0 );
          settimer(func {setprop(me.initstep,1)}, 4.0 );
        }  
      }
       
       # show/hide canvas
       foreach(var m; me.list)
        if (me.getmode() == m)   
            mfd[me.id][m].show();
        else       
            mfd[me.id][m].hide();

      },

    modeprop: func () setprop(me.mode, me.list[me.idx]),

    setmode: func (modestr) {
        i = isin(modestr, me.list); 
        if (i>=0) { me.idx=i; me.modeprop();}
        },

    getmode: func () {
        return getprop(me.mode);
        },
        
    pwr_on: func () {
        setprop(me.pwr_sw, 1);
        },
    
    pwr_off: func () {
        setprop(me.pwr_sw, 0);
        },
    
    clickon: func (n) {
        var mymode = me.getmode();
        if (me.pwr_state) {
          if (n==1) {
              if (mymode=="hsi") cycleprop(me.knob, ["hdg","obs"]);              
              if (mymode=="pfd") cycleprop(me.knob, ["qnh","alt"]);              
              }
          if (n==2) {          
              if (mymode=="hsi" and getprop(me.knob)=="hdg") { incrprop360("autopilot/settings/heading-bug-deg",n=-1) }
              if (mymode=="hsi" and getprop(me.knob)=="obs") { incrprop360("instrumentation/nav[0]/radials/selected-deg",n=-1) }
              if (mymode=="pfd" and getprop(me.knob)=="qnh") { incrprop("instrumentation/altimeter/setting-inhg",n=-0.01) }
              if (mymode=="pfd" and getprop(me.knob)=="alt") { incrprop("autopilot/settings/target-altitude-ft",n=-100) }
              }
          if (n==3) {
              if (mymode=="hsi" and getprop(me.knob)=="hdg") { incrprop360("autopilot/settings/heading-bug-deg",n=1) }
              if (mymode=="hsi" and getprop(me.knob)=="obs") { incrprop360("instrumentation/nav[0]/radials/selected-deg",n=1) }
              if (mymode=="pfd" and getprop(me.knob)=="qnh") { incrprop("instrumentation/altimeter/setting-inhg",n=0.01) }
              if (mymode=="pfd" and getprop(me.knob)=="alt") { incrprop("autopilot/settings/target-altitude-ft",n=100) }
              }
          }
     }
};
