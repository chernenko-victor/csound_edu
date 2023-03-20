import("stdfaust.lib");
phasor(f) = f/ma.SR : (+,1.0:fmod) ~ _ ;
osc(f) = phasor(f) * 6.28318530718 : sin;
process = osc(hslider("freq", 440, 20, 20000, 1)) * hslider("level", 0, 0, 1, 0.01);