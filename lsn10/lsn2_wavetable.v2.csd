<CsoundSynthesizer>
<CsOptions>
  ;Здесь пишут параметры генерации (напр., название и тип звукового файла и проч.)
</CsOptions>
<CsInstruments>
  ;Описание оркестра
  sr        = 44100
  kr        = 4410
  ksmps     = 10
  nchnls    = 2
  0dbfs     = 1 ;amplitudes must be less or equal than 1
  
  giAtkTime = .1
  ;varname          ifn itime isize igen Sfilnam       iskip iformat ichn
  giFl    ftgen     0,  0,    0,    1,   "fl_dis4.wav",  0,    0,      0
  giVni   ftgen     0,  0,    0,    1,   "vni_dis4.wav", 0,    0,      0
  
  instr     1
    iAmp    =   p4
    iCps    =   p5
    
    iSustTime               =           p3 - 3. * giAtkTime / 2.
    kEnvAtk                 linseg      0., giAtkTime / 2., 1., giAtkTime / 2., 1., giAtkTime / 2., 0., iSustTime, 0.
    kEnvSust                linseg      0., giAtkTime, 0., giAtkTime / 2., 1., iSustTime, 0.
    
    aAttackL, aAttackR      loscil      iAmp, iCps, giFl, 1 
    aSustainL, aSustainR    loscil      iAmp, iCps, giVni, 1
    aResL                   =           aAttackL * kEnvAtk + aSustainL * kEnvSust
    aResR                   =           aAttackR * kEnvAtk + aSustainR * kEnvSust
                            outs        aResL, aResR 
  endin
</CsInstruments>
<CsScore>
  ;Партитура
  
  ;notes
  i     1   0   5   .9    1.
  i     1   6   2   .9    1.25
  i     1   9   1   .9    .75
  e
  
</CsScore>
</CsoundSynthesizer>