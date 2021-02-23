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
- The model is dropping the 3 columns (HTHC 16 week, HTAC 16 week, HTHC 12 week) that have 0 corals for that time point. Should I keep the ATAC and ATHC recovery time periods or just constrain this to stress periods?

Just stress periods results below.  

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

**P. acuta**

S:H Ratio was log transformed.

Come back to:  
- The Pacuta Host AFDW GLMM and Pacuta S:H AFDW GLMM produced the following warning `boundary (singular) fit: see ?isSingular`. This means that some "dimensions" of the variance-covariance matrix have been estimated as exactly zero. The function `isSingular(Pacuta_Host_LMER_tank, tol = 1e-4)` produced TRUE for singularity. What does this mean?  
- Point above about stress period vs. full timeseries with 3 columns dropped


```
## Host Tissue Biomass

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Host_AFDW.mg.cm2
                            Chisq Df       Pr(>Chisq)
(Intercept)               42.2027  1 0.00000000008228
Timepoint                  6.6205  6           0.3574
Temperature                0.0180  1           0.8934
CO2                        0.3191  1           0.5721
Timepoint:Temperature      3.5019  6           0.7437
Timepoint:CO2              1.8295  6           0.9347
Temperature:CO2            0.0193  1           0.8895
Timepoint:Temperature:CO2  2.4107  6           0.8783

Type III Analysis of Variance Table with Satterthwaite's method
                          Sum Sq Mean Sq NumDF DenDF F value  Pr(>F)
Timepoint                 4.1336 0.68894     6   117  1.9155 0.08391
Temperature               0.6341 0.63407     1   117  1.7630 0.18684
CO2                       0.1909 0.19090     1   117  0.5308 0.46773
Timepoint:Temperature     1.0052 0.16754     6   117  0.4658 0.83242
Timepoint:CO2             0.7818 0.13030     6   117  0.3623 0.90138
Temperature:CO2           0.5017 0.50166     1   117  1.3948 0.23999
Timepoint:Temperature:CO2 0.8670 0.14451     6   117  0.4018 0.87658

-------

## Symbiont Tissue Biomass

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Sym_AFDW.mg.cm2
                            Chisq Df     Pr(>Chisq)
(Intercept)               34.1223  1 0.000000005175
Timepoint                 22.0833  6        0.00117
Temperature                1.8919  1        0.16899
CO2                        0.0000  1        0.99868
Timepoint:Temperature      7.6973  6        0.26113
Timepoint:CO2              8.2968  6        0.21715
Temperature:CO2            0.1167  1        0.73267
Timepoint:Temperature:CO2  5.8315  6        0.44233

Type III Analysis of Variance Table with Satterthwaite's method
                          Sum Sq Mean Sq NumDF   DenDF F value    Pr(>F)
Timepoint                 4.5300 0.75501     6 108.444  5.0692 0.0001277
Temperature               0.6469 0.64693     1   7.063  4.3436 0.0752685
CO2                       0.0046 0.00464     1   7.063  0.0312 0.8648329
Timepoint:Temperature     1.6390 0.27317     6 108.444  1.8341 0.0990593
Timepoint:CO2             0.5306 0.08844     6 108.444  0.5938 0.7346821
Temperature:CO2           0.1238 0.12379     1   7.063  0.8312 0.3919885
Timepoint:Temperature:CO2 0.8685 0.14476     6 108.444  0.9719 0.4478458

-------

## S:H Ratio Tissue Biomass

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: log(Ratio_AFDW.mg.cm2)
                            Chisq Df Pr(>Chisq)
(Intercept)                1.3327  1    0.24833
Timepoint                 14.3299  6    0.02616
Temperature                4.2277  1    0.03977
CO2                        0.1161  1    0.73328
Timepoint:Temperature      7.1007  6    0.31163
Timepoint:CO2              7.1615  6    0.30617
Temperature:CO2            0.7583  1    0.38387
Timepoint:Temperature:CO2  4.6635  6    0.58764

Type III Analysis of Variance Table with Satterthwaite's method
                          Sum Sq Mean Sq NumDF DenDF F value  Pr(>F)
Timepoint                 3.3834 0.56391     6   115  2.8559 0.01249
Temperature               1.2842 1.28423     1   115  6.5038 0.01208
CO2                       0.0235 0.02354     1   115  0.1192 0.73054
Timepoint:Temperature     1.0294 0.17157     6   115  0.8689 0.52011
Timepoint:CO2             1.3074 0.21790     6   115  1.1035 0.36465
Temperature:CO2           0.0070 0.00702     1   115  0.0355 0.85080
Timepoint:Temperature:CO2 0.9208 0.15347     6   115  0.7772 0.58939

```

