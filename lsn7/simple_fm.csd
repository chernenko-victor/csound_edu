<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 32
nchnls = 2
0dbfs = 1

instr 1
iModAmp = p4
iModFrq = p5
aMod poscil iModAmp, iModFrq, 1 
aCar poscil 0.3, 440+aMod, 1
outs aCar, aCar
endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1 		;Sine wave for table 1

;   		FM Amplitude	FM Frequency
i 1 0	2	10				5  ; 5 Hz vibrato with 10 Hz modulation-width
i 1 ^+3	2	90				5  ; 5 Hz vibrato with 90 Hz modulation-width
i 1 ^+3	2	10				50 ; 50 Hz vibrato with 10 Hz modulation-width
i 1 ^+3	2	10				100 ; 100 Hz vibrato with 10 Hz modulation-width
i 1 ^+3	2	10				220 ; 220 Hz vibrato with 10 Hz modulation-width

</CsScore>
</CsoundSynthesizer>