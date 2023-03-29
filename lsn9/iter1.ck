// FM synthesis by hand

// carrier
SinOsc c => dac;
// modulator
SinOsc m => blackhole;

// carrier frequency
220 => float cf;
// modulator frequency
550 => float mf => m.freq;
// index of modulation
200 => float index;

1::second => dur next_start;
0.5::second => dur min_dur;
int start_index;
[ 1, 2, 4, 6, 8 ] @=> int start_mult[];

Math.random2f ( -0.9, 0.9 ) => float x;
1.8 => float r;

0 => float test_modu;

-1.0 => float xb;
1.0 => float xe;
1.0 => float yb;
8.0 => float ye;

(ye - yb) / (xe - xb) => float A;
yb - A * xb => float B;


// time-loop
while( true )
{
    // modulate
    cf + (index * m.last()) => c.freq;
    // advance time by 1 samp
    1::samp => now;
    
    if(now % next_start == 1::samp)
    {
        (1 - r * Math.pow(x,2)) => x;
        15.0 + Math.exp(A * x + B) => cf;
        <<< cf >>>;
        //cf_new => cf;
        
        //next_start + 500::ms => next_start;
        Math.random2 ( 0, 4 ) => start_index;
        
        //test_modu + 0.1 => test_modu;
        //<<< test_modu >>>;
        //<<< test_modu % 1.8 - 0.9 >>>;
        <<< "start_mult = ", start_mult[start_index], " next_start * start_mult = ",  start_mult[start_index] * min_dur>>>;
        start_mult[start_index] * min_dur => next_start;
    }
}