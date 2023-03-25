
var ALTFACTOR = 30.83/20.0; # px/ft
var ALTFACTOR2 = 1.5467;
var IASFACT = 2108/200;     # px/kts 

if (!defined("Rosenumerals"))
   io.include(HELIONIXPATH ~ "Nasal/fnd_func.nas");

var clamp100 = func (x) {
    if (x<0) x*=-1;
    return math.mod( int((x)/100)*100, 1000);
}; 

# roll 0 to 20ft for 80 to 100ft indicated
var roll100 = func (x) {
    if (x<0) return 0; 
    a = math.mod(x, 100);
    if (a>80) {return a-80}; return 0;
}; 
   
page_setup["pfd"] = func (i) {
  
  p = mfd[i].add_page("pfd", HELIONIXPATH~"svg/pfd.svg");
  generateAltLadder(p, pitch=ALTFACTOR*100, post500=1, post100=1);
  
  # move speed and fli tapes, animate ai elements
  # ============================

  p.add_trans_grp(["horizon","horizonNums"], "y-shift", {sensor: adc.pitch, scale:11.57, max:90, min:-90});
  p.add_trans_grp(["horizon","horizonNums"], "rotation", {sensor: adc.roll, scale:-1});
  
  # std.turn bank indizes
  p.add_trans("stdIdxL", "rotation", {sensor: adc.ias, scale:-1, funcof:"std_rate_bank"});
  p.add_trans("stdIdxR", "rotation", {sensor: adc.ias, scale:1, funcof:"std_rate_bank"});
  p.add_trans_grp(["stdIdxL","stdIdxR"], "rotation", {sensor:adc.roll, scale:-1});
  
  #alt. ladder
  p.add_trans_grp(["Alt_Group","altBug"], "y-shift", {sensor: adc.alt, scale: ALTFACTOR2 });
  p.add_trans("altBug", "y-shift", {sensor: adc.aptargetAlt, scale: -ALTFACTOR2 });
  
  #alt. rolling ones & tens feet numerals
  p.add_trans("altroll", "y-shift", {sensor: adc.alt, scale: 4.76, mod: 100 });
  
  #alt. rolling hundreth feet numerals
  p.add_trans("altrollH", "y-shift", {sensor: adc.alt, scale:0.933, funcof:"clamp100"});
  p.add_trans("altrollH", "y-shift", {sensor: adc.alt, scale:93.3/20, min:0, max:20, funcof:"roll100" });
  p.add_cond("altMinus", {sensor:adc.alt, lessthan:0} );
  p.add_cond("altnumT", {sensor:adc.alt, greaterthan:999} );
  
  p.add_trans("speedtape", "y-shift", {sensor: adc.ias, scale:IASFACT, min:-20, max:350 });
  p.add_direct("rollPointer", adc.roll, func(o,c) o.setRotation(-adc.roll.val*D2R,c[0],c[1]) );
  p.add_trans("slipSkid", "x-shift", {sensor: adc.slipskid, scale:-25, min:-3, max:3 });

  p.add_text("iasnum", {sensor: adc.ias, format: "%4.0f" });
  p.add_text("gsnum", {sensor: adc.gs, format: "%3.0f" });
  p.add_text("altnumT", {sensor: adc.alt, format: "%2i", scale:0.001, trunc:"int"});
  p.add_text("altTarget", {sensor: adc.aptargetAlt, format: "%4i"});
  
  p.add_text("qnh", {sensor: adc.qnhDisplay });
  
  p.add_cond("qnhHighl",{sensor:adc.mfdknob[i], equals:"qnh"});
  p.add_cond("altHighl",{sensor:adc.mfdknob[i], equals:"alt"});
  

}; # func 
