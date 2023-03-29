Noise white => LPF lowPass => ADSR adsr => Gain g => dac;
lowPass.freq(10000); // cut off frequency in Hz - 2nd order Butterworth filter
lowPass.Q(50);
adsr.set(2::ms, 250::ms, 0.75, 500::ms);
g.gain(0.25);
//----------MAIN-----------
while( true ){
    Math.random2(48, 72) => int midiNote;
    Std.mtof(midiNote) => float cutOff;
    lowPass.freq(cutOff);
    adsr.keyOn();
    <<< "MIDI note: " + midiNote + " Hz: " + cutOff >>>;
    500::ms => now;
    adsr.keyOff();
    700::ms => now;
}
