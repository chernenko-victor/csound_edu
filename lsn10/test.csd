<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1.0

kArr[] init 4
kArr fillarray 1, 2, 3, 4

gkWeight[] init 4
gkWeight fillarray .3, .2, .1, .4


gkFrqBase[] init 4
gkFrqBase fillarray 440.0, 220., 330, 880

opcode DiscrDistr, k, k[]
  kDiscrArr[] xin
  kranrr random 0, 1
  kIndex = 0
  kSumma = kDiscrArr[kIndex]
  while kSumma<=kranrr do
    kIndex = kIndex + 1
    kSumma = kSumma + kDiscrArr[kIndex]
    ;printk2 kIndex
    ;printk2 kSumma
  od
    ;printk2 iStart
  xout kIndex
endop	

instr part
  kMetroFrq init 1
  kTrig metro kMetroFrq
  if kTrig == 1 then
    kRes DiscrDistr gkWeight
	   printk2 gkFrqBase[kRes]
	   event "i", 201, 0, .9, .2, gkFrqBase[kRes], 8
  endif
endin

instr 101
  iAmp = p4
  iFrq = p5
  iAttTime = p6
  kAmpVar rspline 0.005, 0.05, 10, 30
  kFrqVar rspline 5, 10, 20, 40
  kAmpEnv linseg 0, iAttTime, 1, (p3 - iAttTime - 0.3), 1, 0.3, 0
  aOut oscili iAmp + kAmpVar, iFrq + kFrqVar
  outs aOut*kAmpEnv, aOut*kAmpEnv
endin

instr 201
  iAmp = p4
  iFrq = p5
  iDur = p3
  iObertNum = p6
  iIndex = 0
begin:   
  iAttTime = 0.1 * (iIndex + 1)
  event_i "i", 101, 						0, 			iDur, 	iAmp / (iIndex + 1)		,  iFrq * (iIndex + 1), iAttTime
  iIndex = iIndex + 1
  if iIndex < iObertNum then
  	goto begin
  endif
endin

</CsInstruments>
<CsScore>

i "part" 0 20

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
