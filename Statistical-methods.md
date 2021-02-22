# Statistical Methods

Results markdown sheet link [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/Results-package.md).

## Univariate analysis

I used a generalized linear mixed model (GLMM) using Tank as a random factor (and Plug ID for repeated measures in Color Score and Growth) and compared this to a generalized additive model (GAM) using model comparisons like AIC scores. I chose Type III ANOVA because we have unbalanced sample sizes, and I wanted the ANOVA to test the significance of the interactive terms before the main effects.

Example code below for creating the two models, comparing them, and checking the residuals of that model before completing an ANOVA test.

```
## Generalized Linear Mixed Model.
Pacuta_Pnet_LMER <- lmer(Pnet_umol.cm2.hr ~ Timepoint*Temperature*CO2 + (1|Tank), na.action=na.omit, data=pacuta_full_data)

## Generalized Additive Model.


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

### Respiration and photosynthetic rates

**P. acuta**

Net and gross photosynethic rates have equal variances, normal residuals and normal histogram. Respiration rates have normal residuals but unequal variances.

Come back to:  
- Unequal variances for dark respiration  
- Wald chisquare test vs. Satterthwaite's method

```
## Net photosynthetic rates

Analysis of Deviance Table (Type III Wald chisquare tests)

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

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value              Pr(>F)
Timepoint                 11.3832 1.89720     6 120.633 16.7492 0.00000000000005485
Temperature                2.4616 2.46162     1   8.109 21.7321            0.001562
CO2                        0.2117 0.21170     1   8.109  1.8690            0.208285
Timepoint:Temperature      6.8962 1.14937     6 120.633 10.1471 0.00000000454251390
Timepoint:CO2              0.7311 0.12184     6 120.633  1.0757            0.380893
Temperature:CO2            0.0003 0.00028     1   8.109  0.0025            0.961603
Timepoint:Temperature:CO2  1.3710 0.22850     6 120.633  2.0173            0.068440

-------

## Gross photosynethic rates

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Pgross_umol.cm2.hr
                            Chisq Df           Pr(>Chisq)
(Intercept)               91.5956  1 < 0.0000000000000002
Timepoint                 14.6865  6              0.02284
Temperature                5.7251  1              0.01672
CO2                        0.9741  1              0.32366
Timepoint:Temperature     14.2763  6              0.02670
Timepoint:CO2              5.2522  6              0.51190
Temperature:CO2            0.6780  1              0.41028
Timepoint:Temperature:CO2 11.9308  6              0.06353

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value               Pr(>F)
Timepoint                 18.0070  3.0012     6 120.665 19.1942 0.000000000000001305
Temperature                3.4803  3.4803     1   8.104 22.2583             0.001454
CO2                        0.3039  0.3039     1   8.104  1.9435             0.200327
Timepoint:Temperature      9.3211  1.5535     6 120.665  9.9357 0.000000006745129489
Timepoint:CO2              1.2734  0.2122     6 120.665  1.3574             0.237334
Temperature:CO2            0.0000  0.0000     1   8.104  0.0002             0.988896
Timepoint:Temperature:CO2  1.8655  0.3109     6 120.665  1.9885             0.072453

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

**M. capitata**

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

*M. capitata*  
- Homogeneity of variance didn't pass but normal qqplot

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


*P. acuta*  
- 12 and 16 week timepoints were taken out of the analysis.  

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: chla.ug.cm2
                            Chisq Df       Pr(>Chisq)
(Intercept)               43.8602  1 0.00000000003527
Timepoint                  3.9314  6          0.68596
Temperature                3.1931  1          0.07395
CO2                        5.3494  1          0.02073
Timepoint:Temperature      6.9056  6          0.32966
Timepoint:CO2              7.9963  6          0.23837
Temperature:CO2            2.4597  1          0.11680
Timepoint:Temperature:CO2  6.9391  6          0.32652

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value     Pr(>F)
Timepoint                 11.6220 1.93701     6 111.575  6.2889 0.00001017
Temperature                2.3060 2.30598     1   6.586  7.4868   0.030873
CO2                        0.2177 0.21765     1   6.586  0.7066   0.430016
Timepoint:Temperature      7.5067 1.25112     6 111.575  4.0620   0.001012
Timepoint:CO2              1.7954 0.29924     6 111.575  0.9715   0.447954
Temperature:CO2            0.1550 0.15496     1   6.586  0.5031   0.502468
Timepoint:Temperature:CO2  2.1373 0.35621     6 111.575  1.1565   0.334829

