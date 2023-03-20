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
iPrdFft init .1
iWsiz init 1024
;read "fox.wav" in half speed and cross with classical guitar sample
fsigA     pvstanal  .5, giamp, gipitch, gifilA, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
fsigB     pvstanal  1, giamp, gipitch, gifilB, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
fvoc      pvsvoc    fsigA, fsigB, 1, 1	
aout      pvsynth   fvoc
aenv      linen     aout, .1, p3, .5
          out       aout
          dispfft 2*aout, iPrdFft, iWsiz
endin

instr 2
iPrdFft init .1
iWsiz init 1024
;read "fox.wav" in half speed and cross with clarinetto
fsigA2     pvstanal  .5, giamp, gipitch, gifilA, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
fsigB2     pvstanal  1, giamp, gipitch, gifilC, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
fvoc2      pvsvoc    fsigA2, fsigB2, 1, 1	
aout      pvsynth   fvoc2
aenv      linen     aout, .1, p3, .5
          out       aout
          dispfft 2*aout, iPrdFft, iWsiz
endin


instr 3
iPrdFft init .1
iWsiz init 1024
;read "fox.wav" in half speed and cross with clarinetto
fsigA2     pvstanal  1, giamp, gipitch, gifilA, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
fsigB2     pvstanal  1, giamp, gipitch, gifilB, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
                     
fsigC2     pvstanal  1, giamp, gipitch, gifilC, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh                     

aout      pvsynth   fsigA2
aenv      linen     aout, .1, p3, .5
          out       aout
          dispfft 2*aout, iPrdFft, iWsiz
endin


</CsInstruments>
<CsScore>
i 1 0 11

i 2 12 24

i 3 37 24
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
 <bsbObject type="BSBGraph" version="2">
  <objectName/>
  <x>19</x>
  <y>29</y>
  <width>750</width>
  <height>350</height>
  <uuid>{29dbae22-d358-4c49-a8d1-ee0f9a5d5300}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <value>5</value>
  <objectName2/>
  <zoomx>2.00000000</zoomx>
  <zoomy>2.00000000</zoomy>
  <dispx>1.00000000</dispx>
  <dispy>1.00000000</dispy>
  <modex>lin</modex>
  <modey>lin</modey>
  <showSelector>true</showSelector>
  <showGrid>true</showGrid>
  <showTableInfo>true</showTableInfo>
  <showScrollbars>true</showScrollbars>
  <enableTables>true</enableTables>
  <enableDisplays>true</enableDisplays>
  <all>true</all>
 </bsbObject>
</bsbPanel>
<bsbPresets>
</bsbPresets>
