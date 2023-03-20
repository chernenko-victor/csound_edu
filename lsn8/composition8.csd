<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

seed 0

;====================================================================
;=================			frequencies 		============================
;====================================================================

gkFrqTranform[]				fillarray	1, 15/8, 4/3, 3/2, 9/8, 5/4, 5/3, 2

gkFrq1[][] init  5, 5
gkFrq1 fillarray 0.25, 0.175, 0.2, 0.2, 0.175,
																	0.35, 0.13, 0.175, 0.175, 0.17,
																	0.20, 0.175, 0.2, 0.25, 0.175,
																	0.25, 0.175, 0.2, 0.2, 0.175,
																	0.25, 0.17, 0.25, 0.2, 0.13

gkFrq2[][] init  5, 5
gkFrq2 fillarray 0.2, 0.175, 0.25, 0.2, 0.175,
																	0.175, 0.13, 0.35, 0.175, 0.17,
																	0.2, 0.175, 0.20, 0.25, 0.175,
																	0.2, 0.175, 0.25, 0.2, 0.175,
																	0.25, 0.17, 0.25, 0.2, 0.13
																	
gkFrq3[][] init  5, 5
gkFrq3 fillarray	0.175, 0.2, 0.2, 0.175, 0.25,
																	0.13, 0.175, 0.175, 0.17, 0.35,
																	0.175, 0.2, 0.25, 0.175, 0.20,
																	0.175, 0.2, 0.2, 0.175, 0.25,
																	0.17, 0.25, 0.2, 0.13, 0.25
;====================================================================
;=================			durations 		==============================
;====================================================================
												
gkDurTransform[]				fillarray	1,	2,	4,	6,	8,	12,	16


;=================		polyphony-like		===============================
gkDur1[][] init 7, 7
gkDur1	fillarray	0.4,	0.5,	0.1,	0,		0,		0,		0,
							0.3,	0.3,	0.3,	0.1,	0,		0,		0,
							0,		0.3,	0.3,	0.3,	0.1,	0,		0,
							0,		0,		0.3,	0.3,	0.3,	0.1,	0,
							0,		0,		0,		0.3,	0.3,	0.3,	0.1,
							0,		0,		0,		0.1,	0.3,	0.3,	0.3,
							0,		0,		0,		0,		0.1,	0.5,	0.4
							

gkDur2[][] init 7, 7
gkDur2	fillarray	0.3,	0.4,	0.1,		0.1,		0.1,		0,		0,
							0.3,	0.2,	0.3,		0.1,		0.1,		0,		0,
							0.1,	0.3,	0.2,		0.3,		0.1,		0,		0,
							0,		0.1,	0.3,		0.2,		0.3,		0.1,	0,
							0,		0,		0.1,		0.3,		0.2,		0.3,	0.1,
							0,		0,		0.1,		0.1,		0.3,		0.2,	0.3,
							0,		0,		0.1,		0.1,		0.1,		0.4,	0.3									

gkDur3[][] init 7, 7
gkDur3	fillarray	0.4,	0,	0.1,	0,		0,		0.5,		0,
							0.3,	0.3,	0,	0.1,	0,		0,		0.3,
							0.3,		0.3,	0,	0.3,	0.1,	0,		0,
							0.3,		0,		0.3,	0.3,	0,	0.1,	0,
							0,		0.3,		0,		0.3,	0.3,	0,	0.1,
							0.3,		0,		0,		0.1,	0.3,	0,	0.3,
							0,		0,		0.5,		0,		0.1,	0,	0.4
							
;====================================================================
;=================					aux	 		==============================
;====================================================================
gaSendRvb init 0


opcode Markovk, k, k[][]k
	kMarkovTable[][], kPrevEl xin
	kRandom    random     0, 1
	kNextEl    =          0
	kAccum     =          kMarkovTable[kPrevEl][kNextEl]
 until kAccum >= kRandom do
		kNextEl    +=         1
		kAccum     +=         kMarkovTable[kPrevEl][kNextEl]
 enduntil
 xout       kNextEl
endop

