<CsoundSynthesizer>
<CsOptions>
-odac
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 64
nchnls = 2
0dbfs = 1

giLvlMax init 5

instr tree

;iFrq	=	p4
iLvlCurr = p5
iDurNext random .25, 4.
iFrq random 200., 2000.
print iFrq, iLvlCurr

if giLvlMax >= iLvlCurr then
	iCnt = 0
	while iCnt <= iLvlCurr do
		print iCnt
		event_i "i", "tree", iDurNext, 10, iFrq, (iLvlCurr+1)
		iCnt += 1
	od
	event_i "i", "sound", 0, 10, iFrq
endif

endin

instr sound
	iFrq = p4
	aOut	oscili .05, iFrq
	outs aOut, aOut
endin
</CsInstruments>
<CsScore>

i "tree" 0 10 440. 0

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
