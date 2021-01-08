Unused script from protein file.

```
## Basic Visualizations; see mixed models below for better answer
#protbyplate.wide <- full_join(plate.numbers, protein, by="Plug_ID") %>% select(-Abs480)
#protbyplate.wide <- full_join(protbyplate.wide, Master_fragment, by="Plug_ID") %>% filter(!is.na(Species))

#protbyplate.long <- full_join(plate.numbers, protein, by="Plug_ID") %>% gather("Measurement", "Value", 4:5)
#protbyplate.long <- full_join(protbyplate.long, Master_fragment, by="Plug_ID") %>% filter(!is.na(Measurement)) %>% filter(!is.na(Species))

```

```
Checking to see if protein value clusters by plate.
```{r}
## ANOVA tests
### had trouble with normality of data, went on to try mixed effect model
mcap.plate <- subset(protein, Species=="Mcapitata")

hist(mcap.plate$prot_ug.mL)

prot.plate.anova <- aov(sqrt(prot_ug.mL) ~ Plate*Treatment, data=mcap.plate)
summary(prot.plate.anova)
TukeyHSD(prot.plate.anova)

hist(prot.plate.anova$residuals)
plot(prot.plate.anova$fitted.values, prot.plate.anova$residuals)
shapiro.test(prot.plate.anova$residuals)
## can't get mcap to pass normality test with sqrt or log transformation

pacuta.plate <- subset(protbyplate.wide, Species=="Pacuta")
hist(pacuta.plate$prot_ug.mL)

pacuta.prot.plate.anova <- aov(sqrt(prot_ug.mL) ~ Plate*Treatment, data=pacuta.plate)
summary(pacuta.prot.plate.anova)
TukeyHSD(pacuta.prot.plate.anova)

hist(pacuta.prot.plate.anova$residuals)
plot(pacuta.prot.plate.anova$fitted.values, pacuta.prot.plate.anova$residuals)
shapiro.test(pacuta.prot.plate.anova$residuals)
## sqrt gets this closer to normal but still doesn't pass shapiro

### Mixed Effect Model
# Fixed factors = species, treatment, timepoint; Random factors Plug ID, plate number
lrt <- function(obj1, obj2) {
  L0 <- logLik(obj1)
  L1 <- logLik(obj2)
  L01 <- as.vector(- 2*(L0 - L1))
  df <- attr(L1, "df") - attr(L0, "df")
  list(L01 = L01, df = df,
    "p-value" = pchisq(L01, df, lower.tail = FALSE))
}

## Model1: Model with plate number and plug ID as random factor
mixed.effect.model <- lmer(prot_ug.mL~Treatment*Species*Timepoint + (1|Plug_ID) + (1|Plate), data=protein, REML=FALSE)

qnorm(resid(mixed.effect.model)) # Normality
qqline(resid(mixed.effect.model)) # Normal -- Error in int_abline(a = a, b = b, h = h, v = v, untf = untf, ...) : plot.new has not been called yet

boxplot(resid(mixed.effect.model)~protein$Treatment) # Variance
boxplot(resid(mixed.effect.model)~protein$Species)
boxplot(resid(mixed.effect.model)~protein$Timepoint)

# for all of the above:
# Error in model.frame.default(formula = resid(mixed.effect.model) ~ protein$Timepoint) : variable lengths differ (found for 'protein$Timepoint')

summary(mixed.effect.model)

## Model2: Model with plug ID as random factor
mixed.effect.model2 <- lmer(prot_ug.mL~Treatment*Species*Timepoint + (1|Plug_ID), data=protein, REML=FALSE)

qnorm(resid(mixed.effect.model2)) # Normality
qqline(resid(mixed.effect.model2)) # Normal -- Error in int_abline(a = a, b = b, h = h, v = v, untf = untf, ...) : plot.new has not been called yet

boxplot(resid(mixed.effect.model2)~protein$Treatment) # Variance
boxplot(resid(mixed.effect.model2)~protein$Species)
boxplot(resid(mixed.effect.model2)~protein$Timepoint)

# for all of the above:
# Error in model.frame.default(formula = resid(mixed.effect.model) ~ protein$Timepoint) : variable lengths differ (found for 'protein$Timepoint')

summary(mixed.effect.model2)

## Model3:  Model with plate number as random factor
mixed.effect.model3 <- lmer(prot_ug.mL~Treatment*Species*Timepoint + (1|Plate), data=protein, REML=FALSE)

qnorm(resid(mixed.effect.model3)) # Normality
qqline(resid(mixed.effect.model3)) # Normal -- Error in int_abline(a = a, b = b, h = h, v = v, untf = untf, ...) : plot.new has not been called yet

boxplot(resid(mixed.effect.model3)~protein$Treatment) # Variance
boxplot(resid(mixed.effect.model3)~protein$Species)
boxplot(resid(mixed.effect.model3)~protein$Timepoint)

# for all of the above:
# Error in model.frame.default(formula = resid(mixed.effect.model) ~ protein$Timepoint) : variable lengths differ (found for 'protein$Timepoint')

summary(mixed.effect.model3)

# Model comparisons
lrt(mixed.effect.model2, mixed.effect.model)
lrt(mixed.effect.model3, mixed.effect.model)

### AIC Values
## Full Model: 4847.4
## Just Plug ID: 4888.2
## Just Plate: 4845.4**
## Lower AIC wins; plate has an effect but not much different than the full model

# Output model selection
Anova(mixed.effect.model3)

## Principal Components Analysis (PCA)
pca.datatable <- tbl_df(protbyplate.wide) %>% select(-Abs480.adj) %>% distinct(Plug_ID, .keep_all = TRUE)
pca.datatable <- pca.datatable[,c(2,1,3,4,5)]
rownames(pca.datatable) <- pca.datatable$Plug_ID


protplate.pca <- prcomp(pca.datatable[,])

```

Unused from TAC file.

```
Calculate Total Antioxidant Capacity based on the standard curve model from above.
“mM uric acid equivalents” (UAE) is the first calculation based on the fitted model.
“μM Copper Reducing Equivalents” (CRE) is the second calculation which is the reported value and equivalent to Total Antioxidant Capacity or Power. This calculation is done by: 
1.) uric acid equivalence (UAE) concentration * 2189 μM Cu++/ mM uric acid = uM (umol/L) CRE
2.) umol/L CRE * Volume of the sample (this kit is 20 uL aka 2.0 x 10^-5 L) = CRE umol
3.) Concentration of protein (mg/mL) * 1000mL = mg/L of protein
4.) umol CRE / mg/L protein = uM/mg CRE

%>% # future TAC calculations need protein values in mg/mL
 select(Plug_ID, prot_mg.mL)
```
