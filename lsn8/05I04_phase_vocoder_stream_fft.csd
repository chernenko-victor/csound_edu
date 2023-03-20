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
gifilD    ftgen     0, 0, 0, 1, "BratscheMono.wav", 0, 0, 1
gifilE    ftgen     0, 0, 0, 1, "339324__inspectorj__stream-water-c-mono.wav", 0, 0, 1
;D:\tmp\__music\sample\edu
gifilPf    ftgen     0, 0, 0, 1, "D:\\tmp\\__music\\sample\\edu\\68444__pinkyfinger__piano-eb.wav", 0, 0, 1

;f # time size 9 pna stra phsa
giAdd1		ftgen		4, 0, 2^11, 9, 1, 1, 0,			2, .3, 0, 	3, 1, 0, 		4, .1, 0, 		5, 1, 0			
giAdd2		ftgen		5, 0, 2^11, 9, 1, 0.1, 0,		2, 1, 0, 				 			4, .1, 0, 		5, 1, 0

;general values for the pvstanal opcode
giamp     =         1 ;amplitude scaling
gipitch   =         1 ;pitch scaling
gidet     =         0 ;onset detection
giwrap    =         1 ;loop reading
giskip    =         0 ;start at the beginning
gifftsiz  =         1024 ;fft size
giovlp    =         gifftsiz/8 ;overlap size
githresh  =         0 ;threshold
giwintyp  =         1 ;von hann window

instr 1
iPrdFft init .1
iWsiz init 1024
;read "fox.wav" in half speed and cross with classical guitar sample
;Combine the amplitudes of sound A with the frequencies of sound B
fsigA     pvstanal  .5, giamp, gipitch, gifilA, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
fsigB     pvstanal  1, giamp, gipitch, gifilB, gidet, giwrap, giskip,\
                     gifftsiz, giovlp, githresh
fvoc      pvsvoc    fsigA, fsigB, 1, 1	
aout      pvsynth   fvoc
aenv      linen     aout, .1, p3, .5
          out       aout
          fout "fox_pvsvoc.wav",4,aout
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


instr ampA2freqB
				iPrdFft init .1
				iWsiz init 1024

				aSigA		oscil 1, 440, giAdd1
				aSigB		oscil 1, 440, giAdd2
					
				fSigA     pvsanal   aSigA, gifftsiz, giovlp, gifftsiz*2, giwintyp
				fSigB     pvsanal   aSigB, gifftsiz, giovlp, gifftsiz*2, giwintyp
				
				fvoc2     pvsvoc    fSigA, fSigB, 1, 1
				aout      pvsynth   fvoc2
				out       aout
         dispfft 2*aout, iPrdFft, iWsiz
endin


instr freqA2ampB
				iPrdFft init .1
				iWsiz init 1024

				aSigA		oscil 1, 440, giAdd1
				aSigB		oscil 1, 440, giAdd2
				
				fSigA     pvsanal   aSigA, gifftsiz, giovlp, gifftsiz*2, giwintyp
				fSigB     pvsanal   aSigB, gifftsiz, giovlp, gifftsiz*2, giwintyp
				
				fvoc2     pvscross    fSigA, fSigB, 1, 1
				aout      pvsynth   fvoc2
				out       aout
				fout "freqA2ampB.wav",4,aout
         dispfft 2*aout, iPrdFft, iWsiz
endin


</CsInstruments>
<CsScore>
;i 1 0 24
;s

;i 2 0 24
;s

i 3 0 24
s
;i "ampA2freqB" 0 20

;i "freqA2ampB" 0 20
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
  <x>19</x>
  <y>29</y>
  <width>750</width>
  <height>350</height>
  <uuid>{29dbae22-d358-4c49-a8d1-ee0f9a5d5300}</uuid>
  <visible>true</visible>
  <midichan>0</midichan>
  <midicc>-3</midicc>
  <description/>
  <value>7</value>
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