instr 203 ;additive one
	iDur = p3
	iFrq = p4
	iAmp = p5
	
	iAttDur random 0.01*iDur, 0.1*iDur
	iDecDur	random 0.01*iDur, 0.05*iDur
	iRelDur	random 0.05*iDur, 0.3*iDur
	
	kRangeMin init .01
	kRangeMax init .3
	kCpsMin init 3
	kCpsMax init 4
	
	kSliderRvbLvl	init 	0.5
	
	kAmpEnv adsr iAttDur, iDecDur, .5, iRelDur
	
	kSliderRvbLvl invalue "slider_rvb_lvl"
	outvalue	"display_slider_rvb_lvl", kSliderRvbLvl
	
	kFrqMod 	random .5, 2	
	kPartialAmp  = rspline(kRangeMin, kRangeMax, kCpsMin, kCpsMax)
	kFrqOsc   = poscil(kPartialAmp, kFrqMod, 1)
	aOsc     =  poscil(iAmp+kPartialAmp, iFrq+kFrqOsc, 1)
		
	out 	aOsc*kAmpEnv
	gaSendRvb  =        gaSendRvb + aOsc*kAmpEnv*kSliderRvbLvl
endin

instr 204 ;additive summ
	iDur = p3
	iNoteCount = 0
	iFrqBase = p6
	
	until iNoteCount == 8 do
		iBaseAmp       random     .1, .5
		event_i "i", 203, 0, iDur, iFrqBase*(iNoteCount+1), iBaseAmp/(iNoteCount+1)/8
		iNoteCount += 1 ;increase note count
	enduntil
endin


instr 300 ; reverb
	kRvbFeedbLvl	init 	0.5

	kRvbFeedbLvl invalue "rvb_feedb_lvl"
	outvalue	"display_rvb_feedb_lvl", kRvbFeedbLvl
	

	aRvbL,aRvbR reverbsc gaSendRvb,gaSendRvb,	kRvbFeedbLvl,	7000
   outs     aRvbL,aRvbR
   clear   gaSendRvb
endin

instr part
	iTotalDur = p3
	;kDur				init 	.5
	kDurMin			init 	.25
	kPrevElIndexDur	init	2
	kInstrNum 	init		204		
	kMarkovTblCurerent[][] init  5, 5
	kMarkovTblCurerentDur[][] init 7, 7
	kFrqSysNum		init 	0
	kDurSysNum		init 	0
	kFlag		init 	1 
	
	if kFlag == 1 then
		kFlag = 0
		kFrqBase	random 	220, 880
		kPrevElIndexRnd	random 	0.0, 3.5  
		kPrevElIndex 	=		ceil(kPrevElIndexRnd)
		kMarkovTblCurerent = gkFrq1
		kMarkovTblCurerentDur = gkDur1
		kDur = kDurMin*(gkDurTransform[kPrevElIndexDur])
		outvalue "menu0", kFrqSysNum
		outvalue "menu_dur", kDurSysNum
	endif
	
	kFrqSysNum invalue "menu0"
	kDurSysNum invalue "menu_dur"
	
	kTrig			metro	1/kDur
	;puts SFrqSys, kTrig
	
	;kTrig invalue "channel name"
	
	if kTrig == 1 then
		;outvalue "display2", kFrqSysNum
		
		if kFrqSysNum == 1 then
			kMarkovTblCurerent = gkFrq2
		elseif kFrqSysNum == 2 then
			kMarkovTblCurerent = gkFrq3
		else
			kMarkovTblCurerent = gkFrq1
		endif
		
		if kDurSysNum == 1 then
			kMarkovTblCurerentDur = gkDur2
		elseif kDurSysNum == 2 then
			kMarkovTblCurerentDur = gkDur3
		else
			kMarkovTblCurerentDur = gkDur1
		endif
		
		kDur = kDurMin*(gkDurTransform[kPrevElIndexDur])
		event  	"i", 	kInstrNum,	0, kDur*0.8, 0, 0, kFrqBase*(gkFrqTranform[kPrevElIndex])
		kPrevElIndex  		Markovk    kMarkovTblCurerent, kPrevElIndex
		kPrevElIndexDur  Markovk    kMarkovTblCurerentDur, kPrevElIndexDur
	endif
endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1

i "part" 0 40