```

### Tissue Biomass

20210217  

**P. acuta**

The Pacuta Host AFDW GLMM and Pacuta S:H AFDW GLMM produced the following warning `boundary (singular) fit: see ?isSingular`. This means that some "dimensions" of the variance-covariance matrix have been estimated as exactly zero. The function `isSingular(Pacuta_Host_LMER_tank, tol = 1e-4)` produced TRUE for singularity. This means we don't need to add the random factor of Tank, it is overfitting the model.

GLM was used for Host, Sym, and Ratio S:H AFDW.  
Sym AFDW and S:H Ratio AFDW were log transformed.

```
Analysis of Deviance Table (Type III tests)

Response: Host_AFDW.mg.cm2
                          LR Chisq Df Pr(>Chisq)
Timepoint                   6.6205  6     0.3574
Temperature                 0.0180  1     0.8934
CO2                         0.3191  1     0.5721
Timepoint:Temperature       3.5019  6     0.7437
Timepoint:CO2               1.8295  6     0.9347
Temperature:CO2             0.0193  1     0.8895
Timepoint:Temperature:CO2   2.4107  6     0.8783

-------

Analysis of Deviance Table (Type III tests)

Response: log(Sym_AFDW.mg.cm2)
                          LR Chisq Df Pr(>Chisq)   
Timepoint                  18.3845  6    0.00534 **
Temperature                 1.5319  1    0.21583   
CO2                         0.0014  1    0.97032   
Timepoint:Temperature       5.7574  6    0.45091   
Timepoint:CO2               8.0801  6    0.23229   
Temperature:CO2             0.2319  1    0.63010   
Timepoint:Temperature:CO2   9.3241  6    0.15615   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

-------

Analysis of Deviance Table (Type III tests)

Response: log(Ratio_AFDW.mg.cm2)
                          LR Chisq Df Pr(>Chisq)  
Timepoint                  14.3299  6    0.02616 *
Temperature                 4.2277  1    0.03977 *
CO2                         0.1161  1    0.73328  
Timepoint:Temperature       7.1007  6    0.31163  
Timepoint:CO2               7.1615  6    0.30617  
Temperature:CO2             0.7583  1    0.38387  
Timepoint:Temperature:CO2   4.6635  6    0.58764  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

```

Could the effect of timepoint and temperature be an affect of just losing symbiont cells towards the end of the stress? And not a factor of losing biomass. Standardize to # of cell density rather than surface area?

**M. capitata**

Host AFDW showed the same singularity error as above.

GLM used for Host, Sym, and Ratio S:H.

Host log transformed.

```
Analysis of Deviance Table (Type III tests)

Response: log(Host_AFDW.mg.cm2)
                          LR Chisq Df Pr(>Chisq)  
Timepoint                   6.6570  8    0.57405  
Temperature                 3.5923  1    0.05805 .
CO2                         0.5185  1    0.47147  
Timepoint:Temperature      11.4230  8    0.17886  
Timepoint:CO2               1.7244  8    0.98833  
Temperature:CO2             4.0628  1    0.04384 *
Timepoint:Temperature:CO2  11.4054  8    0.17977  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

-------

Analysis of Deviance Table (Type III tests)

Response: Sym_AFDW.mg.cm2
                          LR Chisq Df Pr(>Chisq)  
Timepoint                   8.2670  8    0.40784  
Temperature                 6.3002  1    0.01207 *
CO2                         0.6309  1    0.42701  
Timepoint:Temperature      13.4852  8    0.09621 .
Timepoint:CO2               6.5793  8    0.58263  
Temperature:CO2             4.4055  1    0.03582 *
Timepoint:Temperature:CO2  11.2684  8    0.18695  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

-------

Analysis of Deviance Table (Type III tests)

Response: Ratio_AFDW.mg.cm2
                          LR Chisq Df Pr(>Chisq)
Timepoint                   4.2604  8     0.8329
Temperature                 0.1272  1     0.7214
CO2                         0.0047  1     0.9456
Timepoint:Temperature       3.7116  8     0.8822
Timepoint:CO2               6.9936  8     0.5373
Temperature:CO2             0.6991  1     0.4031
Timepoint:Temperature:CO2   4.7946  8     0.7793
```

### Host Soluble Protein

20210217  
GLM used for Mcap and Pacuta based on AIC comparisons.

M. capitata  
- had the same singularity warning above.

```
Analysis of Deviance Table (Type III tests)

Response: prot_mg.cm2
                          LR Chisq Df Pr(>Chisq)    
