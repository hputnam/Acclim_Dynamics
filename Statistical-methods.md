# Statistical Methods

Results markdown sheet link [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/Results-package.md).

## Univariate analysis

I used a generalized linear mixed model (GLMM) using Tank as a random factor (and Plug ID for repeated measures in Color Score and Growth) and compared this to a generalized additive model (GAM) using model comparisons like AIC scores. I chose Type III ANOVA because we have unbalanced sample sizes, and I wanted the ANOVA to test the significance of the interactive terms before the main effects.


#### Example code used for all variables

Example code below for creating the two models, comparing them, and checking the residuals of that model before completing an ANOVA test.

```
## Generalized Linear Mixed Model.
Pacuta_Pnet_LMER <- lmer(Pnet_umol.cm2.hr ~ Timepoint*Temperature*CO2 + (1|Tank), na.action=na.omit, data=pacuta_full_data)

Pacuta_Pnet_LMER.reef <- lmer(Pnet_umol.cm2.hr ~ Timepoint*Temperature*CO2 + (1|Tank) + (1|Site.Name), na.action=na.omit, data=pacuta_full_data)

## Diagnositics of the more appropriate model from above
## plot(Pacuta_Pnet_LMER) in console to view diagnostic plots
summary(Pacuta_Pnet_LMER)
qqPlot(residuals(Pacuta_Pnet_LMER)) # qqplot and histogram
hist(residuals(Pacuta_Pnet_LMER))
## checking homogeneity of variance using levene test (can also use Bartlett's test function)
leveneTest(residuals(Pacuta_Pnet_LMER))
leveneTest(pacuta_full_data$Pnet_umol.cm2.hr ~ pacuta_full_data$Timepoint*pacuta_full_data$Temperature*pacuta_full_data$CO2)
bartlett.test(Pacuta_Pnet_LMER)

## Checking significance of that model
anova(Pacuta_Pnet_LMER, type='III')
Anova(Pacuta_Pnet_LMER, type='III') #Anova needs to be capital A to be from car function and distinguish types of ANOVAs
#plot(allEffects(Pacuta_Pnet_LMER))
```

But the `anova` vs. `Anova` function are returning very different p-values with the package `lmertest`. Example below. Which method to choose?

```
$ anova(Pacuta_Pnet_LMER, ddf="lme4", type='III')

Analysis of Variance Table
                          npar  Sum Sq Mean Sq F value
Timepoint                    6 11.2023 1.86705 16.4831
Temperature                  1  2.5805 2.58048 22.7815
CO2                          1  0.1425 0.14250  1.2581
Timepoint:Temperature        6  6.9150 1.15250 10.1747
Timepoint:CO2                6  0.7311 0.12184  1.0757
Temperature:CO2              1  0.0055 0.00546  0.0482
Timepoint:Temperature:CO2    6  1.3710 0.22850  2.0173
Analysis of Deviance Table (Type III Wald chisquare tests)

$ Anova(Pacuta_Pnet_LMER, ddf="lme4", type='III')

Response: Pnet_umol.cm2.hr
                            Chisq Df           Pr(>Chisq)
(Intercept)               78.0734  1 < 0.0000000000000002
Timepoint                 13.6698  6              0.03355
Temperature                6.2095  1              0.01271
CO2                        0.6040  1              0.43706
Timepoint:Temperature     14.6975  6              0.02274
Timepoint:CO2              5.2191  6              0.51603
Temperature:CO2            0.6397  1              0.42382
Timepoint:Temperature:CO2 12.1038  6              0.05969

$ anova(Pacuta_Pnet_LMER, ddf="Satterthwaite", type='III')

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value              Pr(>F)
Timepoint                 11.3832 1.89720     6 120.633 16.7492 0.00000000000005485
Temperature                2.4616 2.46162     1   8.109 21.7321            0.001562
CO2                        0.2117 0.21170     1   8.109  1.8690            0.208285
Timepoint:Temperature      6.8962 1.14937     6 120.633 10.1471 0.00000000454251390
Timepoint:CO2              0.7311 0.12184     6 120.633  1.0757            0.380893
Temperature:CO2            0.0003 0.00028     1   8.109  0.0025            0.961603
Timepoint:Temperature:CO2  1.3710 0.22850     6 120.633  2.0173            0.068440
```

#### Model selection

| Species            	| Variable     	| Random factors chosen  	|
|--------------------	|--------------	|------------------------	|
| Pocillopora acuta  	| Pnet rates   	| Reef and tank          	|
| Pocillopora acuta  	| Pgross rates 	| Reef and tank          	|
| Pocillopora acuta  	| Resp rates   	| Tank                   	|
| Pocillopora acuta  	| Chl          	| Reef and tank          	|
| Pocillopora acuta  	| Sym AFDW     	| Reef and tank          	|
| Pocillopora acuta  	| Host AFDW    	| Tank                   	|
| Pocillopora acuta  	| Ratio AFDW   	| Tank                   	|
| Pocillopora acuta  	| Protein      	| Reef and tank          	|
| Pocillopora acuta  	| TAC          	| Tank                   	|
| Montipora capitata 	| Pnet rates   	| Tank                   	|
| Montipora capitata 	| Pgross rates 	| Tank                   	|
| Montipora capitata 	| Resp rates   	| Tank                   	|
| Montipora capitata 	| Chl          	| Tank                   	|
| Montipora capitata 	| Sym AFDW     	| Tank                   	|
| Montipora capitata 	| Host AFDW    	| Tank                   	|
| Montipora capitata 	| Ratio AFDW   	| Tank                   	|
| Montipora capitata 	| Protein      	| Reef and tank          	|
| Montipora capitata 	| TAC          	| Tank                   	|


