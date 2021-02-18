# Statistical Methods

Results markdown sheet link [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/Results-package.md).

## Univariate analysis

I used a generalized linear mixed model (GLMM) using Tank as a random factor and compared this to a general linear model (GLM). Based on an AIC comparison, the GLMM was a better model.

I am having trouble with the Generalized additive model (GAM; see below notes on this) and will need to come back to this.

Type I ANOVA tests the factors in which they are ordered in the code and Type II ANOVA is for when there is no interaction term. We have temperature and pH stress which is an interaction, so I think Type III ANOVA will be better. Type III also accounts for unbalanced sample sizes.

Example code below for creating the two models, comparing them, and checking the residuals of that model before completing an ANOVA test.

```
Pacuta_Pnet_LMER_tank <- lmer(Pnet_umol.cm2.hr ~ Timepoint*Temperature*CO2 + (1|Tank), na.action=na.omit, data=pacuta_full_data) #GLMM
Pacuta_Pnet_LMER <- glm(Pnet_umol.cm2.hr ~ Timepoint*Temperature*CO2, na.action=na.omit, data=pacuta_full_data) # GLM
anova(Pacuta_Pnet_LMER_tank, Pacuta_Pnet_LMER) # AIC with tank = 151.40; without tank = 146.81. GLMM (5 points lower) with tank wins, move on to residuals

summary(Pacuta_Pnet_LMER_tank)
qqPlot(residuals(Pacuta_Pnet_LMER_tank))
hist(residuals(Pacuta_Pnet_LMER_tank))
# the above looks normal; no need to transform

Anova(Pacuta_Pnet_LMER_tank, type='III') #Anova needs to be capital A to be from car function and distinguish types of ANOVAs
plot(allEffects(Pacuta_Pnet_LMER_tank))
```

### Respiration and photosynthetic rates

**P. acuta**

20210217   
The residuals of P acuta R Dark GLM look a bit skewed, but come back to how skewed is too skewed? Might need to transform this.

AIC comparisons resulted in GLMM better for Pnet and Pgross, and GLM better for Rdark. The GLMM includes a random tank effect, maybe some tanks had a more variable light gradient than others? This would make sense to me as a source of variation for tanks that wouldn't exist for respiration.

```
Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Pnet_umol.cm2.hr
                            Chisq Df Pr(>Chisq)    
(Intercept)               78.0734  1    < 2e-16 ***
Timepoint                 13.6698  6    0.03355 *  
Temperature                6.2095  1    0.01271 *  
CO2                        0.6040  1    0.43706    
Timepoint:Temperature     14.6975  6    0.02274 *  
Timepoint:CO2              5.2191  6    0.51603    
Temperature:CO2            0.6397  1    0.42382    
Timepoint:Temperature:CO2 12.1038  6    0.05969 .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

-------

Analysis of Deviance Table (Type III Wald chisquare tests)

Response: Pgross_umol.cm2.hr
                            Chisq Df Pr(>Chisq)    
(Intercept)               91.5956  1    < 2e-16 ***
Timepoint                 14.6865  6    0.02284 *  
Temperature                5.7251  1    0.01672 *  
CO2                        0.9741  1    0.32366    
Timepoint:Temperature     14.2763  6    0.02670 *  
Timepoint:CO2              5.2522  6    0.51190    
Temperature:CO2            0.6780  1    0.41028    
Timepoint:Temperature:CO2 11.9308  6    0.06353 .  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

-------

Analysis of Deviance Table (Type III tests)

Response: Rdark_umol.cm2.hr
                          LR Chisq Df Pr(>Chisq)   
Timepoint                  20.1363  6   0.002619 **
Temperature                 1.4195  1   0.233479   
CO2                         2.1878  1   0.139103   
Timepoint:Temperature       9.2327  6   0.160907   
Timepoint:CO2               7.8911  6   0.246193   
Temperature:CO2             0.5200  1   0.470862   
Timepoint:Temperature:CO2  10.9229  6   0.090788 .
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

```

