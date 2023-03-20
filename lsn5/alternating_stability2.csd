<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

#include "..\..\dev2\csound\include\math\stochastic\distribution3.inc.csd"
#include "..\..\dev2\csound\include\math\stochastic\util.inc.csd"
#include "..\..\dev2\csound\include\utils\table.v1.csd"

/*
types of distribution
1 = uniform
2 = linrnd_low ;linear random with precedence of lower values
3 = linrnd_high ;linear random with precedence of higher values
4 = trirnd ;for triangular distribution

5 = linrnd_low_depth ;linear random with precedence of lower values with depth
6 = linrnd_high_depth ;linear random with precedence of higher values with depth
7 = trirnd_depth ;for triangular distribution with depth
*/

gkDistr[]				fillarray	.125, .125, .125, .125, .125, .125, .125, .125

instr test
	;get_discr_distr_k, k, ikkkkk[]
	;iSeedType, kTypeOfDistrib, kMin, kMax, kDistribDepth, kLine[] xin
	kRnd get_discr_distr_k 0, 5, 0, 1, 3, gkDistr 
	printk .1, kRnd
endin
</CsInstruments>
<CsScore>
i "test" 0 1
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
