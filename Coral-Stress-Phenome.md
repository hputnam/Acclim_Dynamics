# Coral Stress Phenome Paper

link to google doc [paper](https://docs.google.com/document/d/1geXeJEXaPVHWE6Ivdi6BW2qoF3PHT_Ok1Fv9iM8aLwg/edit).  

Variables included: Chl-c2, TAC, Soluble Protein, Host AFDW, Sym AFDW, S:H Ratio.

*M. capitata* PERMANOVA

```
Permutation test for adonis under reduced model
Terms added sequentially (first to last)
Permutation: free
Number of permutations: 999

adonis2(formula = Mcap.data.scaled ~ Temperature * CO2 * Timepoint, data = Mcap.info, method = "euclidian")
                           Df SumOfSqs      R2      F Pr(>F)    
Temperature                 1     8.97 0.01323 1.6422  0.167    
CO2                         1     1.12 0.00165 0.2054  0.937    
Timepoint                   4    75.22 0.11094 3.4436  0.001 ***
Temperature:CO2             1     5.86 0.00865 1.0740  0.356    
Temperature:Timepoint       4    22.21 0.03276 1.0168  0.433    
CO2:Timepoint               4    23.07 0.03403 1.0562  0.379    
Temperature:CO2:Timepoint   4    28.26 0.04168 1.2936  0.198    
Residual                   94   513.30 0.75707                  
Total                     113   678.00 1.00000                  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```


*P. acuta* PERMANOVA

```
Permutation test for adonis under reduced model
Terms added sequentially (first to last)
Permutation: free
Number of permutations: 999

adonis2(formula = Pact.data.scaled ~ Temperature * CO2 * Timepoint, data = Pact.info, method = "euclidian")
                           Df SumOfSqs      R2      F Pr(>F)    
Temperature                 1    28.54 0.04709 5.6114  0.003 **
CO2                         1     2.85 0.00470 0.5604  0.674    
Timepoint                   4    70.51 0.11636 3.4663  0.001 ***
Temperature:CO2             1     6.41 0.01058 1.2608  0.263    
Temperature:Timepoint       4    36.31 0.05992 1.7851  0.053 .  
CO2:Timepoint               4    20.20 0.03333 0.9929  0.452    
Temperature:CO2:Timepoint   3    19.08 0.03148 1.2506  0.273    
Residual                   83   422.10 0.69653                  
Total                     101   606.00 1.00000                  

---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

![biplots](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/CSP-PCAs.png?raw=true)

![all](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/CSP-all.png?raw=true)

The above figure is connecting dots by x axis placement, not factor(timepoint). Come back to how to change this..

![blchscore](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/CSP-Photographic_Bleaching.png?raw=true)

![surv](https://github.com/hputnam/Acclim_Dynamics/blob/master/Output/Final_Figures/All_survivorship.png?raw=true)
