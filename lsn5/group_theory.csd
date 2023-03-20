<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

 

giGroupMult[][] init  12, 12
giGroupMult fillarray 11,	0,	1,	2,	3,	4,	5,	6,	7,	8,	9,	10,
10,	11,	0,	1,	2,	3,	4,	5,	6,	7,	8,	9,
9,	10,	11,	0,	1,	2,	3,	4,	5,	6,	7,	8,
10,	11,	0,	1,	2,	3,	4,	5,	6,	7,	8,	9,
11,	0,	1,	2,	3,	4,	5,	6,	7,	8,	9,	10,
10,	11,	0,	1,	2,	3,	4,	5,	6,	7,	8,	9,
9,	10,	11,	0,	1,	2,	3,	4,	5,	6,	7,	8,
10,	11,	0,	1,	2,	3,	4,	5,	6,	7,	8,	9,
11,	0,	1,	2,	3,	4,	5,	6,	7,	8,	9,	10,
10,	11,	0,	1,	2,	3,	4,	5,	6,	7,	8,	9,
9,	10,	11,	0,	1,	2,	3,	4,	5,	6,	7,	8,
10,	11,	0,	1,	2,	3,	4,	5,	6,	7,	8,	9



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


instr melody2
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
  				
  				iIndx1Oct = iIndx1%12
  				iIndx3Oct = iIndx3%12
  				iMelodyMidi = giGroupMult[iIndx1Oct][iIndx3Oct] + (iIndx2%12) + 60
  				iMelodyCps = cpsmidinn(iMelodyMidi)
  				event_i "i", 102, iDelay, iDurNote*0.9, iMelodyCps
  				
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

instr 102
	iFreq      =          p4
	kAmpEnv adsr p3/10, p3/5, .05, p3/5
	aSig    vco2         kAmpEnv*.3, iFreq       ; input signal is a sawtooth waveform
	;kcf     expon        10000,p3,20    ; descending cutoff frequency
	aCutFrqEnv	rspline 	 300, 20, 1, 8
	aSig    moogladder   aSig, iFreq+aCutFrqEnv, 0.9 ; filter audio signal
	out          aSig           ; filtered audio sent to output
  endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1

i 		"three_tones" 		0 		 20 3 4 3 4
i 		"melody2" 							5 		 20 6 7 10 11
s
i 		"three_tones" 		0 		20 3 4 3 2
i 		"melody2" 							5 		 20 3 2 5 11
s
i 		"three_tones" 		0 		20 3 2 3 5
i 		"melody2" 							5 		 20 2 1 3 9
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
