<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

giMinDur init .25

gkFrqTranform[]				fillarray 1,	9/8,	5/4,	4/3,	3/2,	5/3,	15/8,	2

gkRythm[][] init  5, 5
gkRythm fillarray .66, 	.34, 	0, 		0, 		0,
																	.17,		.66,  .17,	0,			0,
																	0,				.17,		.66, .17,	0,
																	0,				0,				.17,	.66, .17,
																	0,				0,				0,			.34,	.66

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

instr part
	kDurCurr			init 	.5
	kDurLast			init 	.5
	kFlag		init 	1
	
	kTrig			metro	1/kDurCurr
	kEnvMinDur		linseg .25, 2*p3/3, .75, p3/3, .25
	kEnvMaxDur		linseg 1.5, 2*p3/3, 2.5, p3/3, 1.5
	kDivPercent oscili .25, 1/8, 1
	
	if kFlag == 1 then
			kFlag = 0
			kFrqBase	random 	220, 880
	endif
	
	kSecLast timeinsts
	
	if kTrig == 1 then	
		kDurCurr 		random 	kEnvMinDur, kEnvMaxDur
		kPercent	random 	.0, .1
		;&& kPercent > (.5+kDivPercent)
		if kDurLast <= kDurCurr && kPercent > (.5+kDivPercent) then
			kIndex = 1
		else
		 kPercent2	random 	.0, .1
		 if kPercent2 < .3 then
		 	kIndex random 	0, 6.5
		 endif
		endif
		printk2 kDurCurr
		printk2 kDurLast
		event  	"i", 	101,	0, kDurCurr*0.8, kFrqBase*(gkFrqTranform[kIndex])
		kDurLast = kDurCurr
	endif
	 
endin


instr part2
	kDurIndx		init 	0
	kFrqIndx		init 	0
	kFlag		init 	1
	
	kTrig			metro	1/((kDurIndx+1)*giMinDur)
	
	if kFlag == 1 then
			kFlag = 0
			kFrqBase	random 	220, 880
	endif
	
	kSecLast timeinsts
	
	if kTrig == 1 then	

		event  	"i", 	101,	0, ((kDurIndx+1)*giMinDur)*0.8, kFrqBase*(gkFrqTranform[kFrqIndx])
		kDurIndx  Markovk    gkRythm, kDurIndx
		kFrqNext	random 	0., 1.
		if kFrqNext <= .5 then
			kFrqIndx += 1
		else 
			kFrqIndx -= 1
		endif
		if kFrqIndx < 0 then
			kFrqIndx = 7
		elseif kFrqIndx > 7 then
			kFrqIndx = 0
		endif
	endif
	 
endin


instr 101
	iFreq      =          p4
	kAmpEnv adsr p3/10, p3/5, .2, p3/5
	aOut  oscili kAmpEnv*.4, iFreq, 1
							out		      aOut
endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1

i 		"part" 		0 		38
i 		"part2" 		40 		38

i 		"part" 		80 		20
i 		"part2" 		86 		20
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
