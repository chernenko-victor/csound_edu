import("basics.lib");
import("stdfaust.lib");
import("noises.lib");


min_val = hslider("min_val",0.5,0,100,0.01);
max_val = hslider("max_val",2,0,100,0.01);

ACoeff = (max_val-min_val)/2;
BCoeff = (min_val+max_val)/2;

process = ACoeff*no.noise+BCoeff : _;
