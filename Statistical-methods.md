# Statistical Methods

Results markdown sheet link [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/Results-package.md).

## Univariate analysis

### Respiration and photosynthetic rates

I used a generalized linear mixed model (GLMM) using Tank as a random factor and compared this to a general linear model (GLM). Based on an AIC comparison, the GLMM was a better model.

I am having trouble with the Generalized additive model (GAM; see below notes on this) and will need to come back to this.

Type I ANOVA tests the factors in which they are ordered in the code and Type II ANOVA is for when there is no interaction term. We have temperature and pH stress which is an interaction, so I think Type III ANOVA will be better. Type III also accounts for unbalanced sample sizes.

Example code below for creating the two models, comparing them,

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

Results:

**P. acuta**

20210217 the residuals of P acuta R Dark GLM look a bit skewed, but come back to how skewed is too skewed? Might need to transform this.

AIC comparisons resulted in GLMM better for Pnet and Pgross, and GLM better for Rdark.

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