Timepoint                  12.2397  8  0.1408253    
Temperature                 7.8433  1  0.0051009 **
CO2                         5.4409  1  0.0196710 *  
Timepoint:Temperature      21.9725  8  0.0049671 **
Timepoint:CO2              13.0215  8  0.1111122    
Temperature:CO2            10.9652  1  0.0009284 ***
Timepoint:Temperature:CO2  20.1409  8  0.0098160 **
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

```

P. acuta

```
Analysis of Deviance Table (Type III tests)

Response: prot_mg.cm2
                          LR Chisq Df Pr(>Chisq)  
Timepoint                   5.4971  6    0.48181  
Temperature                 2.0615  1    0.15106  
CO2                         3.1246  1    0.07712 .
Timepoint:Temperature       3.7862  6    0.70558  
Timepoint:CO2              12.6201  6    0.04948 *
Temperature:CO2             3.1943  1    0.07390 .
Timepoint:Temperature:CO2  14.5520  6    0.02404 *
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

### Host Total Antioxidant Capacity

20210217  

P. acuta  
- had a singularity warning like above.  
- log transformed but still skewed but better than normal.

```
Analysis of Deviance Table (Type III tests)

Response: log(cre.umol.mgprot)
                          LR Chisq Df Pr(>Chisq)  
Timepoint                  12.4537  6    0.05258 .
Temperature                 0.1680  1    0.68187  
CO2                         0.0585  1    0.80881  
Timepoint:Temperature       0.4424  6    0.99847  
Timepoint:CO2               8.5138  6    0.20283  
Temperature:CO2             0.0056  1    0.94048  
Timepoint:Temperature:CO2   4.5359  6    0.60455  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

M. capitata  
- had a singularity warning like above.  
- log transformed

```
Analysis of Deviance Table (Type III tests)

Response: log(cre.umol.mgprot)
                          LR Chisq Df Pr(>Chisq)
Timepoint                   2.4578  8     0.9637
Temperature                 1.0772  1     0.2993
CO2                         0.9486  1     0.3301
Timepoint:Temperature       6.2844  8     0.6154
Timepoint:CO2               5.5540  8     0.6970
Temperature:CO2             0.1074  1     0.7432
Timepoint:Temperature:CO2   8.7855  8     0.3607
```

### Color Score

This has repeated measures and tank effects so another random factor is added for repeated measures (Plug ID).

**M. capitata**

The model with just Plug ID as a random factor was the best model to use. I had to transform by adding 100 to each value to get positive values and then log transforming. But this didn't change the qqplot or hist.. hm... this needs to be fixed before running ANOVA.

```
```

**P. acuta**

The warning message `fixed-effect model matrix is rank deficient so dropping 12 columns / coefficients` appeared. Using `alias(Pacuta_Color_GLM)` I found the below groups are issues in the GLMM model. come back to this.... the GLMMs are cutting out these groups for now.

```
Complete :
                                         (Intercept) Blch.Time10 week Blch.Time11 week Blch.Time12 week Blch.Time13 week Blch.Time14 week Blch.Time15 week Blch.Time16 week
Blch.Time13 week:TemperatureHigh         0           0                0                0                0                0                0                0               
Blch.Time14 week:TemperatureHigh         0           0                0                0                0                0                0                0               
Blch.Time15 week:TemperatureHigh         0           0                0                0                0                0                0                0               
Blch.Time16 week:TemperatureHigh         0           0                0                0                0                0                0                0               
Blch.Time10 week:TemperatureHigh:CO2High 0           0                0                0                0                0                0                0               
Blch.Time11 week:TemperatureHigh:CO2High 0           0                0                0                0                0                0                0               
Blch.Time12 week:TemperatureHigh:CO2High 0           0                0                0                0                0                0                0               
Blch.Time13 week:TemperatureHigh:CO2High 0           0                0                0                0                0                0                0               
Blch.Time14 week:TemperatureHigh:CO2High 0           0                0                0                0                0                0                0               
Blch.Time15 week:TemperatureHigh:CO2High 0           0                0                0                0                0                0                0               
Blch.Time16 week:TemperatureHigh:CO2High 0           0                0                0                0                0                0                0               
Blch.Time9 week:TemperatureHigh:CO2High  0           0                0                0                0                0                0                0   
```

```
```


The model with both Plug ID and Tank was the best model to use. I used a transformation of +120 and log transformation. This still has some outliers so need to come back to this before running an ANOVA..

### Buoyant Weight

**M. capitata**

The three GLMM models are exactly the same (just plug ID, just tank, and tank and plug ID together) but we want a less complex model so we want to pick just plug ID or just tank but not sure which of the two.. Might come back to this choice..

The residuals are completely skewed by a few outliers.. come back to this.

```
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

