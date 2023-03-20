<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

;======================================================
;	src:
;		markov_change2
;
;======================================================

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1


gaSend init 0

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


gkDurTransform[]				fillarray	1,	2,	4,	6,	8,	12,	16

gkDur1[][] init 7, 7
gkDur1	fillarray	0.5,	0.4,	0.1,	0,		0,		0,		0,
					0.3,	0.3,	0.3,	0.1,	0,		0,		0,
					0,		0.3,	0.3,	0.3,	0.1,	0,		0,
					0,		0,		0.3,	0.3,	0.3,	0.1,	0,
					0,		0,		0,		0.3,	0.3,	0.3,	0.1,
					0,		0,		0,		0.1,	0.3,	0.3,	0.3,
					0,		0,		0,		0,		0.1,	0.5,	0.4


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
	gaSend  =        gaSend + aOut/3
endin


instr	200 ; изменение скорости воспроизведения файла, треугольное распределение 

	iSpeedEnvBegin = p4
	iSpeedEnvEnd = p5
	
	iSpeed1 random iSpeedEnvBegin, iSpeedEnvEnd  
	iSpeed2 random iSpeedEnvBegin, iSpeedEnvEnd  
	iSpeed3 = (iSpeed1+iSpeed2)/2		
	
	kSpeed  init     iSpeed3      		; playback speed   			
	iSkip   init     0           ; inskip into file (in seconds)
	iLoop   init     0           ; looping switch (0=off 1=on)

	a1      diskin2  "02.2.record.wav", kSpeed, iSkip, iLoop ; read audio from disk using diskin2 opcode
    out      a1          ; send audio to outputs
	gaSend  =        gaSend + a1/3
endin


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
	
	kAmpEnv adsr iAttDur, iDecDur, .5, iRelDur
	
	kFrqMod 	random .5, 2	
	kPartialAmp  = rspline(kRangeMin, kRangeMax, kCpsMin, kCpsMax)
	kFrqOsc   = poscil(kPartialAmp, kFrqMod, 1)
	aOsc     =  poscil(iAmp+kPartialAmp, iFrq+kFrqOsc, 1)
		
	;aOsc	oscili 	0.1, iFrq, 1
			out 	aOsc*kAmpEnv
	gaSend  =        gaSend + aOsc*kAmpEnv/5
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

instr 205 ;substr one
	iFrqBase = p4 
	aSig noise .3, 0
	aSig butbp aSig, iFrqBase, 200
	aSig butterlp aSig, iFrqBase + 200
	aSig butterhp aSig, iFrqBase - 200
	out aSig
	fout aSig, "sdfsdfsdfs"
endin

instr 206 ;substr summ
	iDur = p3
	iNoteCount = 0
	iFrqBase = p6
	until iNoteCount == 8 do
		event_i "i", 205, 0, iDur, iFrqBase*(iNoteCount+1) ;1:3:5:8...
		iNoteCount += 1 ;increase note count
	enduntil
endin

opcode 	lin_reson, 	a, akk
setksmps 1
avel 	init 	0 		;velocity
ax 	init 	0 		;deflection x
ain,kf,kdamp 	xin
kc 	= 	2-sqrt(4-kdamp^2)*cos(kf*2*$M_PI/sr)
aacel 	= 	-kc*ax
avel 	= 	avel+aacel+ain
avel 	= 	avel*(1-kdamp)
ax 	= 	ax+avel
	xout 	ax
	
endop

instr 207 ;one reson obertone
	iDur	=	p3
	iAttDur random 0.01*iDur, 0.1*iDur
	iDecDur	random 0.01*iDur, 0.05*iDur
	iRelDur	random 0.05*iDur, 0.3*iDur
	                	
	kAmpEnv adsr iAttDur, iDecDur, .9, iRelDur	

	kRndRange	rspline p4*.5, p4*2, .5, 3
	aexc 		rand 	kRndRange*kAmpEnv
	;kFrqEnv 	line 	p5, p3, 2*p5
	kFrqEnv		rspline p5*.9, p5*1.1, .5, 3
	kDampEnv 	rspline p6*.5, p6*30, .3, 2
	;kDampEnv	line p6*.5, p3, p6*20 	
	aout 		lin_reson 	aexc, kFrqEnv, kDampEnv
			out 	aout*kAmpEnv
endin


instr 208 ;reson summ
	iDur = p3
	iNoteCount = 0
	iFrqBase = p6
	iExcit	= .0001
	iDamp   = .0001
	iFrqMult init 1
	until iNoteCount == 8 do
		event_i "i", 207, 0, iDur, iExcit, iFrqBase*iFrqMult, iDamp ;1:3:5:7...
		iFrqMult += 2
		iNoteCount += 1 ;increase note count
	enduntil
endin


instr 300 ; reverb
aRvb,aRvb reverbsc gaSend,gaSend,0.9,7000
            out     aRvb
            clear    gaSend
 endin

