<CsoundSynthesizer>

<CsOptions>
--env:SSDIR+=../SourceMaterials -odac
</CsOptions>

<CsInstruments>

sr     =  44100
ksmps  =  512
nchnls =  2
0dbfs  =  1

gaSigL init 0

 instr 1 ; sound file player
gaSigL, gaSigR           diskin2   p4,1,0,1
 endin

 instr 2 ; convolution reverb
; Define partion size.
; Larger values require less CPU but result in more latency.
; Smaller values produce lower latency but may cause -
; - realtime performance issues
ipartitionsize	=	  256
ar1	        pconvolve gaSigL, p4,ipartitionsize, 1
ar2	        pconvolve gaSigR, p4,ipartitionsize, 2
; create a delayed version of the input signal that will sync -
; - with convolution output
;adel            delay     gaSigL,ipartitionsize/sr
; create a dry/wet mix
;aMixL           ntrpol    adel,ar1*0.1,p5
;aMixR           ntrpol    adel,ar2*0.1,p5
;                outs      aMixL,aMixR
                outs      ar1*.03, ar2*.03
gaSigL	        =         0
gaSigR	        =         0
 endin

</CsInstruments>

<CsScore>
; instr 1. sound file player
;    p4=input soundfile
; instr 2. convolution reverb
;    p4=impulse response file
;    p5=dry/wet mix (0 - 1)

i 1 0 8.6 "loop.wav"
i 2 0 10 "Stairwell.wav" 0.3

i 1 10 8.6 "loop.wav"
i 2 10 10 "dish.wav" 0.8
e
</CsScore>

</CsoundSynthesizer>
