import("stdfaust.lib");
// carrierFreq, modulatorFreq and index definitions go here
//	"label",init,min,max,step
carrierFreq = hslider("[0]carrierFreq",50,50,10000,0.01) : si.smoo;
modulatorFreq = hslider("[1]modulatorFreq",10,0.1,400,0.01) : si.smoo;
index = hslider("[2]index",1,0.1,10,0.01) : si.smoo;
process = 
    os.osc(carrierFreq+os.osc(modulatorFreq)*index)
    <: dm.zita_light; // splitting signals for stereo in