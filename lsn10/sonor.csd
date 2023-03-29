<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1
  kAmp = 0.5
  ;kFrq mtof p4
  kFrq pow 2, ((p4 - 69)/12)
  kFrq = kFrq * 440
  kAmpMod = 100
  kFrqMod = 200
  iAtt = .05
  iRel = .1
  kAmpEnv linseg 0., iAtt, 1., p3 - iAtt - iRel, 1., iRel, 0.
  aMod oscili kAmpMod, kFrqMod + 100*kAmpEnv
  aRes oscili kAmp, kFrq + aMod
  outs aRes*kAmpEnv, aRes*kAmpEnv  
endin


instr 2 ; one note fith lfo
  kAmp = 0.5
  ;kFrq = mtof(p4)
  kFrq pow 2, ((p4 - 69)/12)
  kFrq = kFrq * 440
  kAmpMod = 100
  kFrqMod = 200
  iAtt = .05
  iRel = .1
  iAmpLFO = p5
  iFrqLFO = p6
  kLFO oscili iAmpLFO, iFrqLFO
  kAmpEnv linseg 0., iAtt, 1., p3 - iAtt - iRel, 1., iRel, 0.
  aMod oscili kAmpMod, kFrqMod + 100*kAmpEnv
  aRes oscili kAmp, kFrq + aMod + kLFO
  outs aRes*kAmpEnv, aRes*kAmpEnv  
endin


instr 3 ; one note with slide
  kAmp = 0.5
  ;kFrq = mtof(p4)
  kFrq pow 2, ((p4 - 69)/12)
  kFrq = kFrq * 440
  kAmpMod = 100
  kFrqMod = 200
  iAtt = .05
  iRel = .1
  iFrqEnd = p5
  kLFO line 0, p3, iFrqEnd
  kAmpEnv linseg 0., iAtt, 1., p3 - iAtt - iRel, 1., iRel, 0.
  aMod oscili kAmpMod, kFrqMod + 100*kAmpEnv
  aRes oscili kAmp, kFrq + aMod + kLFO
  outs aRes*kAmpEnv, aRes*kAmpEnv  
endin


instr 101 ;element 1
  ;iFlag init 1
  kDur = p3 ;duration on start
  kTrig metro 1/kDur ;metronome
  kMidiNote random 30, 100
  kLegato = .9 * p3
  if kTrig == 1 then
    ;iFlag = 0
    event "i", 1, 0, kLegato, kMidiNote
  endif 
endin

instr 102 ; element 2
  kDur = p3 ;duration on start
  kTrig metro 1/kDur ;metronome
  kMidiNote random 30, 100
  kMidiNote2 random kMidiNote + 4, kMidiNote + 12
  kMidiNote3 random kMidiNote2 + 4, kMidiNote2 + 12
  kLegato = .9 * p3
  if kTrig == 1 then
    ;iFlag = 0
    event "i", 1, 0, kLegato, kMidiNote
    event "i", 1, 0, kLegato, kMidiNote2
    event "i", 1, 0, kLegato, kMidiNote3
  endif
endin

instr 103; element 3 klaster
  kDur = p3 ;duration on start
  kTrig metro 1/kDur ;metronome
  kMidiNote random 30, 100
  kLegato = .9 * p3
  if kTrig == 1 then
    ;iFlag = 0
    event "i", 1, 0, kLegato, kMidiNote
    event "i", 1, 0, kLegato, kMidiNote + 2
    event "i", 1, 0, kLegato, kMidiNote + 4
    event "i", 1, 0, kLegato, kMidiNote + 6
  endif
endin


instr 104 ;element 4 one note lfo
  ;iFlag init 1
  kDur = p3 ;duration on start
  kTrig metro 1/kDur ;metronome
  kMidiNote random 30, 100
  kAmpLFO random 10, 100
  kFrqLFO random 0.3, 2
  kLegato = .9 * p3
  if kTrig == 1 then
    ;iFlag = 0
    event "i", 2, 0, kLegato, kMidiNote, kAmpLFO, kFrqLFO
  endif 
endin

instr 105 ; element 5 accord slide
  kDur = p3 ;duration on start
  kTrig metro 1/kDur ;metronome
  kMidiNote random 30, 100
  kMidiNote2 random kMidiNote + 4, kMidiNote + 12
  kMidiNote3 random kMidiNote2 + 4, kMidiNote2 + 12
  kFrqSlideEnd random 20, 200
  kLegato = .9 * p3
  if kTrig == 1 then
    ;iFlag = 0
    event "i", 3, 0, kLegato, kMidiNote, kFrqSlideEnd
    event "i", 3, 0, kLegato, kMidiNote2, kFrqSlideEnd
    event "i", 3, 0, kLegato, kMidiNote3, kFrqSlideEnd
  endif
endin

instr 106 ;element 6 klaster lfo
  ;iFlag init 1
  kDur = p3 ;duration on start
  kTrig metro 1/kDur ;metronome
  kMidiNote random 30, 100
  kAmpLFO random 10, 100
  kFrqLFO random 0.3, 2
  kLegato = .9 * p3
  if kTrig == 1 then
    ;iFlag = 0
    event "i", 2, 0, kLegato, kMidiNote, kAmpLFO, kFrqLFO
    event "i", 2, 0, kLegato, kMidiNote + 2, kAmpLFO, kFrqLFO
    event "i", 2, 0, kLegato, kMidiNote + 4, kAmpLFO, kFrqLFO
    event "i", 2, 0, kLegato, kMidiNote + 6, kAmpLFO, kFrqLFO
  endif 
endin

</CsInstruments>
<CsScore>
;i 2 0 3 60 20 .3
;i 2 4 3 72 50 .5
i 105 0 3
i 105 4 3
;i 3 0 3 60 50
;i 3 4 3 72 100
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