**M. capitata**

20210217  

AIC comparisons resulted in GLM as a better model for Pnet, Pgross, Rdark.

Pnet and Pgross residuals were not normal so I did a log transformation because the distribution was right-skewed (positively skewed). Rdark residuals were not normal so I added 1 every value to create positive values and did a log transformation on that but this still didn't look normal.. come back to this.

```
Analysis of Deviance Table (Type III tests)

Response: log(Pnet_umol.cm2.hr)
                          LR Chisq Df Pr(>Chisq)  
Timepoint                   4.7262  6    0.57938  
Temperature                 0.0130  1    0.90939  
CO2                         0.0259  1    0.87215  
Timepoint:Temperature       5.7465  6    0.45218  
Timepoint:CO2               5.7833  6    0.44790  
Temperature:CO2             0.1860  1    0.66623  
Timepoint:Temperature:CO2  13.6166  6    0.03423 *
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

-------

Analysis of Deviance Table (Type III tests)

Response: log(Pgross_umol.cm2.hr)
                          LR Chisq Df Pr(>Chisq)  
Timepoint                   5.0883  6    0.53254  
Temperature                 0.6680  1    0.41376  
CO2                         0.0167  1    0.89729  
Timepoint:Temperature       6.8796  6    0.33212  
Timepoint:CO2               6.4987  6    0.36970  
Temperature:CO2             0.6415  1    0.42316  
Timepoint:Temperature:CO2  14.0352  6    0.02925 *
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

-------

Analysis of Deviance Table (Type III tests)

Response: log(Rdarkplus1)
                          LR Chisq Df Pr(>Chisq)
Timepoint                   4.8964  6     0.5572
Temperature                 2.6473  1     0.1037
CO2                         0.0063  1     0.9365
Timepoint:Temperature       4.6221  6     0.5931
Timepoint:CO2               2.0398  6     0.9160
Temperature:CO2             0.7135  1     0.3983
Timepoint:Temperature:CO2   7.9334  6     0.2430

```

### Chlorophyll concentration

20210217

I subsetted this analysis to be only Chlorophyll-a because that is the pigment we care most about because it is the primary pigment of photosynthesis.

AIC comparisons resulted in GLM for M.cap and P. acuta

M. capitata
```
Analysis of Deviance Table (Type III tests)

Response: chla.ug.cm2
                          LR Chisq Df Pr(>Chisq)
Timepoint                  11.0559  8     0.1985
Temperature                 0.1737  1     0.6768
CO2                         0.6150  1     0.4329
Timepoint:Temperature      11.8834  8     0.1565
Timepoint:CO2               2.2901  8     0.9708
Temperature:CO2             2.1937  1     0.1386
Timepoint:Temperature:CO2  10.4346  8     0.2358
```
This is surprising because there looks like a clear difference in treatments for Chl concentration for Mcap in our final figure?

P. acuta

Week 12 and Week 16 had 0 or small sample sizes, these are subsetted out of this dataset, which fixed the below errors.

```
fixed-effect model matrix is rank deficient so dropping 3 columns / coefficients
# Error in Anova.III.LR.glm(mod, singular.ok = singular.ok) : there are aliased coefficients in the model error comes up so I did the below
alias(Pacuta_Chl_GLM) # which returned 0s for 12 and 16 wk timepoints. So these need to subsetted out above
```

```
Analysis of Deviance Table (Type III tests)

Response: chla.ug.cm2
                          LR Chisq Df Pr(>Chisq)  
Timepoint                   3.6259  6    0.72715  
Temperature                 3.7447  1    0.05297 .
CO2                         4.4693  1    0.03451 *
Timepoint:Temperature       6.6609  6    0.35335  
Timepoint:CO2               7.0885  6    0.31274  
Temperature:CO2             2.5106  1    0.11308  
Timepoint:Temperature:CO2   6.2545  6    0.39530  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```
Come back to this interpretation?? This doesn't seem to match the figure we produced.. brain is confused.

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