### Respiration and photosynthetic rates

#### P. acuta

**Pnet rates = GLMM w/ tank and reef as random factor**   
**Pgross rates = GLMM w/ tank and reef as random factor**   
**Resp rates = GLMM w/ tank as random factor**  

Net and gross photosynethic rates have equal variances, normal residuals and normal histogram. Respiration rates have normal residuals but unequal variances.

Come back to:  
- Unequal variances for dark respiration  
- Wald chisquare test vs. Satterthwaite's method

```
## Net photosynthetic rates

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Pnet_umol.cm2.hr
                            Chisq Df           Pr(>Chisq)
(Intercept)               80.6210  1 < 0.0000000000000002
Timepoint                 13.7308  6              0.03279
Temperature                6.3005  1              0.01207
CO2                        0.8529  1              0.35574
Timepoint:Temperature     15.8640  6              0.01450
Timepoint:CO2              5.5982  6              0.46966
Temperature:CO2            0.4649  1              0.49536
Timepoint:Temperature:CO2 13.4339  6              0.03664

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value              Pr(>F)
Timepoint                 10.9275 1.82124     6 118.643 17.2812 0.00000000000002758
Temperature                2.4037 2.40368     1   8.231 22.8077            0.001292
CO2                        0.2366 0.23659     1   8.163  2.2450            0.171687
Timepoint:Temperature      6.8208 1.13681     6 117.446 10.7868 0.00000000155438205
Timepoint:CO2              0.6439 0.10731     6 118.151  1.0182            0.416883
Temperature:CO2            0.0025 0.00247     1   8.113  0.0234            0.882182
Timepoint:Temperature:CO2  1.4158 0.23596     6 117.963  2.2390            0.044078

-------

## Gross photosynthetic rates

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Pgross_umol.cm2.hr
                            Chisq Df           Pr(>Chisq)
(Intercept)               95.3113  1 < 0.0000000000000002
Timepoint                 14.9597  6              0.02057
Temperature                5.8979  1              0.01516
CO2                        1.3638  1              0.24287
Timepoint:Temperature     15.9238  6              0.01417
Timepoint:CO2              5.9706  6              0.42649
Temperature:CO2            0.4789  1              0.48893
Timepoint:Temperature:CO2 13.7720  6              0.03229

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value                Pr(>F)
Timepoint                 17.1658  2.8610     6 118.549 20.1346 0.0000000000000003973
Temperature                3.3486  3.3486     1   8.251 23.5662              0.001158
CO2                        0.3377  0.3377     1   8.168  2.3764              0.160978
Timepoint:Temperature      9.1095  1.5182     6 117.273 10.6849 0.0000000018831238417
Timepoint:CO2              1.1154  0.1859     6 118.089  1.3084              0.258748
Temperature:CO2            0.0025  0.0025     1   8.109  0.0174              0.898385
Timepoint:Temperature:CO2  1.9569  0.3261     6 117.754  2.2953              0.039345

-------

## Dark Respiration Rates

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Rdark_umol.cm2.hr
                            Chisq Df            Pr(>Chisq)
(Intercept)               96.4494  1 < 0.00000000000000022
Timepoint                 20.9826  6              0.001848
Temperature                1.4338  1              0.231148
CO2                        2.2751  1              0.131471
Timepoint:Temperature      9.6079  6              0.142167
Timepoint:CO2              8.3071  6              0.216458
Temperature:CO2            0.4490  1              0.502787
Timepoint:Temperature:CO2 11.2909  6              0.079791

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq  Mean Sq NumDF   DenDF F value                Pr(>F)
Timepoint                 0.83405 0.139009     6 120.915 19.5271 0.0000000000000007814
Temperature               0.09652 0.096523     1   8.085 13.5589              0.006087
CO2                       0.00867 0.008667     1   8.085  1.2175              0.301614
Timepoint:Temperature     0.27674 0.046124     6 120.915  6.4792 0.0000060204901797361
Timepoint:CO2             0.08540 0.014234     6 120.915  1.9994              0.070881
Temperature:CO2           0.00025 0.000250     1   8.085  0.0352              0.855897
Timepoint:Temperature:CO2 0.08038 0.013396     6 120.915  1.8818              0.089287

```

#### M. capitata

**Pnet = w/ tank as random factor**  
**Pgross = w/ tank as random factor**  
**Resp = w/ tank as random factor**  

All rates were log transformed and 1 was added to each respiration rate prior to transformation.

Come back to:  
- Respiration rates row 288. Post transformation qqplot residuals aren't completely normal.  

