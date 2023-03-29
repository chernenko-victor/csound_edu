// run each stooge, or run three stooges concurrently
// %> chuck moe larry curly

// impulse to filter to dac
Impulse i => BiQuad f => dac;
// set the filter's pole radius
.99 => f.prad; 
// set equal gain zeros
1 => f.eqzs;
// initialize float variable
0.0 => float v;
// set filter gain
.5 => f.gain;

f => DelayL delay1 => dac;
f => DelayL delay2 => dac;
f => DelayL delay3 => dac;

delay1 => delay1;
delay2 => delay2;
delay3 => delay3;

0.6 => delay1.gain => delay2.gain  => delay3.gain ;
0.06 :: second => delay1.max => delay1.delay;
0.08 :: second => delay2.max => delay2.delay;
0.1 :: second => delay3.max => delay3.delay;

  
// infinite time-loop   
while( true )
{
    // set the current sample/impulse
    1.0 => i.next;
    // sweep the filter resonant frequency
    Std.fabs(Math.sin(v)) * 800.0 => f.pfreq;
    // increment v
    v + .1 => v;
    // advance time
    101::ms => now;
}