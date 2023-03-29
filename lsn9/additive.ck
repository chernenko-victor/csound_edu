SinOsc osc1 => Envelope env => Gain g => dac;
SinOsc osc2 => env;
SinOsc osc3 => env;
float freq1; // osc1 freq in Hz
float freq2; // osc2 freq in Hz
float freq3; // osc3 freq in Hz
0.5 => float envTime; // envelope time in seconds
g.gain(0.3); // amplitude = 1/(number of oscillators)
//----------MAIN-----------
while( true ){
    Math.random2f(200, 800) => freq1; // generate a random frequency
    freq1*2 => freq2; // generate 1st harmonic
    freq1*3 => freq3; // generate 2nd harmonic

    osc1.freq(freq1);
    osc2.freq(freq2);
    osc3.freq(freq3);
    Math.random2f(0.01, 0.5) => envTime; // generate a random envelope time
    env.time(envTime);
    env.keyOn();
    second => now;
    env.keyOff();
    second => now;
}
