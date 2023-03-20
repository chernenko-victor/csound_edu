<CsoundSynthesizer>
<CsOptions>
-odac  -m128
</CsOptions>
<CsInstruments>

sr  = 44100
ksmps = 32
nchnls  = 2
0dbfs   = 1

;giFFTSize	init 512
giFFTSize	init 16
giFFTBasePeriod = giFFTSize/sr
giFFTBaseFrq = 1/giFFTBasePeriod
gkArrFrq[] init giFFTSize
gkArrAmp[] init giFFTSize

instr SingleBin
 iBin = p4 //bin number
 aSig diskin "fox.wav"
 fSig pvsanal aSig, 1024, 256, 1024, 1
 kAmp, kFreq pvsbin fSig, iBin
 aBin poscil port(kAmp,.01), kFreq
 aBin *= iBin/10
 out aBin, aBin
endin

instr FourBins
 iCount = 1
 while iCount < 5 do
  schedule("SingleBin",0,3,iCount*10)
  iCount += 1
 od
endin

instr SlidingBins
 kBin randomi 1,50,200,3
 aSig diskin "fox.wav"
 fSig pvsanal aSig, 1024, 256, 1024, 1
 kAmp, kFreq pvsbin fSig, int(kBin)
 aBin poscil port(kAmp,.01), kFreq
 aBin *= kBin/10
 out aBin, aBin
endin


instr SingleBinDisplay
 iBin = p4 //bin number
 ;ifftsize  = p5
 ifftsize = giFFTSize
 ioverlap  = ifftsize / 4
 iwinsize  = ifftsize
 iwinshape = 1							;von-Hann window
 iFreq = p6
 kFlag init 1
 kTime timeinsts
 
 ;aSig diskin "fox.wav"
 aSig poscil 1, iFreq
 fSig pvsanal aSig, ifftsize, ioverlap, iwinsize, iwinshape
 kAmp, kFreq pvsbin fSig, iBin
 if kFlag == 1 && kTime > 0.004 then
		kFlag = 0
 		kBin = k(iBin-1)
 		gkArrFrq[kBin] = kFreq
 		gkArrAmp[kBin] = kAmp
 endif
 aBin poscil port(kAmp,.01), kFreq
 aBin *= iBin/10
 out aBin, aBin
endin

instr ShowBins
	kFlag init 1
	if kFlag == 1 then
		kFlag = 0
		printarray gkArrAmp
		printarray gkArrFrq
	endif
endin

instr NumberBins
 iCount = 1
 iNumBins = p4
 iFrq = p5
 while iCount < iNumBins do
  schedule("SingleBinDisplay",0,1,iCount,1024,iFrq)
  iCount += 1
 od
endin

</CsInstruments>
<CsScore>
;i "SingleBin" 0 3 10
;i . + . 20
;i . + . 30
;i . + . 40
;i "FourBins" 13 3
;i "SlidingBins" 17 3

;i "SingleBinDisplay" 0 1 1 1024 100

;=============== giFFTSize	init 16
;i "NumberBins" 0 2 15 100
;i "NumberBins" 0 2 15 350
;i "NumberBins" 0 2 15 600
i "NumberBins" 0 2 15 100

;=============== giFFTSize	init 512
;i "NumberBins" 0 2 20 50
;i "NumberBins" 0 2 20 100
;i "NumberBins" 0 2 20 200
;i "NumberBins" 0 2 20 300


i "ShowBins" 3 1

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
