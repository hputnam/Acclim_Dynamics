# Statistical Methods

Results markdown sheet link [here](https://github.com/hputnam/Acclim_Dynamics/blob/master/Results-package.md).

### Generalized additive models
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

PERMANOVA using Euclidean distances

```
Call:
adonis(formula = pacuta_vegan ~ Treatment * Timepoint, data = Pacuta_data, method = "eu")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                     Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)    
Treatment             3    134.24  44.746  6.0305 0.09453  0.001 ***
Timepoint             6    240.48  40.080  5.4015 0.16935  0.001 ***
Treatment:Timepoint  18    191.98  10.665  1.4374 0.13520  0.028 *  
Residuals           115    853.30   7.420         0.60092           
Total               142   1420.00                 1.00000           
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

**Montipora capitata**

![time](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Mcap-stress-PCAs.png?raw=true)

PERMANOVA using Euclidean distances

```
Call:
adonis(formula = mcap_vegan ~ Treatment * Timepoint, data = Mcap_data, method = "eu")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                     Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)    
Treatment             3     35.56 11.8543  1.3666 0.02436  0.190    
Timepoint             6    145.55 24.2585  2.7966 0.09969  0.001 ***
Treatment:Timepoint  18    246.65 13.7029  1.5797 0.16894  0.017 *  
Residuals           119   1032.23  8.6742         0.70701           
Total               146   1460.00                 1.00000           
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```


### Entire timeseries

This does not include photosynthetic and respiration rates because we don't have those measurements for the recovery periods.

**General PCAs**

![species](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/General-timeseries-PCAs.png?raw=true)

**Pocillopora acuta**

![timepoint](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Pacuta-Timeseries-PCAs.png?raw=true)

PERMANOVA using Euclidean distances

```
Call:
adonis(formula = pacuta_timeseries_vegan ~ Treatment * Timepoint, data = Pacuta_timeseriesdata, method = "eu")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                     Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)    
Treatment             3     64.67 21.5565  3.5506 0.05499  0.002 **
Timepoint             8    137.34 17.1672  2.8276 0.11678  0.001 ***
Treatment:Timepoint  21    148.30  7.0619  1.1632 0.12611  0.195    
Residuals           136    825.69  6.0713         0.70212           
Total               168   1176.00                 1.00000           
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

**Montipora capitata**

![time](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Mcap-Timeseries-Timepoint-PCA.png?raw=true)

![trt](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/Mcap-Timeseries-Treatment-PCA.png?raw=true)

PERMANOVA using Euclidean distances

```
Call:
adonis(formula = mcap_timeseries_vegan ~ Treatment * Timepoint,      data = Mcap_timeseriesdata, method = "eu")

Permutation: free
Number of permutations: 999

Terms added sequentially (first to last)

                     Df SumsOfSqs MeanSqs F.Model      R2 Pr(>F)    
Treatment             3     37.51 12.5043  1.9899 0.02851  0.039 *  
Timepoint             8    131.34 16.4169  2.6125 0.09980  0.001 ***
Treatment:Timepoint  24    185.71  7.7378  1.2314 0.14111  0.097 .  
Residuals           153    961.44  6.2840         0.73058           
Total               188   1316.00                 1.00000           
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

Both P.acuta and M.cap became not significant after taking out respirationa and photosynthetic rates when comparing treatment*timepoint. Respiration and photosynthetic rates might be the more compelling story, rather than the recovery timepoints? 
