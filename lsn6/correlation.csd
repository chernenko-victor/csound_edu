<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

gkFrqTranform[]				fillarray	1, 15/8, 4/3, 3/2, 9/8, 5/4, 5/3, 2, 2+15/8

gkSystemHarmony[][] init 9, 3
gkSystemHarmony fillarray 2, 4, 7,
3, 6, 10,
10, 1, 5,
8, 12, 3,
1, 5, 8, 
6, 10, 1, 
5, 8, 12, 
12, 3, 6,
2, 4, 7


gkFrqTranform12Tone[]				fillarray	1, 16/15, 9/8, 6/5, 5/4, 4/3, 45/32, 3/2, 8/5, 5/3, 16/9, 15/8 


gkSFC1[][] init  2, 9
gkSFC1 fillarray .15,	.2,	.1,	.033,	.033,	.034,	.1,	.2,	.15,
0.05,	0.05,	.1,	.175,	.25,	.175,	.1,	0.05,	0.05



gkSFC2[][] init  4, 9
gkSFC2 fillarray 0.2, 0.25, 0.05, 0, 0, 0, 0.05, 0.25, 0.2,
0.075, 0.1, 0.15, 0.15, 0.05, 0.15, 0.15, 0.1, 0.075,
0, 0, 0.1, 0.2, 0.4, 0.2, 0.1, 0, 0,
0, 0, 0.1, 0.2, 0.6, 0.1, 0, 0, 0


gkRythm[][] init  5, 5
gkRythm fillarray .66, 	.34, 	0, 		0, 		0,
																	.17,		.66,  .17,	0,			0,
																	0,				.17,		.66, .17,	0,
																	0,				0,				.17,	.66, .17,
																	0,				0,				0,			.34,	.66
																	
gkFrqBase init 440.

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
 kPeriod init .5
 kCurrTickNumber init 1
 kCurrTickStress init 0

	kTrig			metro	1/kPeriod

	if kTrig == 1 then
	 if kCurrTickNumber%2 == 0 then
	 	kCurrTickStress = 0
	 else
	 	kCurrTickStress = 1
	 endif
	 
	 kCurrEl Markovk gkSFC1, kCurrTickStress
		kCurrTickNumber += 1

		printk2 kCurrEl
		printk2 kCurrTickNumber
	endif	
endin


instr part_2bar
 kPeriod init 1.
 kCurrTickNumber init 1
 kCurrTickStress init 0

	kTrig			metro	1/kPeriod

	if kTrig == 1 then
		kMod2 = kCurrTickNumber%2
		kMod8 = kCurrTickNumber%8
	 if kMod2 == 0 then ;weak time
	 	kDur = kPeriod*0.8
	 	kCurrTickStress = 0 
	 else ;strong time 
	 	kDur = kPeriod*0.6
	 	if kMod8 == 1 then ;odd bar 1st tick
	 		kCurrTickStress = 3 
	 	elseif kMod8 == 5 then ;even bar 1st tick
	 		kCurrTickStress = 2
	 	else ;3rd tick
	 		kCurrTickStress = 1
	 	endif
	 endif
	 
	 
	 
	 kCurrEl Markovk gkSFC2, kCurrTickStress
	 	event  	"i", 	"subst",	0, kDur, gkFrqBase*(gkFrqTranform12Tone[gkSystemHarmony[kCurrEl][0]-1])
	 	event  	"i", 	"subst",	0, kDur, gkFrqBase*(gkFrqTranform12Tone[gkSystemHarmony[kCurrEl][1]-1])
	 	event  	"i", 	"subst",	0, kDur, gkFrqBase*(gkFrqTranform12Tone[gkSystemHarmony[kCurrEl][2]-1])
	 
		printk2 kCurrTickNumber
		printk2 kCurrTickStress
		;printk2 kMod2
		;printk2 kMod8
		printk2 kCurrEl
		;printk2 gkSystemHarmony[kCurrEl][0]-1
		
		kCurrTickNumber += 1


	endif	
endin


instr alt_stab_part
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
		if kDurLast <= kDurCurr && kPercent > (.5+kDivPercent) then ;strong position
			kCurrEl Markovk gkSFC2, 0
		else ;weak position
		 kCurrEl Markovk gkSFC2, 3
		endif
		;printk2 kDurCurr
		;printk2 kDurLast
		
		kStep	random 	.0, 2.5
		event  	"i", 	"harmonic_additive",	0, kDurCurr, 2*gkFrqBase*(gkFrqTranform12Tone[gkSystemHarmony[kCurrEl][kStep]-1]), .2
		kDurLast = kDurCurr
	endif
endin

instr subst
				iFrq = p4
        prints       "butlp%n"   ; indicate filter type in console
aSig    vco2         0.2, iFrq    ; input signal is a sawtooth waveform
kcf     expon        10000,p3,20 ; descending cutoff frequency
aSig    butlp        aSig, kcf   ; filter audio signal
        out          aSig        ; filtered audio sent to output
endin


instr harmonic_additive ;harmonic additive synthesis
;receive general pitch and volume from the score
ibasefrq  =         p4 
ibaseamp  =         p5 
aOsc1     poscil    ibaseamp, ibasefrq, 1
aOsc2     poscil    ibaseamp/2, ibasefrq*2, 1
aOsc3     poscil    ibaseamp/3, ibasefrq*3, 1
aOsc4     poscil    ibaseamp/4, ibasefrq*4, 1
aOsc5     poscil    ibaseamp/5, ibasefrq*5, 1
aOsc6     poscil    ibaseamp/6, ibasefrq*6, 1
aOsc7     poscil    ibaseamp/7, ibasefrq*7, 1
aOsc8     poscil    ibaseamp/8, ibasefrq*8, 1
;apply simple envelope
kenv      linen     1, p3/4, p3, p3/4
;add partials and write to output
aOut = aOsc1 + aOsc2 + aOsc3 + aOsc4 + aOsc5 + aOsc6 + aOsc7 + aOsc8
          out      aOut*kenv
    endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1

i "part_2bar" 0 120
i "alt_stab_part" 20 80

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