```
## Net photosynthetic rates

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: log(Pnet_umol.cm2.hr)
                            Chisq Df Pr(>Chisq)
(Intercept)                3.4393  1    0.06366
Timepoint                  5.0898  6    0.53235
Temperature                0.0250  1    0.87435
CO2                        0.0181  1    0.89311
Timepoint:Temperature      6.0774  6    0.41457
Timepoint:CO2              6.1825  6    0.40306
Temperature:CO2            0.3990  1    0.52762
Timepoint:Temperature:CO2 14.6458  6    0.02320

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value    Pr(>F)
Timepoint                 1.74760 0.29127     6 121.228  3.1362 0.0068176
Temperature               0.64331 0.64331     1   8.551  6.9268 0.0284472
CO2                       0.06058 0.06058     1   8.551  0.6523 0.4411673
Timepoint:Temperature     2.70671 0.45112     6 121.228  4.8574 0.0001767
Timepoint:CO2             1.35289 0.22548     6 121.228  2.4279 0.0298615
Temperature:CO2           0.06497 0.06497     1   8.551  0.6996 0.4256731
Timepoint:Temperature:CO2 1.36020 0.22670     6 121.228  2.4410 0.0290693

-------

## Gross photosynethic rates

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: log(Pgross_umol.cm2.hr)
                            Chisq Df Pr(>Chisq)
(Intercept)               11.8631  1  0.0005726
Timepoint                  5.6169  6  0.4674429
Temperature                0.5195  1  0.4710432
CO2                        0.0164  1  0.8981030
Timepoint:Temperature      7.2880  6  0.2950292
Timepoint:CO2              7.1089  6  0.3108924
Temperature:CO2            0.9982  1  0.3177373
Timepoint:Temperature:CO2 15.6484  6  0.0157711

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value    Pr(>F)
Timepoint                 2.01179 0.33530     6 121.113  4.1065 0.0008698
Temperature               0.38317 0.38317     1   8.507  4.6928 0.0601830
CO2                       0.01223 0.01223     1   8.507  0.1498 0.7082298
Timepoint:Temperature     2.32851 0.38808     6 121.113  4.7529 0.0002206
Timepoint:CO2             1.27482 0.21247     6 121.113  2.6022 0.0208543
Temperature:CO2           0.05973 0.05973     1   8.507  0.7315 0.4158232
Timepoint:Temperature:CO2 1.27771 0.21295     6 121.113  2.6081 0.0206007

-------

## Dark Respiration Rates

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: log(Rdarkplus1)
                           Chisq Df Pr(>Chisq)
(Intercept)               4.6656  1    0.03077
Timepoint                 5.4260  6    0.49044
Temperature               2.4397  1    0.11830
CO2                       0.0012  1    0.97191
Timepoint:Temperature     5.0547  6    0.53681
Timepoint:CO2             2.2913  6    0.89106
Temperature:CO2           0.4575  1    0.49880
Timepoint:Temperature:CO2 8.4240  6    0.20865

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value  Pr(>F)
Timepoint                 2.56295 0.42716     6 118.792  2.7259 0.01622
Temperature               0.01229 0.01229     1   8.191  0.0785 0.78635
CO2                       0.00003 0.00003     1   8.191  0.0002 0.99002
Timepoint:Temperature     1.06656 0.17776     6 118.792  1.1344 0.34668
Timepoint:CO2             0.47324 0.07887     6 118.792  0.5033 0.80482
Temperature:CO2           0.02347 0.02347     1   8.191  0.1498 0.70861
Timepoint:Temperature:CO2 1.32010 0.22002     6 118.792  1.4040 0.21869

```

### Chlorophyll concentration

#### Mcapitata

- Homogeneity of variance didn't pass but normal qqplot

**Model with just tank as random factor**  

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: chla.ug.cm2
                            Chisq Df    Pr(>Chisq)
(Intercept)               29.3910  1 0.00000005915
Timepoint                 11.5139  8        0.1742
Temperature                0.2091  1        0.6475
CO2                        0.5798  1        0.4464
Timepoint:Temperature     12.3230  8        0.1374
Timepoint:CO2              2.2926  8        0.9707
Temperature:CO2            2.3520  1        0.1251
Timepoint:Temperature:CO2 10.6638  8        0.2215

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value    Pr(>F)
Timepoint                 12.8855  1.6107     8 148.031  2.7138 0.0081001
Temperature                8.0703  8.0703     1   7.919 13.5975 0.0062624
CO2                        0.4631  0.4631     1   7.919  0.7803 0.4030610
Timepoint:Temperature     17.4511  2.1814     8 148.031  3.6754 0.0006144
Timepoint:CO2              4.3391  0.5424     8 148.031  0.9139 0.5068160
Temperature:CO2            0.0637  0.0637     1   7.919  0.1072 0.7517930
Timepoint:Temperature:CO2  6.3291  0.7911     8 148.031  1.3330 0.2314470

```


#### Pacuta  

**Model with tank and reef as random factors chosen.**

- Warning: `fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients`. This is dropping the treatment/timepoints for P.acuta that are 0 (week 12, 16 heated treatments).

- Warning: Missing cells for: Timepoint16 week:TemperatureHigh, Timepoint16 week:TemperatureHigh:CO2Ambient, Timepoint12 week:TemperatureHigh:CO2High, Timepoint16 week:TemperatureHigh:CO2High.  
Interpret type III hypotheses with care.

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: chla.ug.cm2
                            Chisq Df       Pr(>Chisq)
(Intercept)               44.9965  1 0.00000000001974
Timepoint                  4.1925  8          0.83935
Temperature                2.4668  1          0.11628
CO2                        4.7215  1          0.02979
Timepoint:Temperature     17.1065  7          0.01672
Timepoint:CO2             10.3922  8          0.23857
Temperature:CO2            2.1004  1          0.14726
Timepoint:Temperature:CO2  7.6236  6          0.26700

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value      Pr(>F)
Timepoint                 12.0695 1.50869     8 131.010  5.4614 0.000005975
Temperature                3.0934 3.09342     1   9.710 11.1980    0.007716
CO2                        0.1213 0.12126     1   8.188  0.4390    0.525828
Timepoint:Temperature      9.8717 1.41024     7 130.360  5.1050 0.000037755
Timepoint:CO2              2.9115 0.36394     8 130.750  1.3174    0.240283
Temperature:CO2            0.1021 0.10205     1   9.189  0.3694    0.558034
Timepoint:Temperature:CO2  2.1060 0.35100     6 130.743  1.2706    0.275266

```

