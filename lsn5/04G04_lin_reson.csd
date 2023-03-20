<CsoundSynthesizer>
<CsInstruments>
sr = 44100
ksmps = 32
nchnls = 1
0dbfs = 1

opcode 	lin_reson, 	a, akk
setksmps 1
avel 	init 	0 		;velocity
ax 	init 	0 		;deflection x
ain,kf,kdamp 	xin
kc 	= 	2-sqrt(4-kdamp^2)*cos(kf*2*$M_PI/sr)
aacel 	= 	-kc*ax
avel 	= 	avel+aacel+ain
avel 	= 	avel*(1-kdamp)
ax 	= 	ax+avel
	xout 	ax
endop

instr 1
kRndRange	rspline p4*.5, p4*2, .5, 3
aexc 		rand 	kRndRange
;kFrqEnv 	line 	p5, p3, 2*p5
kFrqEnv		rspline p5*.9, p5*1.1, .5, 3
kDampEnv 	rspline p6*.5, p6*30, .3, 2
;kDampEnv	line p6*.5, p3, p6*20 	
aout 		lin_reson 	aexc, kFrqEnv, kDampEnv
		out 	aout
endin

</CsInstruments>
<CsScore>
; 			p4 		p5 	p6
; 			excitaion 	freq 	damping
i1 0 10 		.0001   	440 	.0001
</CsScore>
</CsoundSynthesizer>
;example by martin neukom
