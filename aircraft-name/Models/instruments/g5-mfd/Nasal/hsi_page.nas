# ==============================================================================
# Original Boeing 747-400 pfd by Gijs de Rooy
# Modified for 737-800 by Michael Soitanen
# Modified for EC145 by litzi
# ==============================================================================

var ROSER = 125;
var ALTFACTOR = (651-464)/400;  
var FPS2FPM = 60;
var SHIFT_THRES = 0.5;
var ROT_THRES = 0.1;    

# include some helper functions for the FND page if not already loaded
if (!defined("FND_FUNC_LOADED"))
   io.include(HELIONIXPATH ~ "Nasal/fnd_func.nas");
   
page_setup["hsi"] = func (i) {
  
  p = mfd[i].add_page("hsi", HELIONIXPATH~"svg/hsi.svg");

  # Bearing Needles
  # ============================

  p.add_trans("trackNeedle", "rotation", {sensor: adc.gpstrk });
  p.add_trans("trackNeedle", "rotation", {sensor: adc.heading, scale: -1});
  p.add_trans("bear1Needle", "rotation", {sensor: adc.add( {function: func navSrcBear(adc.bearsrc0[i].val), timer:FAST}) });
  p.add_cond("bear1Needle", {sensor: adc.add( {function: func navSrcInrange(adc.bearsrc0[i].val), timer:SLOW}) });

  # course and CDI 
  # ============================

  p.add_trans("Rose_Group", "rotation", {sensor: adc.heading, scale: -1});
  #workaround to rotate head bug in sync with rose group
  p.add_trans("hdgBug", "rotation", {sensor: adc.headbug});
  p.add_trans("hdgBug", "rotation", {sensor: adc.heading, scale: -1});
  p.add_trans_grp(["cdiNeedle", ], "x-shift", {sensor: adc.add( {function: func navSrcDefl(adc.navsrc[i].val), timer:FAST }), scale: 7.5 });
  p.add_cond_grp(["cdiNeedle", "toFrom", "DmeGrp"], {sensor: adc.add( {function: func navSrcInrange(adc.navsrc[i].val), timer: SLOW }) });
  p.add_trans("toFrom", "rotation", {sensor: adc.add( {function: func { (adc.navsrc[i].val == "NAV1") ? adc.nav0from.val : adc.nav1from.val }, timer: SLOW}), scale:180}); 
  p.add_trans("Cdi_Group", "rotation", {sensor: adc.add( {function: func navSrcCrs(adc.navsrc[i].val), timer:FAST}) });

  # lots of text
  # for nav aids to update
  # ============================
  p.add_text("hdgNum", {sensor: adc.heading, format: "%03.0f°"});
  p.add_text("hdgBugNum", {sensor: adc.headbug, format: "%03.0f°"});
  p.add_text("crsNum", {sensor: adc.add( {function: func navSrcCrs(adc.navsrc[i].val), timer:SLOW}) , format: "%03.0f°"});
  p.add_text("DmeNum", {sensor: adc.add( {function: func DME_format( navSrcDist(adc.navsrc[i].val) ), timer:SLOW, type:"STRING"}) });
  
  p.add_cond("crsHighl",{sensor:adc.mfdknob[i], equals:"obs"});
  p.add_cond("hdgHighl",{sensor:adc.mfdknob[i], equals:"hdg"});

  # translate rose numerals in circular orbit
  # around center of compass rose
  # ============================

  GenerateRosenumerals(p, ROSER);
  
}; # func 
