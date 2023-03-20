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


instr am_slide
  iPrdFft init .1
  iWsiz init 1024
  
  aRaise expseg 2, 20, 100
  aModSine poscil 0.5, aRaise, 1
  aDCOffset = 0.5    ; we want amplitude-modulation
  aCarSine poscil 0.3, 440, 1
  aOut = aCarSine*(aModSine + aDCOffset)
  outs aOut, aOut 
  dispfft aOut, iPrdFft, iWsiz
endin


instr am_sideband
	iPrdFft init .1
  iWsiz init 1024
  
  aOffset linseg 0, 1, 0, 5, 0.6, 3, 0
  aSine1 poscil 0.3, 200 , 1
  aSine2 poscil 0.3, 440, 1
  aOut = (aSine1+aOffset)*aSine2
  outs aOut, aOut 
  dispfft aOut, iPrdFft, iWsiz
endin


instr rm_slide   ; Ring-Modulation (no DC-Offset)
	iPrdFft init .1
  iWsiz init 1024
  iModFrqBegin init 200
  iDur = p3
  iModFrqEnd init 500
  
  kModFrqEnv expon iModFrqBegin, iDur, iModFrqEnd
  aSine1 poscil 0.3, kModFrqEnv, 2 ; -> [200, 400, 600] Hz
  aSine2 poscil 0.3, 600, 1
  aOut = aSine1*aSine2
  outs aOut, aOut
  dispfft aOut, iPrdFft, iWsiz
endin


</CsInstruments>
<CsScore>
f 1 0 1024 10 1 		;Sine wave for table 1
f 2 0 1024 10 1 1 1; 3 harmonics

;i	"am_slide"	0	25
;i	"am_sideband"	0 10
i	"rm_slide"	0	10
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
  <value>2</value>
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
