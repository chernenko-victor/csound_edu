<CsoundSynthesizer>
<CsOptions>
-odac  -d   
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

giSine    ftgen     0, 0, 2^10, 10, 1


instr part
	iInstrNum = p4
	kPeriod		init 	2.
	kTrig			metro	1/kPeriod
	kAmpEnv oscil .45, .33, giSine
	
	if kTrig == 1 then	
		event  "i", iInstrNum, 0, kPeriod*.8, 440, .5 + kAmpEnv
	endif
endin

instr simple_fm
	iAmp = p5
	iFrq = p4
	print iAmp
	aOscMod     poscil    10, 100, giSine
	kenv      linen     1, p3/4, p3, p3/4
	aOsc1     poscil    iAmp, iFrq + aOscMod, giSine
			  out      aOsc1*kenv
endin


instr simple_fm_dam
	iAmp = p5
	iFrq = p4
	
	;kthreshold = 0.4
	;icomp1 = .05
	;icomp2 = 3.5
	
	kthreshold = 0.2
	icomp1 = .05
	icomp2 = 5.5
	
	irtime = 0.01
	iftime = 0.5

	print iAmp
	aOscMod     poscil    10, 100, giSine
	kenv      linen     1, p3/4, p3, p3/4
	aOsc1     poscil    iAmp, iFrq + aOscMod, giSine
	aComp dam aOsc1*kenv, kthreshold, icomp1, icomp2, irtime, iftime
			  out      aComp
endin

</CsInstruments>
<CsScore>
i "part" 0 20 2
i "part" 22 20 3
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
