<CsoundSynthesizer>
<CsOptions>
; Select audio/midi flags here according to platform
; Audio out   Audio in    No messages
-odac           -iadc    ; -d     ;;;RT audio I/O
; For Non-realtime ouput leave only the line below:
; -o linseg.wav -W ;;; for file output any platform
</CsOptions>
<CsInstruments>
;*******************************
sr=48000
kr=480
ksmps=100
nchnls=1

        FLpanel         "Panel1",450,550,100,100 ;***** start of container
gk1,iha FLslider        "FLslider 1", 500, 1000, 0 ,1, -1, 300,15, 20,50
        FLpanelEnd      ;***** end of container

        FLpanel         "Panel2",450,550,100,100 ;***** start of container
gk2,ihb FLslider        "FLslider 2", 100, 200, 0 ,1, -1, 300,15, 20,50
        FLpanelEnd      ;***** end of container

        FLrun           ;***** runs the widget thread, it is always required!

instr 1
; gk1 and gk2 variables that contain the output of valuator
; widgets previously defined, can be used inside any instrument
printk2 gk1
printk2 gk2   ;print the values of the valuators whenever they change
endin
;*******************************
</CsInstruments>
<CsScore>
f 0 3600 ;dummy table for realtime input
e

</CsScore>
</CsoundSynthesizer>