Do:  
- Model with lmer (ref Ariana - linear mixed models) and GAM  
- AIC model test  
- ANOVA on that model  
- PCAs  
- PERMANOVA on that matrix




## Multivariate analysis

### Only acute and chronic stress Treatment

We only have respiration and photosynthetic rates in stress timepoints so when I took only the complete sets of data, this took out the recovery timepoints.

**General PCAs**

![species](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/General-PCAs.png?raw=true)

**Pocillopora acuta**

![timepoint](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Pacuta-stress-PCAs.png?raw=true)

The arrows all overlapping are: Chla, Chlc, Sym AFDW, Pgross, and Pnet. Perhaps we could group these altogether as a symbiont fitness category?

PERMANOVA using Euclidean distances - 20210217

```
Call:
adonis(formula = pacuta_vegan ~ Treatment * Timepoint, data = Pacuta_data,      method = "eu")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                     Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)    
Treatment             3    134.24  44.746  6.0305 0.09453  0.001 ***
Timepoint             6    240.48  40.080  5.4015 0.16935  0.001 ***
Treatment:Timepoint  18    191.98  10.665  1.4374 0.13520  0.030 *  
Residuals           115    853.30   7.420         0.60092           
Total               142   1420.00                 1.00000           
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

**Montipora capitata**

![time](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Mcap-stress-PCAs.png?raw=true)

PERMANOVA using Euclidean distances - 20210217

```
Call:
adonis(formula = mcap_vegan ~ Treatment * Timepoint, data = Mcap_data,      method = "eu")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                     Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)    
Treatment             3     37.59 12.5315  1.4504 0.02557  0.172    
Timepoint             6    149.08 24.8465  2.8756 0.10141  0.001 ***
Treatment:Timepoint  18    246.49 13.6940  1.5849 0.16768  0.015 *  
Residuals           120   1036.84  8.6403         0.70533           
Total               147   1470.00                 1.00000           
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```


### Entire timeseries

This does not include photosynthetic and respiration rates because we don't have those measurements for the recovery periods.

**General PCAs**

![species](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/General-timeseries-PCAs.png?raw=true)

**Pocillopora acuta**

![timepoint](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Pacuta-Timeseries-PCAs.png?raw=true)

PERMANOVA using Euclidean distances - 20210217

```
Call:
adonis(formula = pacuta_timeseries_vegan ~ Treatment * Timepoint,      data = Pacuta_timeseriesdata, method = "eu")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                     Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)    
Treatment             3     64.67 21.5565  3.5506 0.05499  0.001 ***
Timepoint             8    137.34 17.1672  2.8276 0.11678  0.001 ***
Treatment:Timepoint  21    148.30  7.0619  1.1632 0.12611  0.191    
Residuals           136    825.69  6.0713         0.70212           
Total               168   1176.00                 1.00000           
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

**Montipora capitata**

![time](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Mcap-Timeseries-PCAs.png?raw=true)

PERMANOVA using Euclidean distances - 20210217

```
Call:
adonis(formula = mcap_timeseries_vegan ~ Treatment * Timepoint,      data = Mcap_timeseriesdata, method = "eu")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                     Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)    
Treatment             3     39.18 13.0595  2.0866 0.02961  0.025 *  
Timepoint             8    134.96 16.8696  2.6953 0.10201  0.001 ***
Treatment:Timepoint  24    185.01  7.7088  1.2317 0.13984  0.113    
Residuals           154    963.85  6.2588         0.72854           
Total               189   1323.00                 1.00000           
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

Both P.acuta and M.cap became not significant after taking out respiration and photosynthetic rates when comparing treatment*timepoint. Respiration and photosynthetic rates might be the more compelling story, rather than the recovery timepoints?

I could also do the PERMANOVA with treatment separated into temperature and pCO2? I suspect temperature will be driver, not pCO2.


## Next Steps

- Look at Chris Wall's physiotype paper to see if that would be best to represent timepoints?    
- Check literature for all variable values  
- Physiological variability  
- Parse hobo logger times  
- Apex continuous data  
- Plot thermal history of Hawaii buoy, Degree Heating Weeks

Meeting with Ariana on Monday the 22nd 12 pm EST.  
- GAM vs GLMM models  
- How to pick outliers  
- Bleaching or BW transformations  
- Other things to normalize to
