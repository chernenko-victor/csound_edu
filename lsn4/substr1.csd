<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1


instr gen
	kTrig init 0.25
	kTridm metro kTrig
	if    kTridm == 1 then 
		event "i", 1, 0, 4, kTrig*200
		kTrig random .5, 0.25
	endif
endin


instr 1
iFrq = p4
kres expseg 800, p3, 1500
kres2 line 500, p3, 10000
kres3 linseg 40, p3, 2
kresOsc oscili 100, .5
kEnvAmp linseg .001, p3/2, 1, p3/2, 0.001

;asig  noise .3, 0
asig vco2 1, iFrq 
asig  atone asig, kres2
asig  reson asig, kres, kresOsc+110
      out asig * kEnvAmp

endin 


</CsInstruments>
<CsScore>
;i 1 0 4
;i 1 5 2
i "gen" 0 300
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