instr part
	iTotalDur = p3
	kDur			init 	.5
	kMarkovTblCurerent[][] init  5, 5
	kFlag		init 	1
	kFrqTblNum		init 	1
	
	kEnvBegin init 440
	kEnvEnd init 880
	
	kTrig			metro	1/kDur
	kEnvStart		linseg 4, 2*p3/3, 1, p3/3, 4
	kEnvEnd		linseg 4, 2*p3/3, 2, p3/3, 4
	
	kInstrNum init 101
	
	if kFlag == 1 then
			kFlag = 0
			kFrqBase	random 	220, 880
			kPrevElIndexRnd	random 	0.0, 3.5  
		 kPrevElIndex 	=		ceil(kPrevElIndexRnd)
		 kMarkovTblCurerent = gkFrq1
	endif
	
	kSecLast timeinsts
	
	kLegato  oscil .5, .5, 1
	
	
	print iTotalDur
	printf "hello this is cureent time:: kSecLast = %f kInstrNum = %f \n", kTrig, kSecLast, kInstrNum
	
	if kTrig == 1 then
		/*
		if kSecLast > p3 * .1 && kSecLast <= p3 * .2 then
			kMarkovTblCurerent = gkFrq2
			kFrqTblNum = 2
		elseif kSecLast > p3 * .2 && kSecLast <= p3 * .3 then
			kMarkovTblCurerent = gkFrq1
			kFrqTblNum = 1
		elseif kSecLast > p3 * .3 && kSecLast <= p3 * .5 then
			kMarkovTblCurerent = gkFrq3
			kFrqTblNum = 3
			kInstrNum = 204
		else
			kMarkovTblCurerent = gkFrq1
			kFrqTblNum = 1
			kInstrNum = 206
		endif
		*/
		
		if kSecLast <= p3 * .3 then
			kMarkovTblCurerent = gkFrq2
			kFrqTblNum = 2
		elseif kSecLast > p3 * .3 && kSecLast <= p3 * .6 then
			kMarkovTblCurerent = gkFrq3
			kFrqTblNum = 3
			kInstrNum = 204
		else
			kMarkovTblCurerent = gkFrq1
			kFrqTblNum = 1
			kInstrNum = 206
		endif
		
		kDur 		random 	0.4, kEnvEnd
		
		/*
		if kInstrNum == 204 || kInstrNum == 206 || kInstrNum == 208 then  
			kFrqBase random kEnvBegin, kEnvEnd
		endif
		*/
		
		if kInstrNum == 101 then  
			event  	"i", 	kInstrNum,	0, kDur*0.8, kFrqBase*(gkFrqTranform[kPrevElIndex])
		else
			event "i", kInstrNum, 0, kDur * (kLegato + .7), kEnvBegin, kEnvEnd, kFrqBase*(gkFrqTranform[kPrevElIndex])
		endif
		kPrevElIndex  Markovk    kMarkovTblCurerent, kPrevElIndex
		printk2 kFrqTblNum
	endif
	
	;gkTotalLen	linseg .0, p3, 1.
	
	;aSigL, aSigR 	monitor ; read audio from output bus
	;						fout 			"render.wav", 4, aSigL, aSigR 
endin

instr trigger_note
	seed 0
	iPartDur = p3
	iInstrNum = p6
	kFrqBase init 0
	kEnvBegin init p4
	kEnvEnd init p5
	kDurOffset init 1.5
	kMinDur init .25
	kPrevDurIndex init 1
	
    	kDurEnv  oscil 1, .2, 1
	kDur = kDurEnv + kDurOffset
	
	if iInstrNum == 208 then
		kDurOffset = 3.5		
	endif

	;kTime    times
	kTime timeinsts
	
	kLegato  oscil .5, .5, 1
	
	kTrig metro 1/kDur
	
	if kTime > iPartDur*2./3. && iInstrNum != 208 then
		kDurOffset = 2.5
	endif

	
	
	printf "hello this is cureent time:: kTime = %f kLegato = %f kDur = %f\n", kTrig, kTime, kLegato, kDur
	if kTrig == 1 then
		if iInstrNum == 204 || iInstrNum == 206 || iInstrNum == 208 then  
			kFrqBase random kEnvBegin, kEnvEnd
		endif
		
		if kTime > iPartDur*2./3. then
			kPrevDurIndex  Markovk    gkDur1, kPrevDurIndex
			kDur = kMinDur * gkDurTransform[kPrevDurIndex]
		endif
		
		event "i", iInstrNum, 0, kDur * (kLegato + .7), kEnvBegin, kEnvEnd, kFrqBase
		printk 0, kTime
	endif
endin
</CsInstruments>
<CsScore>
f 1 0 1024 10 1

i 		"part" 			0 		120
i 		"trigger_note" 	10 		30 	220		440 	204
i 		"trigger_note" 	25 		. 	440 	880 	206
i 		"trigger_note" 	80 		. 	440 	880 	208
i 		"trigger_note" 	100 	. 	.3 		4 		200

; reverb instrument
i 		300				0 		120
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
