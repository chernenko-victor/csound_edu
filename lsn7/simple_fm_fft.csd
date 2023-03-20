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

</CsInstruments>
<CsScore>
f 1 0 1024 10 1 		;Sine wave for table 1

;   		FM Amplitude	FM Frequency
i 1 0	2	10				5  ; 5 Hz vibrato with 10 Hz modulation-width
i 1 ^+3	2	90				5  ; 5 Hz vibrato with 90 Hz modulation-width
i 1 ^+3	2	10				50 ; 50 Hz vibrato with 10 Hz modulation-width
i 1 ^+3	2	10				100 ; 100 Hz vibrato with 10 Hz modulation-width
i 1 ^+3	2	10				220 ; 220 Hz vibrato with 10 Hz modulation-width

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
