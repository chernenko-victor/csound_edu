<CsoundSynthesizer>
<CsOptions>
--env:SSDIR+=../SourceMaterials -d -odac -m0
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

instr generate
 ;get seed: 0 = seeding from system clock
 ;          otherwise = fixed seed
           seed       p4
 ;generate four notes to be played from subinstrument
iNoteCount =          0
 until iNoteCount == 4 do


iFreq1 random 400, 800  
iFreq2 random 400, 800  
if (iFreq1>iFreq2) then 
  iFreq3 = iFreq1 
else 
  iFreq3 = iFreq2
endif


           event_i    "i", "play", iNoteCount, 2, iFreq3
           
iNoteCount +=         1 ;increase note count
 enduntil

endin

instr play
iFreq      =          p4
           print      iFreq
aImp       mpulse     .5, p3
aMode      mode       aImp, iFreq, 1000
aEnv       linen      aMode, 0.01, p3, p3-0.01
           outs       aEnv
endin
</CsInstruments>
<CsScore>
;repeat three times with fixed seed
r 3
i "generate" 0 2 1
;repeat three times with seed from the system clock
r 3
i "generate" 0 1 0
</CsScore>
</CsoundSynthesizer>
;example by joachim heintz
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