### Tissue Biomass  

#### Pocillopora acuta

**Host = Model with tank as random factor**  
**Sym = Model with tank and reef as random factors**  
**S:H ratio = Model with tank as random factor**  


S:H Ratio was log transformed.  
Warning: `fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients`; see above note.  

Come back to:  
- The Pacuta Host AFDW GLMM and Pacuta S:H AFDW GLMM produced the following warning `boundary (singular) fit: see ?isSingular`. This means that some "dimensions" of the variance-covariance matrix have been estimated as exactly zero. The function `isSingular(Pacuta_Host_LMER_tank, tol = 1e-4)` produced TRUE for singularity. What does this mean?  
- Row 67 is potentially an outlier?

For symbiont --  
- Warning: Missing cells for: Timepoint16 week:TemperatureHigh, Timepoint16 week:TemperatureHigh:CO2Ambient, Timepoint12 week:TemperatureHigh:CO2High, Timepoint16 week:TemperatureHigh:CO2High.  
Interpret type III hypotheses with care.

```
## Host Tissue Biomass

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Host_AFDW.mg.cm2
                            Chisq Df     Pr(>Chisq)
(Intercept)               34.5279  1 0.000000004202
Timepoint                  5.8125  8         0.6682
Temperature                0.0165  1         0.8977
CO2                        0.2748  1         0.6001
Timepoint:Temperature      5.0460  7         0.6543
Timepoint:CO2              3.9416  8         0.8624
Temperature:CO2            0.0109  1         0.9170
Timepoint:Temperature:CO2  1.9728  6         0.9222

Type III Analysis of Variance Table with Satterthwaite's method
                          Sum Sq Mean Sq NumDF   DenDF F value Pr(>F)
Timepoint                 5.2899 0.66124     8 133.174  1.5061 0.1608
Temperature               1.3511 1.35112     1  12.113  3.0775 0.1046
CO2                       0.1035 0.10348     1   9.274  0.2357 0.6386
Timepoint:Temperature     1.9844 0.28348     7 133.482  0.6457 0.7174
Timepoint:CO2             1.8747 0.23434     8 133.085  0.5338 0.8294
Temperature:CO2           0.4391 0.43907     1  11.408  1.0001 0.3380
Timepoint:Temperature:CO2 0.8661 0.14435     6 133.182  0.3288 0.9208

-------

## Symbiont Tissue Biomass

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Sym_AFDW.mg.cm2
                            Chisq Df     Pr(>Chisq)
(Intercept)               35.5349  1 0.000000002505
Timepoint                 32.3631  8 0.000080173936
Temperature                1.3341  1        0.24809
CO2                        0.1264  1        0.72220
Timepoint:Temperature     11.7322  7        0.10972
Timepoint:CO2             17.5146  8        0.02518
Temperature:CO2            0.0173  1        0.89546
Timepoint:Temperature:CO2  7.0933  6        0.31231

Type III Analysis of Variance Table with Satterthwaite's method
                          Sum Sq Mean Sq NumDF   DenDF F value       Pr(>F)
Timepoint                 7.3865 0.92332     8 127.940  6.7659 0.0000002216
Temperature               1.0822 1.08215     1  10.698  7.9298      0.01721
CO2                       0.0143 0.01426     1   8.672  0.1045      0.75412
Timepoint:Temperature     1.8288 0.26126     7 127.331  1.9144      0.07239
Timepoint:CO2             1.7265 0.21581     8 127.519  1.5814      0.13657
Temperature:CO2           0.1025 0.10254     1  10.025  0.7514      0.40630
Timepoint:Temperature:CO2 0.9680 0.16133     6 127.780  1.1822      0.31989

-------

## S:H Ratio Tissue Biomass

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: log(Ratio_AFDW.mg.cm2)
                            Chisq Df Pr(>Chisq)
(Intercept)                0.9565  1    0.32807
Timepoint                 17.8570  8    0.02232
Temperature                3.0343  1    0.08152
CO2                        0.0833  1    0.77282
Timepoint:Temperature     11.2005  7    0.13011
Timepoint:CO2             15.0237  8    0.05869
Temperature:CO2            0.5442  1    0.46069
Timepoint:Temperature:CO2  3.3470  6    0.76420

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF DenDF F value     Pr(>F)
Timepoint                 11.2338 1.40422     8   136  5.1040 0.00001439
Temperature                2.8000 2.79996     1   136 10.1771   0.001766
CO2                        0.0208 0.02080     1   136  0.0756   0.783742
Timepoint:Temperature      2.6596 0.37994     7   136  1.3810   0.218175
Timepoint:CO2              3.9580 0.49475     8   136  1.7983   0.082483
Temperature:CO2            0.0070 0.00702     1   136  0.0255   0.873348
Timepoint:Temperature:CO2  0.9208 0.15347     6   136  0.5578   0.763180

```

#### Mcapitata

**Host AFDW = model with tank as random factor**  
**Sym AFDW = model with tank as random factor**  
**Ratio AFDW = model with tank as random factor**  

Come back to:  
- Host AFDW and Sym AFDW qqplot post model is normal; but homogeneity of variances is not equal  

