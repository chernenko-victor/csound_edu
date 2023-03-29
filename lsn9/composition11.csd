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
instr 1 ;global midi instrument, calling instr 2.cc.nnn
          ;(c=channel, n=note number)
inote     notnum    ;get midi note number
ichn      midichn   ;get midi channel
iCnt	  = 1
instrnum  =         203 + iCnt/100 + inote/100000 ;make fractional instr number
; -- call with indefinite duration
event_i   "i", instrnum, 0, -1, iCnt, inote

iCnt	  = 2
instrnum  =         203 + iCnt/100 + (inote+7)/100000 ;make fractional instr number
; -- call with indefinite duration
event_i   "i", instrnum, 0, -1, iCnt, (inote+7)

kend      release   ;get a "1" if instrument is turned off
if kend == 1 then
	iCnt	  = 1
	instrnum  =         203 + iCnt/100 + inote/100000 ;make fractional instr number
	event     "i", -instrnum, 0, 1 ;then turn this instance off
	iCnt	  = 2
	instrnum  =         203 + iCnt/100 + (inote+7)/100000 ;make fractional instr number
	event     "i", -instrnum, 0, 1 ;then turn this instance off
endif
endin

instr 2, 3
	inote     notnum    ;get midi note number
	ichn      midichn   ;get midi channel
endin

  instr 203
print p1
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

</CsInstruments>
<CsScore>
f1 0 1024 10 1 
f2 0 16 7 1 8 0 8
f3 0 1024 10 1 .5 .6 .3 .2 .5

f0 3600
</CsScore>
</CsoundSynthesizer>