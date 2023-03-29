<CsoundSynthesizer>
<CsOptions>
-odac           -iadc ;-Ma
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

          ;massign   0, 1 ;assign all incoming midi to instr 1
/*
instr 1 ;global midi instrument, calling instr 2.cc.nnn
          ;(c=channel, n=note number)
inote     notnum    ;get midi note number
ichn      midichn   ;get midi channel
instrnum  =         2 + ichn/100 + inote/100000 ;make fractional instr number
     ; -- call with indefinite duration
           event_i   "i", instrnum, 0, -1, ichn, inote
kend      release   ;get a "1" if instrument is turned off
 if kend == 1 then
          event     "i", -instrnum, 0, 1 ;then turn this instance off
 endif
  endin

  instr 2
ichn      =         int(frac(p1)*100)
inote     =         round(frac(frac(p1)*100)*1000)
iFrq	  mtof 	    inote
kvol init 1
          prints    "instr %f: ichn = %f, inote = %f%n", p1, ichn, inote
          printks   "instr %f playing!%n", 1, p1

	;inote cpsmidi
	;iveloc ampmidi 10000
	aout oscili .3, iFrq, 1
	; Use controller 7 to control volume
	;kvol ctrl7 1, 7, 0.2, 1

	outs kvol * aout, kvol * aout
  endin
*/

instr 1 ;global midi instrument, calling instr 2.cc.nnn
          ;(c=channel, n=note number)
inote     notnum    ;get midi note number
ichn      midichn   ;get midi channel
iAmp	  =	    .5
iFrq	  mtof 	    inote
iNoteCount = 0
instrnum  =         203 + ichn/100 + inote/100000 ;make fractional instr number
print instrnum,  inote, ichn
     	; -- call with indefinite duration
        event_i   "i", instrnum, 0, -1, iFrq, iAmp
	/*
	until iNoteCount == 8 do
		iBaseAmp       random     .1, .5
		instrnum  =         203 + (iNoteCount+1)/100 + inote/100000 ;make fractional instr number
		event_i "i", instrnum, 0, -1, iFrq*(iNoteCount+1), iBaseAmp/(iNoteCount+1)/8
		iNoteCount += 1 ;increase note count
	enduntil
	*/
kend      release   ;get a "1" if instrument is turned off
 if kend == 1 then
        event     "i", -instrnum, 0, 1 ;then turn this instance off
	/*
	iNoteCount = 0
	until iNoteCount == 8 do
		iBaseAmp       random     .1, .5
		instrnum  =         203 + (iNoteCount+1)/100 + inote/100000 ;make fractional instr number
		event     "i", -instrnum, 0, 1 ;then turn this instance off
		iNoteCount += 1 ;increase note count
	enduntil
	*/
 endif
  endin

instr 2,3,10
	iTest = 1
endin

instr 203 ;additive one
	iDur = p3
	iFrq = p4
	iAmp = p5
	kAmpEnv init 1
	print p1
	
	;iAttDur random 0.01*iDur, 0.1*iDur
	;iDecDur	random 0.01*iDur, 0.05*iDur
	;iRelDur	random 0.05*iDur, 0.3*iDur
	
	kRangeMin init .01
	kRangeMax init .3
	kCpsMin init 3
	kCpsMax init 4
	
	;kSliderRvbLvl	init 	0.5
	
	;kAmpEnv adsr iAttDur, iDecDur, .5, iRelDur
	
	;kSliderRvbLvl invalue "slider_rvb_lvl"
	;outvalue	"display_slider_rvb_lvl", kSliderRvbLvl
	
	kFrqMod 	random .5, 2	
	kPartialAmp  = rspline(kRangeMin, kRangeMax, kCpsMin, kCpsMax)
	kFrqOsc   = poscil(kPartialAmp, kFrqMod, 1)
	aOsc     =  poscil(iAmp+kPartialAmp, iFrq+kFrqOsc, 1)
		
	out 	aOsc*kAmpEnv
	;gaSendRvb  =        gaSendRvb + aOsc*kAmpEnv*kSliderRvbLvl
endin

/*
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
*/

</CsInstruments>
<CsScore>
f1 0 1024 10 1 
f2 0 16 7 1 8 0 8
f3 0 1024 10 1 .5 .6 .3 .2 .5

f0 3600
</CsScore>
</CsoundSynthesizer>