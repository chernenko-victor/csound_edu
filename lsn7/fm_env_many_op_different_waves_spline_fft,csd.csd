<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 32
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

instr 1
	iPrdFft init .1
	iWsiz init 1024
	iDur			= p3
	iModAmpB 	= p4
	iModAmpE 	= p5
	iModFrqB 	= p6
	iModFrqE 	= p7
	iTblCar		=	p8
	iTblMod1		=	p9
	
	;kModAmp expon iModAmpB, iDur, iModAmpE
	kModAmp = rspline(iModAmpB, iModAmpB, .2, 1)
	;kModFrq expon iModFrqB, iDur, iModFrqE
	kModFrq	 = rspline(iModFrqB*.3, iModFrqE*.3, .2, 1)
	
	kModAmp2 expon 10, iDur, 100
	kModFrq2 expon 100, iDur, 1000
	
	aMod2 poscil kModAmp2, kModFrq2, 1 
	aMod poscil kModAmp, kModFrq+aMod2, iTblMod1 
	aCar poscil 0.3, 440+aMod, iTblCar
	aCar    buthp        aCar, 400
	outs aCar, aCar
	dispfft aCar, iPrdFft, iWsiz
endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1 		;Sine wave for table 1
f 2 0 1024 10 1 1 1; 3 harmonics

;   				FM Amplitude			FM Frequency
;i 1 0	20		10			100				5  			10; 5 Hz vibrato with 10 Hz modulation-width
;i 1 0	20		10			11					5  			100; 5 Hz vibrato with 10 Hz modulation-width
;i 1 0	20		10			11				15  			200; 5 Hz vibrato with 10 Hz modulation-width
;i 1 0	20		50			51				300  			1500; 5 Hz vibrato with 10 Hz modulation-width

;i 1 0	20		150		500				300  			1500		4		2; 5 Hz vibrato with 10 Hz modulation-width
;i 1 0	20		150		500				300  			1500		5		2; 5 Hz vibrato with 10 Hz modulation-width
;i 1 0	20		150		500				300  			1500		7		2; 5 Hz vibrato with 10 Hz modulation-width
i 1 0	20		150		500				300  			1500		2		1; 5 Hz vibrato with 10 Hz modulation-width
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
  <value>9</value>
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
