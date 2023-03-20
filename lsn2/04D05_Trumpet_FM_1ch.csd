<CsoundSynthesizer>
<CsOptions>
-o dac
</CsOptions>
<CsInstruments>
sr = 48000
ksmps = 32
nchnls = 1
0dbfs = 1

instr 1  ; simple way to generate a trumpet-like sound
kCarFreq = p4
kModFreq = 440
kIndex = 5
kIndexM = 0
kMaxDev = kIndex*kModFreq
kMinDev = kIndexM * kModFreq
kVarDev = kMaxDev-kMinDev
aEnv expseg .001, 0.2, 1, p3-0.3, 1, 0.2, 0.001
aModAmp = kMinDev+kVarDev*aEnv
aModulator poscil aModAmp, kModFreq, 1
aCarrier poscil 0.3*aEnv, kCarFreq+aModulator, 1
out aCarrier
endin


</CsInstruments>
<CsScore>
f 1 0 1024 10 1 		;Sine wave for table 1
i 1 0 5 440
i 1 6 5 880
i 1 12 5 220
</CsScore>
</CsoundSynthesizer>
; written by Alex Hofmann (Mar. 2011)
