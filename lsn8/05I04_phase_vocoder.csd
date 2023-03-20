<CsoundSynthesizer>
<CsOptions>
--env:SSDIR+=../SourceMaterials -odac
</CsOptions>
<CsInstruments>
;example by joachim heintz
sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

;store the samples in function tables (buffers)
gifilA    ftgen     0, 0, 0, 1, "fox.wav", 0, 0, 1
gifilB    ftgen     0, 0, 0, 1, "ClassGuit.wav", 0, 0, 1
gifilC    ftgen     0, 0, 0, 1, "cl_solo_a1_mono.wav", 0, 0, 1


;general values for the pvstanal opcode
giamp     =         1 ;amplitude scaling
gipitch   =         1 ;pitch scaling
gidet     =         0 ;onset detection
giwrap    =         1 ;loop reading
giskip    =         0 ;start at the beginning
gifftsiz  =         1024 ;fft size
giovlp    =         gifftsiz/8 ;overlap size
githresh  =         0 ;threshold

instr 1
;read "fox.wav" in half speed and cross with classical guitar sample
fsigA     pvstanal  .5, giamp, gipitch, gifilA, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
fsigB     pvstanal  1, giamp, gipitch, gifilB, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
fvoc      pvsvoc    fsigA, fsigB, 1, 1	
aout      pvsynth   fvoc
aenv      linen     aout, .1, p3, .5
          out       aout
endin

instr 2
;read "fox.wav" in half speed and cross with clarinetto
fsigA2     pvstanal  .5, giamp, gipitch, gifilA, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
fsigB2     pvstanal  1, giamp, gipitch, gifilC, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
fvoc2      pvsvoc    fsigA2, fsigB2, 1, 1	
aout      pvsynth   fvoc2
aenv      linen     aout, .1, p3, .5
          out       aout
endin


</CsInstruments>
<CsScore>
i 1 0 11

i 2 12 24
</CsScore>
</CsoundSynthesizer>