```
## Host Tissue Biomass

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Host_AFDW.mg.cm2
                            Chisq Df Pr(>Chisq)
(Intercept)               14.6230  1  0.0001313
Timepoint                  5.4045  8  0.7135985
Temperature                3.9913  1  0.0457353
CO2                        0.2509  1  0.6164300
Timepoint:Temperature      8.7168  8  0.3667454
Timepoint:CO2              1.5550  8  0.9917560
Temperature:CO2            3.3066  1  0.0690019
Timepoint:Temperature:CO2 13.8779  8  0.0850028

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF DenDF F value  Pr(>F)
Timepoint                 19.8558 2.48197     8   154  2.5899 0.01107
Temperature                0.0166 0.01662     1   154  0.0173 0.89541
CO2                        1.4120 1.41196     1   154  1.4734 0.22667
Timepoint:Temperature      7.3093 0.91367     8   154  0.9534 0.47470
Timepoint:CO2             10.6340 1.32925     8   154  1.3871 0.20619
Temperature:CO2            0.1867 0.18671     1   154  0.1948 0.65955
Timepoint:Temperature:CO2 13.2994 1.66243     8   154  1.7347 0.09447

-------

## Symbiont Tissue Biomass

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Sym_AFDW.mg.cm2
                            Chisq Df  Pr(>Chisq)
(Intercept)               20.2674  1 0.000006734
Timepoint                  8.2849  8     0.40615
Temperature                6.2902  1     0.01214
CO2                        0.6854  1     0.40772
Timepoint:Temperature     13.6737  8     0.09068
Timepoint:CO2              6.7389  8     0.56504
Temperature:CO2            4.5046  1     0.03380
Timepoint:Temperature:CO2 11.4545  8     0.17725

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value     Pr(>F)
Timepoint                 24.7408 3.09259     8 148.154  4.3587 0.00009573
Temperature                0.1993 0.19934     1   8.196  0.2809     0.6101
CO2                        0.0082 0.00821     1   8.196  0.0116     0.9169
Timepoint:Temperature      4.7166 0.58958     8 148.154  0.8309     0.5767
Timepoint:CO2              5.8790 0.73487     8 148.154  1.0357     0.4119
Temperature:CO2            0.0017 0.00171     1   8.196  0.0024     0.9620
Timepoint:Temperature:CO2  8.1273 1.01591     8 148.154  1.4318     0.1877

-------

## S:H Ratio Tissue Biomass  

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Ratio_AFDW.mg.cm2
                            Chisq Df       Pr(>Chisq)
(Intercept)               43.6944  1 0.00000000003839
Timepoint                  4.2604  8           0.8329
Temperature                0.1272  1           0.7214
CO2                        0.0047  1           0.9456
Timepoint:Temperature      3.7116  8           0.8822
Timepoint:CO2              6.9936  8           0.5373
Temperature:CO2            0.6991  1           0.4031
Timepoint:Temperature:CO2  4.7946  8           0.7793

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq  Mean Sq NumDF DenDF F value   Pr(>F)
Timepoint                 2.33635 0.292044     8   154  2.6784 0.008774
Temperature               0.00158 0.001579     1   154  0.0145 0.904363
CO2                       0.06246 0.062461     1   154  0.5728 0.450288
Timepoint:Temperature     0.37077 0.046346     8   154  0.4250 0.904672
Timepoint:CO2             0.97812 0.122265     8   154  1.1213 0.351910
Temperature:CO2           0.02254 0.022543     1   154  0.2067 0.649971
Timepoint:Temperature:CO2 0.52279 0.065349     8   154  0.5993 0.777392

```

### Host Soluble Protein

*M. capitata*      
- singularity warning described above

**Model with reef and tank as random factors (lower AIC by 0.1)**  

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: prot_mg.cm2
                            Chisq Df    Pr(>Chisq)
(Intercept)               28.6356  1 0.00000008736
Timepoint                 11.0213  8       0.20049
Temperature                5.2518  1       0.02192
CO2                        1.6964  1       0.19276
Timepoint:Temperature     17.3496  8       0.02667
Timepoint:CO2              6.1102  8       0.63489
Temperature:CO2            5.4017  1       0.02012
Timepoint:Temperature:CO2 11.6574  8       0.16716

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq  Mean Sq NumDF  DenDF F value      Pr(>F)
Timepoint                 1.89033 0.236292     8 148.48  5.3946 0.000005757
Temperature               0.03246 0.032463     1 148.18  0.7411      0.3907
CO2                       0.08934 0.089344     1 149.56  2.0398      0.1553
Timepoint:Temperature     0.48476 0.060595     8 149.41  1.3834      0.2081
Timepoint:CO2             0.77028 0.096285     8 149.24  2.1982      0.0306
Temperature:CO2           0.01400 0.013996     1 149.88  0.3195      0.5727
Timepoint:Temperature:CO2 0.51061 0.063827     8 148.67  1.4572      0.1776

```

*P. acuta*

**Model with tank and reef as random factors**  

Warning: `fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients`.  

Warning: Missing cells for: Timepoint16 week:TemperatureHigh, Timepoint16 week:TemperatureHigh:CO2Ambient, Timepoint12 week:TemperatureHigh:CO2High, Timepoint16 week:TemperatureHigh:CO2High.  
Interpret type III hypotheses with care.

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: prot_mg.cm2
                            Chisq Df           Pr(>Chisq)
(Intercept)               66.6213  1 0.000000000000000329
Timepoint                 15.5268  8             0.049676
Temperature                0.3049  1             0.580814
CO2                        2.5308  1             0.111646
Timepoint:Temperature     22.1594  7             0.002384
Timepoint:CO2             14.6260  8             0.066839
Temperature:CO2            2.3323  1             0.126711
Timepoint:Temperature:CO2 12.2365  6             0.056895

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq  Mean Sq NumDF   DenDF F value    Pr(>F)
Timepoint                 1.15596 0.144496     8 132.217  4.6780 0.0000464
Temperature               0.19485 0.194847     1  11.625  6.3081  0.027884
CO2                       0.00285 0.002853     1   9.023  0.0924  0.768094
Timepoint:Temperature     0.78769 0.112527     7 131.476  3.6430  0.001265
Timepoint:CO2             0.23448 0.029310     8 131.964  0.9489  0.478925
Temperature:CO2           0.03258 0.032584     1  10.731  1.0549  0.326980
Timepoint:Temperature:CO2 0.37797 0.062994     6 131.868  2.0394  0.064772

```