**M. capitata**

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

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: prot_mg.cm2
                            Chisq Df Pr(>Chisq)
(Intercept)               19.0318  1 0.00001286
Timepoint                 12.2397  8  0.1408253
Temperature                7.8433  1  0.0051009
CO2                        5.4409  1  0.0196710
Timepoint:Temperature     21.9725  8  0.0049671
Timepoint:CO2             13.0215  8  0.1111122
Temperature:CO2           10.9652  1  0.0009284
Timepoint:Temperature:CO2 20.1409  8  0.0098160

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq  Mean Sq NumDF DenDF F value     Pr(>F)
Timepoint                 1.75995 0.219994     8   154  4.5817 0.00004993
Temperature               0.00941 0.009412     1   154  0.1960    0.65858
CO2                       0.05547 0.055473     1   154  1.1553    0.28413
Timepoint:Temperature     0.42096 0.052620     8   154  1.0959    0.36903
Timepoint:CO2             0.56266 0.070333     8   154  1.4648    0.17438
Temperature:CO2           0.08345 0.083449     1   154  1.7379    0.18936
Timepoint:Temperature:CO2 0.96709 0.120886     8   154  2.5176    0.01338

```

*P. acuta*

Come back to:  
- Point above about stress period vs. full timeseries with 3 columns dropped

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: prot_mg.cm2
                            Chisq Df          Pr(>Chisq)
(Intercept)               56.7445  1 0.00000000000004963
Timepoint                  5.9520  6             0.42859
Temperature                2.0534  1             0.15187
CO2                        3.5342  1             0.06012
Timepoint:Temperature      3.8838  6             0.69239
Timepoint:CO2             13.1369  6             0.04091
Temperature:CO2            3.6091  1             0.05746
Timepoint:Temperature:CO2 15.0912  6             0.01956

Type III Analysis of Variance Table with Satterthwaite's method
                           Sum Sq Mean Sq NumDF   DenDF F value  Pr(>F)
Timepoint                 0.71542 0.11924     6 112.324  1.7733 0.11089
Temperature               0.34570 0.34570     1   6.633  5.1412 0.05975
CO2                       0.00622 0.00622     1   6.633  0.0925 0.77035
Timepoint:Temperature     0.53817 0.08970     6 112.324  1.3340 0.24797
Timepoint:CO2             0.23896 0.03983     6 112.324  0.5923 0.73590
Temperature:CO2           0.03443 0.03443     1   6.633  0.5120 0.49867
Timepoint:Temperature:CO2 1.01473 0.16912     6 112.324  2.5152 0.02540

```

### Host Total Antioxidant Capacity

*P. acuta*  
- had a singularity warning like above.  
- log transformed but still skewed but better than normal. Come back to this.

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: log(cre.umol.mgprot)
                            Chisq Df           Pr(>Chisq)
(Intercept)               74.4362  1 < 0.0000000000000002
Timepoint                 12.4537  6              0.05258
Temperature                0.1680  1              0.68187
CO2                        0.0585  1              0.80881
Timepoint:Temperature      0.4424  6              0.99847
Timepoint:CO2              8.5138  6              0.20283
Temperature:CO2            0.0056  1              0.94048
Timepoint:Temperature:CO2  4.5359  6              0.60455

Type III Analysis of Variance Table with Satterthwaite's method
                          Sum Sq Mean Sq NumDF DenDF F value    Pr(>F)
Timepoint                 8.6565 1.44274     6   119  4.0553 0.0009812
Temperature               0.4224 0.42242     1   119  1.1874 0.2780656
CO2                       0.0796 0.07960     1   119  0.2237 0.6370756
Timepoint:Temperature     2.0944 0.34907     6   119  0.9812 0.4411427
Timepoint:CO2             2.1765 0.36275     6   119  1.0196 0.4159499
Temperature:CO2           0.1949 0.19489     1   119  0.5478 0.4606752
Timepoint:Temperature:CO2 1.6137 0.26896     6   119  0.7560 0.6058993

```

*M. capitata*    
- had a singularity warning like above.  
- log transformed and looked closer to normal than P. acuta

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
