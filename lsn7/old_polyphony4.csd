<CsoundSynthesizer>
sr = 44100
#define DUMP_FILE_NAME #"cffg.txt"#
#include "distribution3.inc.csd"
;vocabulary
gkRules[][] init  $ARRAY_MAX_DIM, $ARRAY_MAX_DIM
		kTemporary[] init $ARRAY_MAX_DIM
		kFinal = CFFG(gkRules, gkAlternativeProb, kFinal)
</CsInstruments>