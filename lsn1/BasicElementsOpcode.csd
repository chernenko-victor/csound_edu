/*Getting started.. 1.3 Basic Elements: Opcodes

The fundamental building blocks of a Csound instrument is the opcode. 
Each opcode can be seen as little program itself, that does a specific task. Opcodes get a bold-blue highlighting in the CsoundQt editor. In this example 'line', 'expon', 'oscil', 'outvalue' and 'outs', are the opcodes used.

The names of opcodes are usually a short form of their functionality.
'line' -  generates a linear changing value between specified points
'expon' - generates a exponential curve between two points
'oscil' - is a tone generator (an oscillator)
'outvalue' - sends a value to a user defined channel, in this case to the widget display
'outs' - writes stereo audio data to an external audio device

It is important to remember that opcodes receive their input arguments on the right and output their results on the left, like this:

output Opcode input1, input2

*/

<CsoundSynthesizer>
<CsOptions>
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 1
0dbfs = 1

instr 1
kFreq line 100, 5, 1000 		; 'line' generates a linear ramp, from 100-1000 Hz, taking 5 seconds
aOut  oscili 0.2, kFreq, 1	; an oscillator whose frequency is taken from the value produced by 'line'
	outvalue "freqsweep", kFreq   ; show the value from 'line' in a widget
     outs aOut			 ; send the oscillator's audio to the audio output
endin


instr 2
kFreq expon 100, 5, 1000 		; the 'expon' exponential curve is more useful when working with frequencies
aOut  oscili 0.2, kFreq, 1
	outvalue "freqsweep", kFreq
	outs aOut, aOut
endin

</CsInstruments>
<CsScore>
f 1 0 1024 10 1 				; the basic sine waveform for the oscillator is generated here 
i 1 0 5
i 2 5 5					; the exponential curve goes more even thought the octaves
e
</CsScore>
</CsoundSynthesizer>

