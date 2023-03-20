<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

giSine    ftgen     0, 0, 2^10, 10, 1

instr 10 ;subinstrument for playing one partial
	ifreq     =         p4 ;frequency of this partial
	iamp      =         p5 ;amplitude of this partial
	imult 				=									p6
	;aenv      transeg   0, .01, 0, iamp, p3-0.1, -10, 0
	;aenv 				linseg 				0, p3*.1, iamp
	aenv linseg 0, p3*0.1, iamp, p3*0.25, iamp*.8, p3*0.4, iamp*.8, p3*0.25, 0
	apart     poscil    aenv, ifreq*imult, giSine
	out      apart
endin

</CsInstruments>
<CsScore>

;missing fundamental
i 10 0 5 100 .1	1
i 10 0 5 200 .3	.
i 10 0 5 300 .3	.
i 10 0 5 400 .3	.
s

i 10 0 5 200 .3	1
i 10 0 5 300 .3	.
i 10 0 5 400 .3	.
s


;missing fundamental odd harmonics
i 10 0 5 100 .1	1
i 10 0 5 300 .3	.
i 10 0 5 500 .3	.
i 10 0 5 700 .3	.
s

i 10 0 5 300 .3	1
i 10 0 5 500 .3	.
i 10 0 5 700 .3	.
s
/* */

/* */
;missing fundamental high pitch
i 10 1 5 100 .1	4
i . . . 200 .3	.
i . . . 300 .3	.
i . . . 400 .3	.
s

i 10 1 5 200 .3	4
i . . . 300 .3	.
i . . . 400 .3	.
s
/* */


/* */
;missing fundamental - high harmonics isn't separable 
;by filters in cochlea
i 10 1 5 100 .2	2
i . . . 200 .2	.
i . . . 300 .18	.
i . . . 400 .16	.
i . . . 500 .14	.
i . . . 600 .12	.
i . . . 700 .1	.
s

i 10 1 5 300 .18	2
i . . . 400 .16	.
i . . . 500 .14	.
i . . . 600 .12	.
i . . . 700 .1	.
s
/* */

/* */
;high fundamental recognition
i 10 1 5 100 .2	55
i . . . 200 .2	.
i . . . 300 .18	.
s

i 10 1 5 200 .2	56
i . . . 300 .2	.
s
/* */

/* */
;low pitch differense recognition
i 10 1 5 100 .2	1
i . . . 200 .2	.
i . . . 300 .18	.
i . . . 400 .16	.
i . . . 500 .14	.
i . . . 600 .12	.
i . . . 700 .1	.
s

i 10 1 5 100 .2	1.02
i . . . 200 .2	.
i . . . 300 .18	.
i . . . 400 .16	.
i . . . 500 .14	.
i . . . 600 .12	.
i . . . 700 .1	.
s


i 10 1 5 100 .2	1.04
i . . . 200 .2	.
i . . . 300 .18	.
i . . . 400 .16	.
i . . . 500 .14	.
i . . . 600 .12	.
i . . . 700 .1	.
s
/* */


;low pitch differense recognition
i 10 1 5 100 .2	20
i . . . 200 .2	.
i . . . 300 .18	.
i . . . 400 .16	.
i . . . 500 .14	.
i . . . 600 .12	.
i . . . 700 .1	.
s

i 10 1 5 100 .2	20.04
i . . . 200 .2	.
i . . . 300 .18	.
i . . . 400 .16	.
i . . . 500 .14	.
i . . . 600 .12	.
i . . . 700 .1	.
s


i 10 1 5 100 .2	20.2
i . . . 200 .2	.
i . . . 300 .18	.
i . . . 400 .16	.
i . . . 500 .14	.
i . . . 600 .12	.
i . . . 700 .1	.

s  
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
