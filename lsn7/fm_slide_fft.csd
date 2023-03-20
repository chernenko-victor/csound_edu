<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1
iPrdFft init .1
iWsiz init 1024
iModAmp = p4
iModFrq = p5
aMod poscil iModAmp, iModFrq, 1 
aCar poscil 0.3, 440+aMod, 1
outs aCar, aCar
dispfft aCar, iPrdFft, iWsiz
endin


instr fm_slide
  iPrdFft init .1
  iWsiz init 1024

  iModAmpBegin = p4
  iModAmpEnd = p5

  iModFrqBegin = p6
  iModFrqEnd = p7
  
  iDur = p3

  kModAmpEnv expon iModAmpBegin, iDur, iModAmpEnd
  kModFrqEnv expon iModFrqBegin, iDur, iModFrqEnd

  aMod poscil kModAmpEnv, kModFrqEnv, 1 
  aCar poscil 0.3, 440+aMod, 1
  outs aCar, aCar
  dispfft aCar, iPrdFft, iWsiz
endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1 		;Sine wave for table 1

;i	"fm_slide"	0	20		10		100		1		5

;i	"fm_slide"	0	20		10		11			10		500


;i	"fm_slide"	0	20		10		200			300		301


i	"fm_slide"	0	20		50		51			200		2000
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
 <bsbObject type="BSBGraph" version="2">
  <objectName/>
  <x>10</x>
  <y>191</y>
  <width>550</width>
  <height>250</height>
  <uuid>{b2e80d48-1849-4a86-9b71-a9763a3b86ba}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <value>1</value>
  <objectName2/>
  <zoomx>6.00000000</zoomx>
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
