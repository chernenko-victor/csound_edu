<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
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


;https://flossmanual.csound.com/sound-modification/fourier-analysis-spectral-processing
opcode FileToPvsBuf, iik, kSooop
 ;writes an audio file to a fft-buffer if trigger is 1
 kTrig, Sfile, iFFTsize, iOverlap, iWinsize, iWinshape xin
  ;default values
 iFFTsize = (iFFTsize == 0) ? 1024 : iFFTsize
 iOverlap = (iOverlap == 0) ? 256 : iOverlap
 iWinsize = (iWinsize == 0) ? iFFTsize : iWinsize
  ;fill buffer
 if kTrig == 1 then
  ilen  filelen Sfile
  kNumCycles    = ilen * kr
  kcycle        init        0
  while kcycle < kNumCycles do
   ain soundin Sfile
   fftin pvsanal ain, iFFTsize, iOverlap, iWinsize, iWinshape
   ibuf, ktim pvsbuffer fftin, ilen + (iFFTsize / sr)
   kcycle += 1
  od
 endif
 xout ibuf, ilen, ktim
endop

																	
instr Files
 S_array[] directory ".\\samples"
 iNumFiles lenarray S_array
 prints "Number of files in %s = %d\n", pwd(), iNumFiles
 printarray S_array
 puts S_array[3], 1
endin


instr	200 
	iSpeedEnvBegin = p4
	iSpeedEnvEnd = p5
	
	iSpeed1 random iSpeedEnvBegin, iSpeedEnvEnd  
	iSpeed2 random iSpeedEnvBegin, iSpeedEnvEnd  
	iSpeed3 = (iSpeed1+iSpeed2)/2		
	
	kSpeed  init     iSpeed3      		; playback speed   			
	iSkip   init     0           ; inskip into file (in seconds)
	iLoop   init     0           ; looping switch (0=off 1=on)

	S_array[] directory ".\\samples"
	;S_array[] fillarray "file1", "file2", ...
 	iNumFiles lenarray S_array
 	;prints "Number of files in %s = %d\n", pwd(), iNumFiles
 	;printarray S_array
 	;puts S_array[3], 1
 	
 	iSampleIndx random 2, iNumFiles
 	SCurrSample = S_array[iSampleIndx]

	a1      diskin2  SCurrSample, kSpeed, iSkip, iLoop ; read audio from disk using diskin2 opcode
    out      a1          ; send audio to outputs
	;gaSend  =        gaSend + a1/3
endin


instr 201
 krangeMin		init	2
	krangeMax		init .5
	kcpsMin			init	.5
	kcpsMax			init	2
	kScaleEnv		rspline krangeMin, krangeMax, kcpsMin, kcpsMax
	kScaleEnv2		rspline 1.5, 0.75, .1, .5
	kGate			init	1
 
 	S_array[] directory ".\\samples"
 	iNumFiles lenarray S_array
 	prints "Number of files in %s = %d\n", pwd(), iNumFiles
 	;printarray S_array
 	puts S_array[3], 1
 	
 	iSampleIndx random 2, iNumFiles
 	SCurrSample = S_array[iSampleIndx]
 
 gibuffer, gilen, k0 FileToPvsBuf timeinstk(), SCurrSample
 ;ktmpnt = linseg:k(0,p3,gilen) + randi:k(1/5,10)
 ktmpnt = linseg:k(0,p3,gilen)
 if kScaleEnv>1	then
 	kGate = 0
 else
 	kGate = 1
 endif
 kRes samphold ktmpnt, kGate
 fread pvsbufread kRes, gibuffer
 fTpsL  pvscale   fread, kScaleEnv2, 1, 1
 aout pvsynth fTpsL
 out aout, aout
endin


instr trigger_note
	seed 0
	iPartDur = p3
	iInstrNum = p6
	kFrqBase init 0
	kEnvBegin init p4
	kEnvEnd init p5
	kDurOffset init 1.5
	kMinDur init 1
	kPrevDurIndex init 1
	
    	kDurEnv  oscil 1, .2, 1
	kDur = kDurEnv + kDurOffset
	kDur *= 3 
	
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

i "Files" 0 0
i 		"trigger_note" 	0 	100 	.3 		4 		200
i 		"trigger_note" 	20	100 	.3 		4 		201
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