; reverb instrument
i 		300				0 		60000
</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject version="2" type="BSBDropdown">
  <objectName>menu0</objectName>
  <x>120</x>
  <y>10</y>
  <width>180</width>
  <height>30</height>
  <uuid>{01767462-9b37-4f6e-b157-6100b3c4190a}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <bsbDropdownItemList>
   <bsbDropdownItem>
    <name>stable</name>
    <value>0</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name>semi-stable</name>
    <value>1</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name>unstable</name>
    <value>2</value>
    <stringvalue/>
   </bsbDropdownItem>
  </bsbDropdownItemList>
  <selectedIndex>0</selectedIndex>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>10</x>
  <y>10</y>
  <width>109</width>
  <height>31</height>
  <uuid>{eecb5630-a13f-4308-90ca-e94504fea4bf}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Frq system</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>18</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>false</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBDropdown">
  <objectName>menu_dur</objectName>
  <x>120</x>
  <y>54</y>
  <width>180</width>
  <height>30</height>
  <uuid>{567b237f-4f0f-473f-a48a-f61f4363b0a1}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <bsbDropdownItemList>
   <bsbDropdownItem>
    <name>old-polyph-like</name>
    <value>0</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name>barocco</name>
    <value>1</value>
    <stringvalue/>
   </bsbDropdownItem>
   <bsbDropdownItem>
    <name>modern</name>
    <value>2</value>
    <stringvalue/>
   </bsbDropdownItem>
  </bsbDropdownItemList>
  <selectedIndex>1</selectedIndex>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>10</x>
  <y>54</y>
  <width>109</width>
  <height>31</height>
  <uuid>{27e20961-d776-4773-8177-399ad5ab179f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Dur system</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>18</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>false</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>slider_rvb_lvl</objectName>
  <x>175</x>
  <y>138</y>
  <width>95</width>
  <height>195</height>
  <uuid>{a0ace1e4-369f-4daf-ba3d-6ea77e1e77e4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>display_slider_rvb_lvl</objectName>
  <x>9</x>
  <y>218</y>
  <width>151</width>
  <height>50</height>
  <uuid>{d7e86050-1ed4-4d12-973d-e2b7c1d7b38f}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>0.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>18</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>true</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>9</x>
  <y>140</y>
  <width>150</width>
  <height>44</height>
  <uuid>{3392a7df-d443-4397-a9f7-2e429af050b4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Rever Wet Level</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>18</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>false</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBVSlider">
  <objectName>rvb_feedb_lvl</objectName>
  <x>450</x>
  <y>138</y>
  <width>95</width>
  <height>195</height>
  <uuid>{6181b6e4-4b48-4344-9260-534dcf854a8d}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>0.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject version="2" type="BSBDisplay">
  <objectName>display_rvb_feedb_lvl</objectName>
  <x>294</x>
  <y>216</y>
  <width>151</width>
  <height>50</height>
  <uuid>{67d10ccc-9f80-4ba6-b307-551477c4c84e}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>0.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>18</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>true</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>1</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBLabel">
  <objectName/>
  <x>293</x>
  <y>140</y>
  <width>149</width>
  <height>59</height>
  <uuid>{9f9b27b4-d4e3-4cc7-a969-5f4f7afbde5e}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <label>Rever Feedback Level</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>18</fontsize>
  <precision>3</precision>
  <color>
   <r>0</r>
   <g>0</g>
   <b>0</b>
  </color>
  <bgcolor mode="nobackground">
   <r>255</r>
   <g>255</g>
   <b>255</b>
  </bgcolor>
  <bordermode>false</bordermode>
  <borderradius>1</borderradius>
  <borderwidth>0</borderwidth>
 </bsbObject>
 <bsbObject version="2" type="BSBButton">
  <objectName>button10</objectName>
  <x>349</x>
  <y>13</y>
  <width>168</width>
  <height>65</height>
  <uuid>{78d1652d-ee59-49a0-951e-50477fc07526}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description/>
  <type>event</type>
  <pressedValue>1.00000000</pressedValue>
  <stringvalue/>
  <text>One more part</text>
  <image>/</image>
  <eventLine>i "part" 0 40</eventLine>
  <latch>false</latch>
  <latched>false</latched>
  <fontsize>14</fontsize>
 </bsbObject>
 <bsbObject version="2" type="BSBController">
  <objectName>hor11</objectName>
  <x>619</x>
  <y>191</y>
  <width>30</width>
  <height>80</height>
  <uuid>{6aeddddc-a94b-491c-9479-83eb7b6ddeb6}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <objectName2>meter11</objectName2>
  <xMin>0.00000000</xMin>
  <xMax>1.00000000</xMax>
  <yMin>0.00000000</yMin>
  <yMax>1.00000000</yMax>
  <xValue>0.00000000</xValue>
  <yValue>0.00000000</yValue>
  <type>fill</type>
  <pointsize>1</pointsize>
  <fadeSpeed>0.00000000</fadeSpeed>
  <mouseControl act="press">jump</mouseControl>
  <bordermode>noborder</bordermode>
  <borderColor>#00FF00</borderColor>
  <color>
   <r>0</r>
   <g>234</g>
   <b>0</b>
  </color>
  <randomizable mode="both" group="0">false</randomizable>
  <bgcolor>
   <r>30</r>
   <g>30</g>
   <b>30</b>
  </bgcolor>
  <bgcolormode>true</bgcolormode>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
