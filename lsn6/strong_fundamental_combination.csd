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
 
 kFrqBase init 440.

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
	 	event  	"i", 	"subst",	0, kDur, kFrqBase*(gkFrqTranform12Tone[gkSystemHarmony[kCurrEl][0]-1])
	 	event  	"i", 	"subst",	0, kDur, kFrqBase*(gkFrqTranform12Tone[gkSystemHarmony[kCurrEl][1]-1])
	 	event  	"i", 	"subst",	0, kDur, kFrqBase*(gkFrqTranform12Tone[gkSystemHarmony[kCurrEl][2]-1])
	 
		printk2 kCurrTickNumber
		printk2 kCurrTickStress
		;printk2 kMod2
		;printk2 kMod8
		printk2 kCurrEl
		;printk2 gkSystemHarmony[kCurrEl][0]-1
		
		kCurrTickNumber += 1


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

</CsInstruments>
<CsScore>

i "part_2bar" 0 120

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
