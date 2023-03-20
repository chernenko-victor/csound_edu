<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 1
0dbfs = 1

instr 1
	iFrqEnvBegin = p4
	iFrqEnvEnd = p5
	iFreq1 random iFrqEnvBegin, iFrqEnvEnd  
	iFreq2 random iFrqEnvBegin, iFrqEnvEnd   
	iFreq3 = (iFreq1+iFreq2)/2 
	aOut  oscili 0.2, iFreq3, 1	; an oscillator whose frequency is taken from the value produced by 'line'
	outs aOut			 ; send the oscillator's audio to the audio output
endin

instr	2 ; изменение скорости воспроизведения файла, треугольное распределение 

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
endin

instr 3 ;additive one
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
endin

instr 4 ;additive summ
	iDur = p3
	iNoteCount = 0
	iFrqBase = p6
	
	until iNoteCount == 8 do
		iBaseAmp       random     .1, .5
		event_i "i", 3, 0, iDur, iFrqBase*(iNoteCount+1), iBaseAmp/(iNoteCount+1)/8
		iNoteCount += 1 ;increase note count
	enduntil
endin

instr 5 ;substr one
	iFrqBase = p4 
	aSig noise .3, 0
	aSig butbp aSig, iFrqBase, 200
	aSig butterlp aSig, iFrqBase + 200
	aSig butterhp aSig, iFrqBase - 200
	out aSig
endin

instr 6 ;substr summ
	iDur = p3
	iNoteCount = 0
	iFrqBase = p6
	until iNoteCount == 8 do
		event_i "i", 5, 0, iDur, iFrqBase*(iNoteCount+1) ;1:3:5:8...
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

instr 7 ;one reson obertone
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


instr 8 ;reson summ
	iDur = p3
	iNoteCount = 0
	iFrqBase = p6
	iExcit	= .0001
	iDamp   = .0001
	iFrqMult init 1
	until iNoteCount == 8 do
		event_i "i", 7, 0, iDur, iExcit, iFrqBase*iFrqMult, iDamp ;1:3:5:7...
		iFrqMult += 2
		iNoteCount += 1 ;increase note count
	enduntil
endin
/*
; 			p4 		p5 	p6
; 			excitaion 	freq 	damping
i1 0 10 		.0001   	440 	.0001
*/


instr trigger_note
	seed 0
	iPartDur = p3
	iInstrNum = p6
	kFrqBase init 0
	kEnvBegin init p4
	kEnvEnd init p5
	kDurOffset init 1.5
	
    	kDurEnv  oscil 1, .2, 1
	kDur = kDurEnv + kDurOffset
	
	if iInstrNum == 8 then
		kDurOffset = 3.5		
	endif

	kTime    times
	
	kLegato  oscil .5, .5, 1
	
	kTrig metro 1/kDur
	
	if kTime > iPartDur*2./3. && iInstrNum != 8 then
		kDurOffset = 2.5
	endif

	
	
	printf "hello this is cureent time:: kTime = %f kLegato = %f kDur = %f\n", kTrig, kTime, kLegato, kDur
	if kTrig == 1 then
		if iInstrNum == 4 || iInstrNum == 6 || iInstrNum == 8 then  
			kFrqBase random kEnvBegin, kEnvEnd
		endif
		event "i", iInstrNum, 0, kDur * (kLegato + .7), kEnvBegin, kEnvEnd, kFrqBase
		printk 0, kTime
	endif
endin


</CsInstruments>
<CsScore>
f 1 0 1024 10 1 				; the basic sine waveform for the oscillator is generated here 

;i "trigger_note" 0 20 .3 4 2
;i "trigger_note" 5 20 220 440 4
;i "trigger_note" 10 20 440 880 6
i "trigger_note" 0 20 440 880 8
</CsScore>
</CsoundSynthesizer>