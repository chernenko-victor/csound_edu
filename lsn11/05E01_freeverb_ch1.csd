<CsoundSynthesizer>

<CsOptions>
--env:SSDIR+=../SourceMaterials -odac ; activates real time sound output
</CsOptions>

<CsInstruments>
;Example by Iain McCurdy

sr =  44100
ksmps = 32
nchnls = 1
0dbfs = 1

gaRvbSend    init      0 ; global audio variable initialized to zero

  instr 1 ; sound generating instrument (sparse noise bursts)
kEnv         loopseg   0.5,0,0,1,0.003,1,0.0001,0,0.9969,0,0; amp. env.
aSig         pinkish   kEnv              ; noise pulses
kAmpOsc 	 oscil .39, .1
             outs      aSig * (1 - (kAmpOsc + 0.5))       ; audio to outs
iRvbSendAmt  =         0.8               ; reverb send amount (0 - 1)
; add some of the audio from this instrument to the global reverb send variable
gaRvbSend    =         gaRvbSend + (aSig * iRvbSendAmt)
  endin

  instr 5 ; reverb - always on
kroomsize    init      0.85          ; room size (range 0 to 1)
kHFDamp      init      0.5           ; high freq. damping (range 0 to 1)
; create reverberated version of input signal (note stereo input and output)
aRvbL,aRvbR  freeverb  gaRvbSend, gaRvbSend,kroomsize,kHFDamp
             outs      aRvbL ; send audio to outputs
             clear     gaRvbSend    ; clear global audio variable
kSizeOsc 	 oscil .49, .1
kHFDampOsc 	 oscil .49, .03

kroomsize	= kSizeOsc + .5
kHFDamp	= kHFDampOsc + .5
  endin

</CsInstruments>

<CsScore>
i 1 0 300 ; noise pulses (input sound)
i 5 0 300 ; start reverb
e
</CsScore>

</CsoundSynthesizer>
