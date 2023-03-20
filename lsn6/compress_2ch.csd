<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
-odac  -iadc    ;;;RT audio out and in
; For Non-realtime ouput leave only the line below:
; -o compress.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2


instr 1	; uncompressed signal

asig diskin2 "beats.wav", 1, 0, 1
     outs asig, asig
endin


instr 2	; compressed signal.
; Use the "beats.wav" audio file and a mic
;avoice in
avoice, ar2 ins
asig   diskin2 "beats.wav", 1, 0, 1

; duck the audio signal "beats.wav" with your voice.
  kthresh = 0
  kloknee = 40
  khiknee = 60
  kratio  = 3
  katt    = 0.1
  krel    = .5
  ilook   = .02
asig  compress asig, avoice, kthresh, kloknee, khiknee, kratio, katt, krel, ilook	; voice-activated compressor
      outs asig, asig

endin

</CsInstruments>
<CsScore>

i 1 0 5

i 2 6 21

e
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
