<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

giSine    ftgen     3, 0, 2^10, 10, 1
giHarm    ftgen     4, 0, 2^12, 10, 1, 1/2, 1/3, 1/4, 1/5, 1/6, 1/7, 1/8
giNois    ftgen     5, 0, 2^12, 9, 100,1,0,  102,1/2,0,  110,1/3,0, \
                 123,1/4,0,  126,1/5,0,  131,1/6,0,  139,1/7,0,  141,1/8,0
                 
giImp  ftgen  6, 0, 4096, 10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1
giSaw  ftgen  7, 0, 4096, 10, 1,1/2,1/3,1/4,1/5,1/6,1/7,1/8,1/9,1/10
giSqu  ftgen  8, 0, 4096, 10, 1, 0, 1/3, 0, 1/5, 0, 1/7, 0, 1/9, 0
giTri  ftgen  9, 0, 4096, 10, 1, 0, -1/9, 0, 1/25, 0, -1/49, 0, 1/81, 0


instr show_widget_val
	;show widget val in console

  iPrdFft init .5
  iWsiz init 1024
	kFreq invalue "slider0"
	
	kTrig metro 1/2
	printf "slider0 value = %f", kTrig, kFreq 
	
	outvalue "display1", kFreq
	
	aOut	oscil .5, 440.*kFreq
	outs aOut, aOut
	
	dispfft aOut, iPrdFft, iWsiz
endin


instr wavwtable_show
	;show widget val in console

  iPrdFft init .5
  iWsiz init 1024
  iTblNum = p4
	kFreq invalue "slider0"
	
	kTrig metro 1/2
	printf "slider0 value = %f", kTrig, kFreq 
	
	outvalue "display1", kFreq
	
	aOut	oscil .5, 880.*kFreq, iTblNum
	outs aOut, aOut
	
	dispfft aOut, iPrdFft, iWsiz
endin

</CsInstruments>
<CsScore>

f 1 0 1024 10 1 		;Sine wave for table 1
f 2 0 1024 10 1 1 1; 3 harmonics

;i	"show_widget_val"	0	120

i "wavwtable_show"	0 120 1	;sin
;i "wavwtable_show"	0 120 2	;3 harm
;i "wavwtable_show"	0 120 4	;Saw
;i "wavwtable_show"	0 120 5;giNois
;i "wavwtable_show"	0 120 6;Imp
;i "wavwtable_show"	0 120 8;Squ
;i "wavwtable_show"	0 120 9;Tri

</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>0</x>
 <y>0</y>
 <width>0</width>
 <height>0</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
 <bsbObject type="BSBVSlider" version="2">
  <objectName>slider0</objectName>
  <x>221</x>
  <y>138</y>
  <width>20</width>
  <height>100</height>
  <uuid>{3bea3385-f772-41fc-8113-10d466e72847}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>0</midicc>
  <description>Show widget value in console</description>
  <minimum>0.00000000</minimum>
  <maximum>1.00000000</maximum>
  <value>1.00000000</value>
  <mode>lin</mode>
  <mouseControl act="jump">continuous</mouseControl>
  <resolution>-1.00000000</resolution>
  <randomizable group="0">false</randomizable>
 </bsbObject>
 <bsbObject type="BSBDisplay" version="2">
  <objectName>display1</objectName>
  <x>124</x>
  <y>33</y>
  <width>80</width>
  <height>25</height>
  <uuid>{b5fd7715-e717-4b48-8e4d-d24989bcf75c}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description>Display slider0 value</description>
  <label>1.000</label>
  <alignment>left</alignment>
  <valignment>top</valignment>
  <font>Arial</font>
  <fontsize>10</fontsize>
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
 <bsbObject type="BSBGraph" version="2">
  <objectName/>
  <x>10</x>
  <y>285</y>
  <width>750</width>
  <height>250</height>
  <uuid>{8e2479c6-1052-4bcf-a847-fdd869811ea4}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <value>9</value>
  <objectName2/>
  <zoomx>1.50000000</zoomx>
  <zoomy>1.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <modex>lin</modex>
  <modey>lin</modey>
  <showSelector>true</showSelector>
  <showGrid>true</showGrid>
  <showTableInfo>true</showTableInfo>
  <showScrollbars>true</showScrollbars>
  <enableTables>true</enableTables>
  <enableDisplays>true</enableDisplays>
  <all>true</all>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
