<CsoundSynthesizer>
<CsOptions>
-odac --env:SSDIR+=../SourceMaterials
</CsOptions>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

;store the samples in function tables (buffers)
gifilA    ftgen     0, 0, 0, 1, "BratscheMono.wav", 0, 0, 1
gifilB    ftgen     0, 0, 0, 1, "fox.wav", 0, 0, 1
gifilC    ftgen     0, 0, 0, 1, "cl_solo_a1_mono.wav", 0, 0, 1
gifilD    ftgen     0, 0, 0, 1, "BratscheMono.wav", 0, 0, 1
gifilE    ftgen     0, 0, 0, 1, "339324__inspectorj__stream-water-c-mono.wav", 0, 0, 1
;D:\tmp\__music\sample\edu
gifilPf    ftgen     0, 0, 0, 1, "D:\\tmp\\__music\\sample\\edu\\68444__pinkyfinger__piano-eb.wav", 0, 0, 1
gifilTuba    ftgen     0, 0, 0, 1, "D:\\tmp\\__music\\sample\\edu\\501513__phonosupf__tuba-expression-4.wav", 0, 0, 1


giPrdFft init .1
giWsiz init 1024

;general values for the pvstanal opcode
giamp     =         1 ;amplitude scaling
gipitch   =         1 ;pitch scaling
gidet     =         0 ;onset detection
giwrap    =         1 ;loop reading
giskip    =         0 ;start at the beginning
gifftsiz  =         1024 ;fft size
giovlp    =         gifftsiz/8 ;overlap size
githresh  =         0 ;threshold

;Combine the frequencies of sound A with the amplitudes of sound A and B

instr 1
;cross viola with "fox.wav" in half speed
fsigA     pvstanal  1, giamp, gipitch, gifilA, gidet, giwrap, giskip,                    gifftsiz, giovlp, githresh
fsigB     pvstanal  .5, giamp, gipitch, gifilB, gidet, giwrap, giskip,                     gifftsiz, giovlp, githresh
fcross    pvscross  fsigA, fsigB, 0, 1
aout      pvsynth   fcross
aenv      linen     aout, .1, p3, .5
          out       aenv
          dispfft 2*aout, giPrdFft, giWsiz
endin

instr 2
;cross Cl. with "fox.wav" in half speed
fsigA     pvstanal  1, giamp, gipitch, gifilC, gidet, giwrap, giskip,                    gifftsiz, giovlp, githresh
fsigB     pvstanal  .5, giamp, gipitch, gifilB, gidet, giwrap, giskip,                     gifftsiz, giovlp, githresh
fcross    pvscross  fsigA, fsigB, 0, 1
aout      pvsynth   fcross
aenv      linen     aout, .1, p3, .5
          out       aenv
          dispfft 2*aout, giPrdFft, giWsiz
endin

</CsInstruments>
<CsScore>
i 1 0 11

i 2 13 11
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
 <bsbObject version="2" type="BSBGraph">
  <objectName/>
  <x>24</x>
  <y>23</y>
  <width>767</width>
  <height>421</height>
  <uuid>{320e01e9-e2c6-4107-8490-1ceb55a567a0}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <value>0</value>
  <objectName2/>
  <zoomx>1.00000000</zoomx>
  <zoomy>1.00000000</zoomy>
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