### Host Total Antioxidant Capacity

*P. acuta*  

**Model with tank as random factor**

Warning: `fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients`.

- had a singularity warning like above.  
- log transformed but still skewed but better than normal. Come back to this.

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: log(cre.umol.mgprot)
                            Chisq Df           Pr(>Chisq)
(Intercept)               82.2609  1 < 0.0000000000000002
Timepoint                 13.8204  8              0.08657
Temperature                0.1857  1              0.66652
CO2                        0.0647  1              0.79922
Timepoint:Temperature      0.8136  7              0.99730
Timepoint:CO2             10.1130  8              0.25718
Temperature:CO2            0.0062  1              0.93744
Timepoint:Temperature:CO2  5.0128  6              0.54218

Type III Analysis of Variance Table with Satterthwaite's method
                          Sum Sq Mean Sq NumDF DenDF F value   Pr(>F)
Timepoint                 8.8058 1.10073     8   139  3.4192 0.001279
Temperature               0.1675 0.16749     1   139  0.5203 0.471932
CO2                       0.0046 0.00456     1   139  0.0142 0.905405
Timepoint:Temperature     2.2029 0.31469     7   139  0.9775 0.450136
Timepoint:CO2             2.4117 0.30147     8   139  0.9365 0.488679
Temperature:CO2           0.1949 0.19489     1   139  0.6054 0.437853
Timepoint:Temperature:CO2 1.6137 0.26896     6   139  0.8355 0.544479

```

*M. capitata*    
- had a singularity warning like above.  
- log transformed and looked closer to normal than P. acuta

**Model with tank as random factor**

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: log(cre.umol.mgprot)
                            Chisq Df          Pr(>Chisq)
(Intercept)               98.4557  1 <0.0000000000000002
Timepoint                  2.4578  8              0.9637
Temperature                1.0772  1              0.2993
CO2                        0.9486  1              0.3301
Timepoint:Temperature      6.2844  8              0.6154
Timepoint:CO2              5.5540  8              0.6970
Temperature:CO2            0.1074  1              0.7432
Timepoint:Temperature:CO2  8.7855  8              0.3607

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq  Mean Sq NumDF DenDF F value Pr(>F)
Timepoint                 2.05140 0.256425     8   154  1.1428 0.3379
Temperature               0.00532 0.005319     1   154  0.0237 0.8778
CO2                       0.19888 0.198881     1   154  0.8864 0.3479
Timepoint:Temperature     0.88522 0.110653     8   154  0.4931 0.8597
Timepoint:CO2             0.82375 0.102968     8   154  0.4589 0.8833
Temperature:CO2           0.23115 0.231146     1   154  1.0302 0.3117
Timepoint:Temperature:CO2 1.97128 0.246410     8   154  1.0982 0.3675

```

### Color Score

This has repeated measures and tank effects so another random factor is added for repeated measures (Plug ID) using a nested format `(1|Tank/Plug_ID)`. "Blch_Time" refers to timepoint for color score analysis (photos taken every week, 1 week - 16 week).  

**M. capitata**

Come back to:  
- Bleaching.Score^(1/4) transformation  
- qqplot not normal, heavy tail  

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: (Bleaching.Score^(1/4))
                              Chisq Df            Pr(>Chisq)
(Intercept)               2310.0070  1 < 0.00000000000000022
Blch.Time                   12.7680 15             0.6202083
Temperature                  0.0300  1             0.8624716
CO2                          0.4212  1             0.5163412
Blch.Time:Temperature       42.9534 15             0.0001601
Blch.Time:CO2               28.2156 15             0.0202580
Temperature:CO2              0.0043  1             0.9476321
Blch.Time:Temperature:CO2   42.7693 15             0.0001710

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF  DenDF F value             Pr(>F)
Blch.Time                 2.65884 0.17726    15 769.05  5.5068 0.0000000001012917
Temperature               1.90774 1.90774     1 178.91 59.2674 0.0000000000008992
CO2                       0.11074 0.11074     1 178.91  3.4404           0.065264
Blch.Time:Temperature     2.58645 0.17243    15 769.05  5.3569 0.0000000002392475
Blch.Time:CO2             1.04268 0.06951    15 769.05  2.1595           0.006447
Temperature:CO2           0.11264 0.11264     1 178.91  3.4993           0.063028
Blch.Time:Temperature:CO2 1.37669 0.09178    15 769.05  2.8513           0.000227
```

**P. acuta**

The warning message `fixed-effect model matrix is rank deficient so dropping 12 columns / coefficients` appeared. Used `alias(model)` to find groups with small sample size. The model is excluding these anyway, no need to subset.

Come back to:  
- With log (+120) transformation, the qqplot looks much better with the exception of a couple points.   
- homogeneity of variance failed too

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: log(Color.Transformed)
                              Chisq Df            Pr(>Chisq)
(Intercept)               7936.2626  1 < 0.00000000000000022
Blch.Time                   12.1565 15              0.667149
Temperature                  0.0124  1              0.911168
CO2                          0.0566  1              0.811995
Blch.Time:Temperature       98.1694 11 0.0000000000000004112
Blch.Time:CO2               48.0160 15 0.0000252801966014658
Temperature:CO2              0.0287  1              0.865426
Blch.Time:Temperature:CO2   24.2542  7              0.001028

Type III Analysis of Variance Table with Satterthwaite's method
                          Sum Sq Mean Sq NumDF  DenDF F value                Pr(>F)
Blch.Time                 8.4669 0.56446    15 639.21 13.2303 < 0.00000000000000022
Temperature               1.9544 1.95437     1  14.33 45.8084           0.000008007
CO2                       0.0622 0.06219     1  11.22  1.4576              0.252160
Blch.Time:Temperature     7.0552 0.64138    11 640.27 15.0333 < 0.00000000000000022
Blch.Time:CO2             1.6336 0.10891    15 637.60  2.5527              0.001047
Temperature:CO2           0.0047 0.00473     1   9.70  0.1109              0.746183
Blch.Time:Temperature:CO2 1.0348 0.14783     7 640.22  3.4649              0.001187

```

