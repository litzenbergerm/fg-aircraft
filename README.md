# fg-aircraft
Collection of useful components for aircraft models under the Flightgear flight simulator.

Root folder 'aircraft-name' needs to be replaced by the actual aircraft name, where the component will be integreated. 

Path's in the XML and .nas source files need to be updated: 'aircraft-name' needs to be changed to your correct aircraft path!

Animated headset 
----------------
/Models/headset

Animated headset with a cord, that swings with pilot acceleration forces. The headset is expected to be hung up at the cockpit ceiling of the aircraft model.

Helionix avionics suite
----------------
/Models/instruments/EUcopter-mfd-c

Airbus helicopters Helionix (for H145 model) and Meghas (for EC145) avionics suite, implemented in the Canvas framework. MFD bezel 3D model is included. Up to four screens are supported by the code.

The mfd0.xml, mfd1.xml, .. model files must be included in your aircraft model xml files.

The Nasal code either helionix.nas or meghas.nas must be included in your aircraft *-set.xml file under the ```<nasal>``` section, in the <helionix> namespace. 

```
<nasal>
  <helionix>
      <file>Aircraft/aircraft-name/Models/instruments/EUcopter-mfd-c/Nasal/helionix.nas</file> 
  </helionix>
  ...
</nasal>
```

The instruments settings must be defined in your in your aircraft *-set.xml file, for all 4 possible MFD screens, as :

```
    <instrumentation>
            <mfd n="0">
              <mode-list type="string">init,fnd</mode-list>
              <nav-source type="string">NAV1</nav-source>
              <bearing-source type="string" n="0">NAV1</bearing-source>
              <bearing-source type="string" n="1">ADF1</bearing-source>
              <pwr-sw-pos type="bool">1</pwr-sw-pos> <!--initial position of the screens power switch-->
              <supply>/systems/electrical/outputs/avio[1]</supply>
            </mfd>  
            <mfd n="1">
              <!-- add 'dmap' to mode-list for FG1000 digital map mode -->
              <mode-list type="string">init,vmd,navd,dmap</mode-list>
              <nav-source type="string">NAV2</nav-source>
              <bearing-source type="string" n="0">NAV1</bearing-source>
              <bearing-source type="string" n="1">ADF1</bearing-source>
              <pwr-sw-pos type="bool">1</pwr-sw-pos> <!--initial position of the screens power switch-->
              <supply>/systems/electrical/outputs/avio[0]</supply>
              <dmap-zoom-level>10</dmap-zoom-level>
            </mfd>  
            <mfd n="2">
              <mode-list type="string">init,fnd,dmap,efb</mode-list>
              <nav-source type="string">NAV2</nav-source>
              <bearing-source type="string" n="0">NAV2</bearing-source>
              <bearing-source type="string" n="1">ADF1</bearing-source>
              <pwr-sw-pos type="bool">1</pwr-sw-pos> <!--initial position of the screens power switch-->
              <supply>/systems/electrical/outputs/avio[1]</supply>
            </mfd>  
            <mfd n="3">
              <mode-list type="string">stbyai</mode-list>
              <pwr-sw-pos type="bool">1</pwr-sw-pos> <!--initial position of the screens power switch-->
              <supply>/systems/electrical/outputs/stbyhor</supply>
            </mfd>  
    </instrumentation>

```

  
Garmin G5-like avionics suite
----------------
/Models/instruments/g5-mfd

G5 like avionics suite, implemented in the Canvas framework. MFD bezel 3D model is included.

The mfd0.xml, mfd1.xml, .. model files must be included in your aircraft model xml files.

The Nasal code either mfd-main.nas must be included in your aircraft -set.xml file under the <nasal> section, in the <helionix> namespace. 
 

Helicopter main rotor
----------------
/Models/mainrotor

Fully animated helicopters main rotor 
