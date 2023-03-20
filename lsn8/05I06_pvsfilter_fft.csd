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
gifilB    ftgen     1, 0, 0, 1, "BratscheMono.wav", 0, 0, 1
gifilC    ftgen     2, 0, 0, 1, "cl_solo_a1_mono.wav", 0, 0, 1

gifilD    ftgen     3, 0, 0, 1, "BratscheMono.wav", 0, 0, 1
gifilE    ftgen     4, 0, 0, 1, "339324__inspectorj__stream-water-c-mono.wav", 0, 0, 1
;D:\tmp\__music\sample\edu
gifilPf    ftgen     5, 0, 0, 1, "D:\\tmp\\__music\\sample\\edu\\68444__pinkyfinger__piano-eb.wav", 0, 0, 1
gifilTuba    ftgen     6, 0, 0, 1, "D:\\tmp\\__music\\sample\\edu\\501513__phonosupf__tuba-expression-4.wav", 0, 0, 1

;general values for the pvstanal opcode
giamp     =         1 ;amplitude scaling
gipitch   =         1 ;pitch scaling
gidet     =         0 ;onset detection
giwrap    =         1 ;loop reading
giskip    =         0 ;start at the beginning
gifftsiz  =         1024 ;fft size
giovlp    =         gifftsiz/4 ;overlap size
githresh  =         0 ;threshold

instr 1
;filters "fox.wav" (half speed) by the spectrum of the viola (double speed)
fsigA     pvstanal  .5, giamp, gipitch, gifilPf, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
/*
fsigB     pvstanal  2, 5, gipitch, gifilB, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
*/
fsigB     pvstanal  2, 5, gipitch*2, p4, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
ffilt     pvsfilter fsigA, fsigB, 1	
aout      pvsynth   ffilt
aenv      linen     aout, .1, p3, .5
          out       aout
endin

</CsInstruments>
<CsScore>
i 1 0 20 1
;s

;i 1 0 20 2
;s

;i 1 0 20 4
;s

;i 1 0 20 5
;s


;i 1 0 20 6
;s
</CsScore>
</CsoundSynthesizer> </p>
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