### Buoyant Weight

Growth.Time refers to the buoyant weight timepoint (every 2 weeks for the entire 4 months).

*M. capitata*

I took out 1210 week 6 and 8 because its values were 2 orders of magnitude greater than the others, I think this is error/outlier not biological. There is another outlier (rows 659 and 660) that could be taken out, but the difference is not as stark.

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Growth.Rate
                              Chisq Df      Pr(>Chisq)
(Intercept)                 27.3523  1 0.0000001695589
Growth.Time                 19.6155  8       0.0118931
Temperature                  0.0373  1       0.8468290
CO2                          0.0865  1       0.7687307
Growth.Time:Temperature     61.6345  8 0.0000000002225
Growth.Time:CO2             25.1594  8       0.0014607
Temperature:CO2              0.0123  1       0.9118175
Growth.Time:Temperature:CO2 26.4946  8       0.0008639

Type III Analysis of Variance Table with Satterthwaite's method
                                  Sum Sq       Mean Sq NumDF  DenDF F value        Pr(>F)
Growth.Time                 0.0000055564 0.00000069455     8 513.96  5.2253 0.00000267301
Temperature                 0.0000024157 0.00000241575     1  11.33 18.1743      0.001252
CO2                         0.0000000050 0.00000000499     1  11.33  0.0375      0.849818
Growth.Time:Temperature     0.0000069768 0.00000087210     8 513.96  6.5611 0.00000003632
Growth.Time:CO2             0.0000019099 0.00000023874     8 513.96  1.7961      0.075383
Temperature:CO2             0.0000005319 0.00000053186     1  11.33  4.0013      0.070024
Growth.Time:Temperature:CO2 0.0000035217 0.00000044021     8 513.96  3.3118      0.001057
```

*P. acuta*  
- Warning: `fixed-effect model matrix is rank deficient so dropping 6 columns / coefficients`  
- Log transformed

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: log(Growth.Rate)
                                Chisq Df            Pr(>Chisq)
(Intercept)                 2271.8530  1 < 0.00000000000000022
Growth.Time                   75.4042  8    0.0000000000004094
Temperature                    2.2562  1              0.133078
CO2                            5.8913  1              0.015216
Growth.Time:Temperature       11.7755  5              0.037996
Growth.Time:CO2               23.8732  8              0.002407
Temperature:CO2                1.5673  1              0.210596
Growth.Time:Temperature:CO2    3.6997  4              0.448169

Type III Analysis of Variance Table with Satterthwaite's method
                            Sum Sq Mean Sq NumDF   DenDF F value                Pr(>F)
Growth.Time                 73.456  9.1819     8 310.764 17.9852 < 0.00000000000000022
Temperature                  3.600  3.6003     1  30.003  7.0521               0.01255
CO2                          1.318  1.3181     1  19.567  2.5819               0.12411
Growth.Time:Temperature     13.754  2.7507     5 310.994  5.3881            0.00009083
Growth.Time:CO2              8.183  1.0229     8 311.503  2.0036               0.04565
Temperature:CO2              0.046  0.0464     1  15.882  0.0908               0.76706
Growth.Time:Temperature:CO2  1.889  0.4722     4 308.800  0.9249               0.44964
```



#### Generalized additive model notes
Ross said this might be helpful.

Generalized linear model can capture non-Gaussian distribution models compared to standard linear models.

GAMs are essentially GLMs but can capture non-linear relationships by working with "splines". The unique part of GAM is that is is composed of a sum of functions of covariates instead of or in addition to the standard linear covariates effects. Basically y does not have to be a linear function of x.

