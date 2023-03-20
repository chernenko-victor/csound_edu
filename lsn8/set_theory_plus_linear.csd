<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1


instr three_tones
	iIndxMin init 60
	iIndxMax init 82
	iDurNote init 1.5
	iDelay init 0
	
	iInterval1 = p4
	iInterval2 = p5
	iInterval3 = p6
	iInterval4 = p7
		
	iIndx1 = iIndxMin
	iIndx2 = iIndxMin
	iIndx3 = iIndxMin

	until iIndx1>iIndxMax do
  ;print iIndx1
  until iIndx2>iIndxMax do
  	until iIndx3>iIndxMax do
  		if iIndx3 % iIndx2 == iInterval1 || iIndx3 % iIndx2 == iInterval2 then
  			if iIndx2 % iIndx1 == iInterval3 || iIndx2 % iIndx1 == iInterval4 then
  				iDurNote = random(0.5, 3.)
  				
  				iNote1Frq = cpsmidinn(iIndx1)
  				iNote2Frq = cpsmidinn(iIndx2)
  				iNote3Frq = cpsmidinn(iIndx3)
  				;print iDelay
  				event_i "i", 101, iDelay, iDurNote*0.9, iNote1Frq
  				event_i "i", 101, iDelay, iDurNote*0.9, iNote2Frq
  				event_i "i", 101, iDelay, iDurNote*0.9, iNote3Frq
  				iDelay = iDelay + iDurNote
  			endif
  		endif
  		iIndx3 += 1
  	od
  	iIndx3 = iIndxMin
  	iIndx2 += 1
  od
  iIndx2 = iIndxMin
		iIndx1 += 1
	od

endin

instr 101
	iFreq      =          p4
	kAmpEnv adsr p3/10, p3/5, .2, p3/5
	aOut  oscili kAmpEnv*.1, iFreq, 1
							out		      aOut
endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1

i 		"three_tones" 		0 		 20 3 4 3 4
s
i 		"three_tones" 		0 		20 3 4 3 2
s

r 2
i 101	0 .5 783.99	;g
i 101	.5 .5 880.00;a
i 101	1 1 783.99;g 	
;i 101	2 1 ;_ 	
i 101	3 .5 880.00;a 	
i 101	3.5 1.5 783.99;g 		
;i 101	5 1 ;_ 	
i 101	6 1 880.00;a 	
i 101	7 1 783.99;g 	
i 101	8 .5 698.46;f 	
i 101	8.5 1.5 880.00;a 		
;i 101	10 2 ;_ 	
i 101	12 2 698.46;f
;i 101	14 2 ;_

s

i 		"three_tones" 		0 		20 3 2 3 5
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
</bsbPanel>
<bsbPresets>
</bsbPresets>
