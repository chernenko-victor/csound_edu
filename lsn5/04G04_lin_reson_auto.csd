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

; simple damped nonlinear resonator
opcode nonlin_reson, a, akki
setksmps 1
avel 	init 0			;velocity
adef 	init 0			;deflection
ain,kc,kdamp,ifn xin
aacel 	tablei 	adef, ifn, 1, .5 ;acceleration = -c1*f1(def)
aacel 	= 	-kc*aacel
avel 	= 	avel+aacel+ain	;vel += acel + excitation
avel 	= 	avel*(1-kdamp)
adef 	= 	adef+avel
	xout 	adef
endop


instr part
	kDur			init 	1
	;kFlag		init 	1
	
	kTrig			metro	1/kDur
	kEnvStart		linseg 1, 2*p3/3, 2, p3/3, 1
	kEnvEnd		linseg 2, 2*p3/3, 4, p3/3, 2
	
	/*
	if kFlag == 1 then
			kFlag = 0
	endif
	
	kSecLast timeinsts
	*/
	
	if kTrig == 1 then		
		kFrq 		random 	110, 880
		kExcitaion 		random 	.0001, .00025
		kDamping 		random 	.0001, .00025
		
		if p4==101 then
		 kDur 		random 	kEnvStart, kEnvEnd
			event  	"i", 	101,	0, kDur*0.8, kExcitaion, kFrq, kDamping
		elseif p4==102 then
			kDur 		random 	kEnvStart*2, kEnvEnd*2
		 kTblNum	random 1, 3.5
		 kC1 	random .01, 0.05
		 event  	"i", 	102,	0, kDur*0.8, kExcitaion, kC1, kDamping, 3
		 else 
		  kDur 		random 	kEnvStart*2, kEnvEnd*2
		  kPres		random		0.1, 2
		  event  	"i", 	103,	0, kDur*1.2, kFrq, kPres
		endif
		
		;   		excitation  	c1    	damping ifn
;i1 0 20   	.0001      	.01   	.00001   3
	endif
	
	;gkTotalLen	linseg .0, p3, 1.
	
	;aSigL, aSigR 	monitor ; read audio from output bus
	;						fout 			"render.wav", 4, aSigL, aSigR 
endin


instr 101
aexc 	rand 	p4
kAmpEnv adsr p3/10, p3/5, .2, p3/5
aout 	lin_reson 	aexc,p5,p6
	out 	aout*kAmpEnv
endin

instr 102
kenv 	oscil 		p4,.5,1
aexc 	rand 		kenv
kAmpEnv adsr p3/10, p3/5, .7, p3/5
aout 	nonlin_reson 	aexc,p5,p6,p7
	out 		aout*kAmpEnv
endin


instr 103 ; wgbow instrument
kamp     =        0.1
kfreq    =        p4
kpres    =        p5
krat     rspline  0.006,0.988,0.1,0.4
kvibf    =        4.5
kvibamp  =        0
iminfreq =        20
aSig	 wgbow    kamp, kfreq, kpres, krat, kvibf, kvibamp, 1, iminfreq
;aSig     butlp     aSig,2000
;aSig     pareq    aSig,80,6,0.707
         out     aSig

 endin


</CsInstruments>
<CsScore>
f1 0 1024 10 1
f2 0 1024 7 -1 510 .15 4 -.15 510 1
f3 0 1024 7 -1 350 .1 100 -.3 100 .2 100 -.1 354 1


i 		"part" 		0 		19 101
i 		"part" 		20 		19 102

i 		"part" 		40 		19 101
i 		"part" 		40 		19 102
s
i 		"part" 		0 		30 103
i 		"part" 		10 		19 101
</CsScore>
</CsoundSynthesizer>
;example by martin neukom
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