You choose a "basis" which is a choice of "splines" (i.e. cubic spline vs polynomial spline). There is also penalized estimation that essentially keeps us from overfitting our data. GAM can be thought of like a modified GLM.
Information on GAM [here](https://m-clark.github.io/generalized-additive-models/building_gam.html).

These models are more general with less assumptions. Less stat power?

Github code example [m-clark](https://m-clark.github.io/docs/mixedModels/mixedModelML.html#additive_model_as_a_mixed_model)
Common examples:  
- large datasets with complicated interaction effects
- Models with many parameters but not a lot of data per parameter
- Fitting a smooth trend line that allows the trend to vary by year

GAMs seem like they could be a good fit.

## Multivariate analysis

**3 phases**

![3-phases](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/PCA-threephase.png?raw=true)


### Stress Treatment

We only have respiration and photosynthetic rates in stress timepoints so when I took only the complete sets of data, this took out the recovery timepoints.

![stress-PCAs](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/PCA-stress.png?raw=true)

**Pocillopora acuta**

The arrows all overlapping are: Chla, Chlc, Sym AFDW, Pgross, and Pnet. Perhaps we could group these altogether as a symbiont fitness category?

PERMANOVA using Euclidean distances

```
Call:
adonis(formula = pacuta_vegan ~ Timepoint * Temperature * CO2,      data = Pacuta_data, method = "eu")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                           Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)
Timepoint                   6    237.59  39.598  5.3367 0.16732  0.001
Temperature                 1    127.39 127.387 17.1680 0.08971  0.001
CO2                         1      4.60   4.602  0.6203 0.00324  0.648
Timepoint:Temperature       6    105.68  17.613  2.3737 0.07442  0.002
Timepoint:CO2               6     37.05   6.175  0.8322 0.02609  0.639
Temperature:CO2             1      4.52   4.518  0.6089 0.00318  0.654
Timepoint:Temperature:CO2   6     49.87   8.311  1.1201 0.03512  0.299
Residuals                 115    853.30   7.420         0.60092       
Total                     142   1420.00                 1.00000

```

**Montipora capitata**

PERMANOVA using Euclidean distances

```
Call:
adonis(formula = mcap_vegan ~ Timepoint * Temperature * CO2,      data = Mcap_data, method = "eu")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                           Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)
Timepoint                   6    147.64 24.6075  2.8480 0.10044  0.001
Temperature                 1     18.85 18.8478  2.1814 0.01282  0.064
CO2                         1     16.97 16.9691  1.9640 0.01154  0.104
Timepoint:Temperature       6     94.57 15.7623  1.8243 0.06434  0.027
Timepoint:CO2               6     72.88 12.1473  1.4059 0.04958  0.110
Temperature:CO2             1      2.98  2.9766  0.3445 0.00202  0.875
Timepoint:Temperature:CO2   6     79.27 13.2114  1.5291 0.05392  0.064
Residuals                 120   1036.84  8.6403         0.70533       
Total                     147   1470.00                 1.00000

```


### Entire timeseries

This does not include photosynthetic and respiration rates because we don't have those measurements for the recovery periods.

![time](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/PCA-timeseries.png?raw=true)

**Pocillopora acuta**
PERMANOVA using Euclidean distances

```
Call:
adonis(formula = pacuta_timeseries_vegan ~ Timepoint * Temperature *      CO2, data = Pacuta_timeseriesdata, method = "eu")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                           Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)
Timepoint                   8    130.41  16.302  2.6850 0.11090  0.001
Temperature                 1     65.70  65.701 10.8216 0.05587  0.001
CO2                         1      1.35   1.348  0.2220 0.00115  0.961
Timepoint:Temperature       7     72.72  10.388  1.7110 0.06183  0.033
Timepoint:CO2               8     42.68   5.334  0.8786 0.03629  0.646
Temperature:CO2             1      3.11   3.108  0.5119 0.00264  0.718
Timepoint:Temperature:CO2   6     34.35   5.725  0.9429 0.02921  0.545
Residuals                 136    825.69   6.071         0.70212       
Total                     168   1176.00                 1.00000

```

**Montipora capitata**

PERMANOVA using Euclidean distances

```
Call:
adonis(formula = mcap_timeseries_vegan ~ Timepoint * Temperature *      CO2, data = Mcap_timeseriesdata, method = "eu")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                           Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)
Timepoint                   8    134.39 16.7987  2.6840 0.10158  0.001
Temperature                 1     29.82 29.8161  4.7639 0.02254  0.004
CO2                         1      6.82  6.8232  1.0902 0.00516  0.326
Timepoint:Temperature       8     69.64  8.7049  1.3908 0.05264  0.092
Timepoint:CO2               8     50.80  6.3502  1.0146 0.03840  0.434
Temperature:CO2             1      2.89  2.8944  0.4625 0.00219  0.778
Timepoint:Temperature:CO2   8     64.78  8.0978  1.2938 0.04897  0.119
Residuals                 154    963.85  6.2588         0.72854       
Total                     189   1323.00                 1.00000

```



## Next Steps

- Add GAM and compare to GLMM  
- Decide chisquare vs. Satterthwaite for ANOVA method  
- Color score model fit  
- Sym function vs. host function PCAs  
- Normalize to variables other than surface area (SA, sym density, AFDW, protein)    
- Look at Chris Wall's physiotype paper to see if that would be best to represent timepoints?     
- Physiological variability (MAD scores)   
- Parse hobo logger times  
- Apex continuous data  
- Calculate Degree Heating Weeks  
- Clean up .Rmd scripts

### Normalizing options:  

Host soluble protein:   
- per cm2 (SA) OR per Host AFDW  

Host TAC:  
- per host soluble protein

Chl-a:  
- per cm2 (SA) or cell density   
- I think cell density is most appropriate  

Photosynthetic rates:  
- per cm2 (SA) or chl-a or cell density  
- Gross photosynethic: units need to match resp to get this calc?

Respiration rates:  
- per cm2 (SA) or host protein

AFDW:  
- Host: per cm2 (SA)  
- Sym: per cm2 (SA) or cell density  
- Ratio: Host and Sym units have to match to be unitless
