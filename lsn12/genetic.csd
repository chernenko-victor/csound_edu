<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

#include "C:\usr\chernenko\src\csound\dev2\csound\include\math\stochastic\distribution3.inc.csd"
#include "C:\usr\chernenko\src\csound\dev2\csound\include\math\stochastic\util.inc.csd"
#include "C:\usr\chernenko\src\csound\dev2\csound\include\utils\table.v1.csd"

giSine    ftgen     0, 0, 2^10, 10, 1

gkModi[][] init  9, 8
gkModi fillarray	/* natural */			1, 2, 3, 4, 5, 6, 7, 8,
					/* geom */				1, 2, 4, 8, 16, 32, 64, 128,
					/* fibon */				1, 2, 3, 5, 8, 13, 21, 34,
					/* ionian */ 			1, 1.1111, 1.25, 1.3333, 1.5, 1.6667, 1.875, 2,
					/* Phrygian */ 			1, 1.0667, 1.2, 1.3333, 1.5, 1.6, 1.8, 2,
					/* Dorian */			1, 1.1111, 1.25, 1.4063, 1.6, 1.8, 2, 2.1111,
					/* Anhemitone */		1, 1.1111, 1.25, 1.4063, 1.6, 1.8, 2, 2.1111,
					/* tone-half */			1, 1.0667, 1.2, 1.25, 1.4063, 1.5, 1.6667, 1.8, 
					/* tone-half-half */	1, 1.1111, 1.2, 1.25, 1.4063, 1.5, 1.6, 1.8
					
					
gkModusCurr[][] init  9, 8

seed 0


instr init_arr
	kFlag		init 	1
	kNoteCnt init 0
	
	if kFlag == 1 then
			kFlag = 0
			gkModusCurr[0][0] = 0
gkModusCurr[0][1] = 1
gkModusCurr[0][2] = 2
gkModusCurr[0][3] = 3
gkModusCurr[0][4] = 4
gkModusCurr[0][5] = 5
gkModusCurr[0][6] = 6
gkModusCurr[0][7] = 7

gkModusCurr[1][0] = 0
gkModusCurr[1][1] = 3
gkModusCurr[1][2] = 0
gkModusCurr[1][3] = 4
gkModusCurr[1][4] = 4
gkModusCurr[1][5] = 0
gkModusCurr[1][6] = 2
gkModusCurr[1][7] = 4
	endif
endin

opcode swap_arr_part, k, kkkk 
   kFstArrNum, kLstArrNum, kTargetArrNum, kBreakPos xin
		 kRes init 0
			kNoteCnt = 0
			while kNoteCnt<=7 do
			if kNoteCnt<kBreakPos then
				gkModusCurr[kTargetArrNum][kNoteCnt] = gkModusCurr[kFstArrNum][kNoteCnt]
			else
				gkModusCurr[kTargetArrNum][kNoteCnt] = gkModusCurr[kLstArrNum][kNoteCnt]
			endif
				kNoteCnt += 1
			od
			xout kRes
endop

instr 10 ;subinstrument for playing one partial
	ifreq     =         p4 ;frequency of this partial
	iamp      =         p5 ;amplitude of this partial
	imult 				=									p6
	;aenv      transeg   0, .01, 0, iamp, p3-0.1, -10, 0
	;aenv 				linseg 				0, p3*.1, iamp
	aenv linseg 0, p3*0.1, iamp, p3*0.25, iamp*.8, p3*0.4, iamp*.8, p3*0.25, 0
	apart     poscil    aenv, ifreq*imult, giSine
	out      apart
endin

instr recombine
	kFlag		init 	1
	kNoteCnt init 0
	kModusCurrNum init 2
	kTmp[] init 8
	
	if kFlag == 1 then
			kFlag = 0
			
			/*
			while kNoteCnt<=7 do
				fprintks 	"genetic.txt", ":: gkModusCurr[0][%d] = %f \\n", kNoteCnt, gkModusCurr[0][kNoteCnt]
				kNoteCnt += 1
			od
			*/
		
			kRecombineNum = 2
			while kRecombineNum<=7 do
				kBreakPos random 1, 6.9
				kRes swap_arr_part kRecombineNum-2, kRecombineNum-1, kRecombineNum, kBreakPos
				kRecombineNum += 1
			od
			
			kRecombineNum = 0
			while kRecombineNum<=7 do
			
				kNoteCnt = 0
				while kNoteCnt<=7 do
					fprintks 	"genetic.txt", ":: gkModusCurr[%d][%d] = %f \\n", kRecombineNum, kNoteCnt, gkModusCurr[kRecombineNum][kNoteCnt]
					kNoteCnt += 1
				od
				kRecombineNum += 1
				fprintks 	"genetic.txt", "\\n"
			
			od
			
	endif
endin

instr part
kPeriod		init 	1.0 		;time between event start, now generated as gkMinPeriod * gkModi[kModTypeIndx][kIndxFolded], 
								;where gkModi is 2dim array, kModTypeIndx is type of modi, now constat (2DO change by system),
								;kIndxFolded is random generated index, scaled to modus length
								
	kStart		init 	0		;offst for event opcode, now constant 
	kDur		init 	.8		;duration of event, now is relative to kPeriod (2DO: change by system)
	kAmp		init 	.3		;amplitude of event opcode, now constant (2DO: change by system)
	kFrq		init 	440		;frequency of event
	kFrqMult	init 	440.		;base frq multiplier, now uniform random (2DO: change by system)

;BEGIN var for period change 
	;change produced by generating indicies for gkModi[type] subarray 
	kiDistrType	init 	7		;type of rnd distribution see in #PATH_TO_LIB\include\math\stochastic\distribution3.inc.csd
	kiMin		init 	0		
	kiMax		init 	3	
	kDepth		init 	2	
	;END var for period change
	
	;BEGIN var for frequency change 
	;change produced by generating indicies for gkModi[type] subarray 
	kFrqDistrType	init 	5		;type of rnd distribution see in #PATH_TO_LIB\include\math\stochastic\distribution3.inc.csd
	kFrqMin			init 	0		
	kFrqMax			init 	7	
	kFrqDepth		init 	3	
	;END var for frequency change
	
	kFoldingType	init 	2	;type of scaling indicies to gkModi[type] subarray  length
	kTblLen			init 	8	;gkModi[type] subarray length

	iPan		=	p5	
	iModusCurrNum = p4

	kTrig			metro	1/kPeriod	;metro for event generating
	
	kTimer			line 	0., p3, 1.	;part of whole duration of current note now

	kFlag		init 	1
	kNoteCnt init 0
	
	if kFlag == 1 then
			kFlag = 0
			;kPeriod	 		random 	0.5, 6.5 
			kDur = kPeriod * .8
			
			
	endif
	
	if kTrig == 1 then
	 kIndxFolded	= kNoteCnt % 7
	 kCurrNote = gkModusCurr[iModusCurrNum][kIndxFolded]
		kFrq	 	= 	kFrqMult * gkModi[3][kCurrNote]
		
		
		fprintks 	"genetic.txt", ":: kFrq = %f | kNoteCnt = %f | kIndxFolded = %f, kCurrNote = %f \\n", kFrq, kNoteCnt,kIndxFolded, kCurrNote
		
		event  		"i", 10, kStart, kDur, kFrq, kAmp, 0.5
	
		;kPeriod	 		random 	0.5, 6.5 
		kDur = kPeriod * .8
		kNoteCnt += 1
	
	endif
endin


</CsInstruments>
<CsScore>
i "init_arr" 0 1
;s
;i "part" 0 20 0
;i "part" 20 20 1
;s
i "recombine" 2 1
s
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
