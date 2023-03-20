<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

seed 0

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
	kDur			init 	.5
	kMarkovTblCurerent[][] init  5, 5
	kFlag		init 	1
	kFrqTblNum		init 	1
	
	kTrig			metro	1/kDur
	kEnvStart		linseg 4, 2*p3/3, 1, p3/3, 4
	kEnvEnd		linseg 4, 2*p3/3, 2, p3/3, 4
	
	if kFlag == 1 then
			kFlag = 0
			kFrqBase	random 	220, 880
			kPrevElIndexRnd	random 	0.0, 3.5  
		 kPrevElIndex 	=		ceil(kPrevElIndexRnd)
		 kMarkovTblCurerent = gkFrq1
	endif
	
	kSecLast timeinsts
	
	if kTrig == 1 then		
		if kSecLast > p3 * .1 && kSecLast <= p3 * .2 then
			kMarkovTblCurerent = gkFrq2
			kFrqTblNum = 2
		elseif kSecLast > p3 * .2 && kSecLast <= p3 * .3 then
			kMarkovTblCurerent = gkFrq1
			kFrqTblNum = 1
		elseif kSecLast > p3 * .3 && kSecLast <= p3 * .5 then
			kMarkovTblCurerent = gkFrq3
			kFrqTblNum = 3
		else
			kMarkovTblCurerent = gkFrq1
			kFrqTblNum = 1
		endif
		
		kDur 		random 	0.4, kEnvEnd
		event  	"i", 	101,	0, kDur*0.8, kFrqBase*(gkFrqTranform[kPrevElIndex])
		kPrevElIndex  Markovk    kMarkovTblCurerent, kPrevElIndex
		printk2 kFrqTblNum
	endif
	
	;gkTotalLen	linseg .0, p3, 1.
	
	;aSigL, aSigR 	monitor ; read audio from output bus
	;						fout 			"render.wav", 4, aSigL, aSigR 
endin

instr 100
	;get note as index in ginotes array and calculate frequency
	iFreq      =          p4
	iQ         random     10, 200
	iPan       random     0.1, .9
 ;generate tone and put out
	aImp       mpulse     1, p3
	aOut       mode       aImp, iFreq, iQ
	aL, aR     pan2       aOut, iPan
 											out		      aL
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

i 		"part" 		0 		120
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
