<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

seed 0

;setup discrete distrib. array for duration
gkWeightDur[] init 7
gkWeightDur[] fillarray  .1, .24, .13, .25, .01, .12, .15

;setup values for note frequency
gkFrqBase[] init 7
gkFrqBase[] fillarray 440.0, 220., 330, 880, 660, 1200, 700 


;setup relative values for note duration
gkDur[] init 7
gkDur[] fillarray 1, 2, 3, 4, 6, 8, 12 

;setup minimal duration in seconds
gkMinDur init 0.25

;setup markov table for frequencies
gkMarkovWeightFrq[][] init 7, 7
gkMarkovWeightFrq[][] fillarray .05, .2, .1, .15, .2, .3, .1, 
																																				  .15, .2, .3, .1, .05, .2, .1,
																																				  .1, .15, .2, .3, .1, .05, .2, 
																																				  .2, .1, .15, .2, .3, .1, .05, 
																																				  .2, .3, .1, .05, .2, .1, .15, 
																																				  .15, .2, .3, .1, .05, .2, .1, 
																																				  .05, .2, .3, .1, .2, .1, .15

opcode DiscrDistr, k, k[]
  kDiscrArr[] xin 
  kranrr random 0, 1

  kIndex = 0 
  kSumma = kDiscrArr[kIndex]

  while kSumma <= kranrr do
    kIndex = kIndex + 1
    kSumma = kSumma + kDiscrArr[kIndex]
  od

  xout kIndex
endop	

opcode markov_k, k, kk[][]
  kCurrIndx, kMarkovTbl[][] xin
  kNextIndex init 0
  
  kranrr random 0, 1

  kIndex = 0
  kSumma = kMarkovTbl[kCurrIndx][kIndex]

  while kSumma <= kranrr do
    kIndex = kIndex + 1
    kSumma = kSumma + kMarkovTbl[kCurrIndx][kIndex]
  od
  
  kNextIndex = kIndex
  
  xout kNextIndex
endop

instr part
  kDur init 1 ;duration on start
  kTrig metro 1/kDur ;metronome
  kTimeFromStart timeinsts ;lets check time from start "part" 
  kFrqIndex init 0 ;current index in frequency array gkFrqBase
  if kTrig == 1 then    
    
    if kTimeFromStart > 20 then ;after 20 second equal random for 
    ;duration and frequency
	     kDur random .25, 4
	     kCurrFrqBase random 330., 880.
	   else ;strict duration and frequency
	   	  kDurIndex DiscrDistr gkWeightDur ;get next index
      ;in duration array gkDur based on discrete distr.		
      kDur = gkDur[kDurIndex] * gkMinDur ;get real duration in secons
      ;printk2 kDur
      kFrqIndex markov_k kFrqIndex, gkMarkovWeightFrq ;get next index
    ;in frequency array gkFrqBase based on Markov chain
      kCurrFrqBase = gkFrqBase[kFrqIndex] 
	   endif
    kLegato = 0.9 * kDur ;length of the note
    ;try vary this by randomization
    
    ;          instr           start  length  amp   frq       ober num
    event "i", "additive_event", 0, kLegato, .2, kCurrFrqBase, 8 
    ;start additive synth
    ;you can change instr there
    ;turn on substractive for example ))
  endif
  
      printf "kDur = %f \t kLegato = %f \n", kTrig, kDur, kLegato
endin


instr one_obertone_additive ;101 ;one obertone for additive synth
  iAmp = p4
  iFrq = p5
  iAttTime = p6
  iRelTime = 0.3
  iSustTime = p3 - iAttTime - iRelTime
  
  if iSustTime < 0 then ;if note length is too small, this makes right
  ;envelope 
    iSustTime = .5*p3
    iAttTime = .2*p3
    iRelTime = .3*p3
  endif
  
  ;print iAttTime,iRelTime, iSustTime 

  kAmpVar rspline 0.005, 0.05, 10, 30
  kFrqVar rspline 5, 10, 20, 40

  kAmpEnv linseg 0, iAttTime, 1, iSustTime, 1, iRelTime, 0
  aOut oscili iAmp + kAmpVar, iFrq + kFrqVar

  outs aOut*kAmpEnv, aOut*kAmpEnv
endin


instr additive_event;102 ;start many obertone for additive synth
  iAmp = p4
  iFrq = p5
  iDur = p3
  iObertNum = p6
  iIndex = 0
begin:   
  iAttTime = 0.1 * (iIndex + 1)
  ;print iAttTime

  event_i "i", "one_obertone_additive", 0, iDur, iAmp / (iIndex + 1), iFrq * (iIndex + 1), iAttTime
  iIndex = iIndex + 1

  if iIndex < iObertNum then
  	goto begin
  endif
endin

;add there substractive synth instr
; many filtered triangle
instr 103
  iAmp = p4
  iFrq = p5
  iDur = p3
  iObertNum = p6
  iIndex = 0
begin:   
  iAttTime = 0.1 * (iIndex + 1)
  event_i "i", 104, 						0, 			iDur, 	iAmp / iObertNum * (iIndex + 1)		,  iFrq * (iIndex + 1), iAttTime, iFrq
  iIndex = iIndex + 1
  if iIndex < iObertNum then
  	goto begin
  endif
endin


instr 104; one filtered triangle
  iAmp = p4
  iFrq = p5
  iAttTime = p6
  
  ;insert envelope fix for small length
  
  iBaseFrq = p7
  kAmpVar rspline 0.005, 0.05, 10, 30
  kFrqVar rspline 5, 10, 20, 40
  kAmpEnv linseg 0, iAttTime, 1, (p3 - iAttTime - 0.3), 1, 0.3, 0
  aOut vco2 iAmp + kAmpVar, iBaseFrq
  ;try filter noise
  ;printk2 iFrq
  aOut butbp aOut, iFrq + kFrqVar, 1000 / (iFrq + kFrqVar)
  ;aOut butbp aOut, iFrq + kFrqVar, 200
  outs aOut*kAmpEnv*5, aOut*kAmpEnv*5
endin


</CsInstruments>
<CsScore>
  i "part" 0 40 
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
