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

Checking to see if there is an effect of plate.  

```{r}
ggplot(TACplotting, aes(x=Plate, y=CRE.uM.mg.mL.cm2, fill=Treatment)) + geom_boxplot(alpha=0.5) +
  geom_jitter(color="black", size=0.4, alpha=0.9) + xlab("") + theme_bw() +
  theme(legend.position = "right") +
  facet_wrap(~Species, scales = "free_y") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

ggplot(TACplotting, aes(x=Plate, y=CRE.uM.mg.mL.cm2, fill=Species)) + geom_boxplot(alpha=0.5) +
  geom_jitter(color="black", size=0.4, alpha=0.9) + xlab("") + theme_bw() +
  theme(legend.position = "right") +
  facet_wrap(~Treatment, scales = "free_y") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
```

```
#TAC.plate.numbers <- read_csv("Physiology_variables/Total_antioxidant_capacity/total_TAC_platemaps.csv") %>%
 # select(-Well) %>% distinct()
#%>% full_join(TAC.plate.numbers)
```

############# Bleaching Test Information prior to processing all of the samples #############

Reading in bleaching test info.
```{r}
Phys_testing <- read.csv("Physiology_variables/phys_testing.csv")
  Phys_testing$Plug_ID <- as.character(Phys_testing$Plug_ID)
  
TAC_testing <- full_join(Blch_TAC, Phys_testing, by="Plug_ID")
```

Graphing bleaching test information.
```{r}
Bleached1 <- ggplot(TAC_testing, aes(x=status, y=CRE.umol.mgprot, fill=status)) + geom_boxplot(alpha=0.5) +
  geom_jitter(color="black", size=0.4, alpha=0.9) + xlab("") + theme_bw() +
  theme(legend.position = "") +
  facet_wrap(~Species)
Bleached1

Bleached2 <- ggplot(TAC_testing, aes(x=bleaching_score, y=CRE.umol.mgprot)) + geom_point() +
  xlab("Bleaching Score") + theme_bw() +
  facet_wrap(~Species) +
  theme(legend.position = "")
Bleached2

## 20201007 
# Plate 1
Oct7plate1_platemap <- read.csv("Physiology_variables/Total_Antioxidant_Capacity/20201007_Plate1_TAC_platemap.csv") 
  Oct7plate1_platemap$Plug_ID <- as.character(Oct7plate1_platemap$Plug_ID)
Oct7_plate1_final <- read.csv("Physiology_variables/Total_Antioxidant_Capacity/20201007_plate1_final.csv", header=T) %>% dplyr::rename(Abs_final = X490.490)
Oct7_plate1_initial <- read.csv("Physiology_variables/Total_Antioxidant_Capacity/20201007_plate1_initial.csv", header=T) %>% dplyr::rename(Abs_initial = X490.490)
Oct7_plate1 <- full_join(Oct7plate1_platemap, Oct7_plate1_initial, by="Well") %>%
  full_join(Oct7_plate1_final) %>%
  filter(!is.na(Plug_ID))

# Plate 2
Oct7plate2_platemap <- read.csv("Physiology_variables/Total_Antioxidant_Capacity/20201007_Plate2_TAC_platemap.csv") 
  Oct7plate2_platemap$Plug_ID <- as.character(Oct7plate2_platemap$Plug_ID)
Oct7_plate2_final <- read.csv("Physiology_variables/Total_Antioxidant_Capacity/20201007_plate2_final.csv", header=T) %>% dplyr::rename(Abs_final = X490.490)
Oct7_plate2_initial <- read.csv("Physiology_variables/Total_Antioxidant_Capacity/20201007_plate2_initial.csv", header=T) %>% dplyr::rename(Abs_initial = X490.490)
Oct7_plate2 <- full_join(Oct7plate2_platemap, Oct7_plate2_initial, by="Well") %>%
  full_join(Oct7_plate2_final) %>%
  filter(!is.na(Plug_ID))

# Plate 3
Oct7plate3_platemap <- read.csv("Physiology_variables/Total_Antioxidant_Capacity/20201007_Plate3_TAC_platemap.csv") 
  Oct7plate3_platemap$Plug_ID <- as.character(Oct7plate3_platemap$Plug_ID)
Oct7_plate3_final <- read.csv("Physiology_variables/Total_Antioxidant_Capacity/20201007_plate3_final.csv", header=T) %>% dplyr::rename(Abs_final = X490.490)
Oct7_plate3_initial <- read.csv("Physiology_variables/Total_Antioxidant_Capacity/20201007_plate3_initial.csv", header=T) %>% dplyr::rename(Abs_initial = X490.490)
Oct7_plate3 <- full_join(Oct7plate3_platemap, Oct7_plate3_initial, by="Well") %>%
  full_join(Oct7_plate3_final) %>%
  filter(!is.na(Plug_ID))

Oct7 <- union(Oct7_plate1, Oct7_plate2) %>% union(Oct7_plate3)
Oct7_st <- Oct7 %>% filter(grepl("Standard", Plug_ID)) %>% dplyr::rename(Standard = Plug_ID)

TAC.plate.numbers <- read_csv("Physiology_variables/Total_antioxidant_capacity/total_TAC_platemaps.csv") %>% 
  select(-Well) %>% distinct()
  
  
finalbydate <- full_join(TAC.plate.numbers, QC, by="Plug_ID")
ggplot(finalbydate, aes(x=Plate, y=Abs_final)) + geom_boxplot() + theme(axis.text.x = element_text(angle = 90))
## standard in graph aren't plotting correctly 

## 20201007
Oct7_st <- Oct7_st %>%
  mutate(Abs_net = Abs_final - Abs_initial) %>% 
  dplyr::group_by(Standard) %>%
  summarise(Abs_net = mean(Abs_net)) %>%
  mutate(Abs_net.adj = Abs_net - Abs_net[Standard == "Standard10"])

Oct7_st$conc_mM <- concentration[match(Oct7_st$Standard, st.name)]
  Oct7_st$conc_mM <- as.numeric(Oct7_st$conc_mM)

TAC_mod_lin2 <- lm(conc_mM ~ Abs_net.adj, data = Oct7_st)
summary(TAC_mod_lin2)

std_curve_plot2 <- Oct7_st %>%
  ggplot(aes(x = Abs_net.adj, y = conc_mM)) +
  geom_point(color = "blue", size = 1.5) + 
  theme_bw() + 
  xlim(0,1.5) +
  labs(title = paste("Adj R2 = ", signif(summary(TAC_mod_lin2)$adj.r.squared, 5),
                     "; TAC Standard Curve Oct 7 Standards")) + 
  geom_smooth(method = "lm")
std_curve_plot2

## October 7 Plates (3)
Oct7 <- Oct7 %>% 
  mutate(Abs_net = Abs_final - Abs_initial) %>% #subtract initial from final to get delta abs
  dplyr::group_by(Plug_ID) %>% # group to calculate mean
  summarise(Abs_net = mean(Abs_net)) %>% #calculate mean abs of duplicates
  mutate(Abs_net.adj = Abs_net - Nov10_st$Abs_net[Nov10_st$Standard == "Standard10"],
         uae.mM = map_dbl(Abs_net.adj, ~ predict(TAC_mod_linNov10, newdata = data.frame(Abs_net.adj = .)))) #use the regression to calculate all the mean UAE values from the abs values
std_curve_plotNov10 + #plot the standard curve to check this against the protocol
  geom_point(data = Oct7, aes(x = Abs_net.adj, y = uae.mM), pch = "X", cex = 3, alpha = 0.3) +
    labs(title = "Oct 7 samples projected on Nov 10 curve")
    
    ## October 7 plates
dplyr::filter(Oct7, Plug_ID == "Standard1") # uae.mM is 0.9964323
Oct7dilute.tac <- Oct7 %>% filter(uae.mM > 0.9964323) # output is 0 samples
```

Unused from environmental data script 





Viewing the temperature and pH data from local NOAA Hawaii Buoys (XX) to guide decisions in experimental design.

Reading in temperature and pH data files.
```{r}
NOAA_temp <- read.csv('Environmental_data/NOAA_Temp_Buoy_CO-OPS_1612480_from_20180901_to_20180923.csv')

# renaming columns and deleting the empty conductivity column
NOAA_temp <- NOAA_temp %>% dplyr::rename(Date = DATE.TIME) %>% dplyr::rename(Temperature = WATERTEMP) %>% select(-CONDUCTIVITY) %>% na.omit(NOAA_temp)

# separating date and time into two columns
NOAA_temp <- NOAA_temp %>% tidyr::separate(Date, c("month", "day", "year", "hour", "seconds"))

# calculating hourly temperature averages by day 
NOAA_means_hd <- summarySE(NOAA_temp, measurevar="Temperature", groupvars=c("day", "hour"))
NOAA_means_hd

NOAA_means_h <- summarySE(NOAA_temp, measurevar="Temperature", groupvars=c("hour"))
NOAA_means_h

ggplot(NOAA_means_hd, aes(x=hour, y=Temperature)) + 
  geom_point(aes(colour=day)) + 
  theme_classic() + 
  ggtitle("Moku o Loe NOAA Buoy (September 2018)") + 
  xlab("Hour") + ylab("Temperature (°C)")

ggplot(NOAA_means_h, aes(x=hour, y=Temperature)) + 
  geom_point()+ 
  theme_classic() + 
  ggtitle("Moku o Loe NOAA Buoy (September 2018)") + 
  xlab("Hour") + ylab("Temperature (°C)")

# calculating daily temperature ranges
NOAA_daily <- NOAA_temp %>% dplyr::group_by(day) %>%
  dplyr::summarise(min = min(Temperature),
                   max = max(Temperature)) %>%
  dplyr::mutate(range = max-min,
                daily.mean = mean(range),
                daily.se = std.error(range))


Graphing above dataframes. 
```{r}
## Total September 1 2018 - September 23 2018
ggplot(NOAA_temp, aes(x=Date, y=Temperature)) +
  geom_line() +
  xlab("") +
  theme_classic() +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  # scale_x_date(limit=c(as.Date("2019-08-31"),as.Date("2019-09-24"))) +
  ylim(25,30)

## Subset to show daily variation 
```

Unused script from statistics Rmd

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

```
Species.PCA <- autoplot(scaled_data, data = pca_data, colour = 'Species',
         frame=TRUE, size=0.5, frame.type = 'convex', loadings = TRUE, loadings.colour = 'black',
         loadings.label = TRUE, loadings.label.size = 3, loadings.label.colour = 'black', loadings.label.vjust=-1) + theme_bw() +
  xlim(-0.25,0.5); Species.PCA

Treatment.PCA <- autoplot(scaled_data, data = pca_data, colour = 'Treatment',
         loadings = TRUE, loadings.colour = 'black', frame=TRUE, size=0.5, frame.type = 'convex',
         loadings.label = TRUE, loadings.label.size = 3, loadings.label.colour = 'black', loadings.label.vjust=-1) + theme_bw() +
  xlim(-0.25,0.5) + scale_color_manual(values = cols) + scale_fill_manual(values = cols); Treatment.PCA

Timepoint.PCA <- autoplot(scaled_data, data = pca_data, colour = 'Timepoint',
         loadings = TRUE, loadings.colour = 'black', frame=TRUE, size=0.5, frame.type = 'convex',
         loadings.label = TRUE, loadings.label.size = 3, loadings.label.colour = 'black', loadings.label.vjust=-1) + theme_bw() +
  xlim(-0.25,0.5) + scale_colour_brewer(); Timepoint.PCA

ggsave(file="Output/Final_Figures/General-Species-PCA.pdf", Species.PCA, width = 11, height = 6, units = c("in"))
ggsave(file="Output/Final_Figures/General-Species-PCA.png", Species.PCA, width = 11, height = 6, units = c("in"))

ggsave(file="Output/Final_Figures/General-Treatment-PCA.pdf", Treatment.PCA, width = 11, height = 6, units = c("in"))
ggsave(file="Output/Final_Figures/General-Treatment-PCA.png", Treatment.PCA, width = 11, height = 6, units = c("in"))

ggsave(file="Output/Final_Figures/General-Timepoint-PCA.pdf", Timepoint.PCA, width = 11, height = 6, units = c("in"))
ggsave(file="Output/Final_Figures/General-Timepoint-PCA.png", Timepoint.PCA, width = 11, height = 6, units = c("in"))

General.PCAs <- arrangeGrob(Species.PCA, Treatment.PCA, Timepoint.PCA, ncol=2)
ggsave(file="Output/Final_Figures/General-PCAs.pdf", General.PCAs, width = 10, height = 6, units = c("in"))
ggsave(file="Output/Final_Figures/General-PCAs.png", General.PCAs, width = 10, height = 6, units = c("in"))

Subsetted to M. capitata
```{r}
Mcap_data <- subset(pca_data, Species=="Mcapitata")
Mcap_scaled_data <- prcomp(Mcap_data[c(9:18)], scale=TRUE, center=TRUE) # columns 8-17 are the data values

## screeplot
Mcap_data.cov <- cov(Mcap_data[,c(9:18)])
Mcap_data.eigen <- eigen(Mcap_data.cov)
plot(Mcap_data.eigen$values, xlab = 'Eigenvalue Number', ylab = 'Eigenvalue Size', main = 'Scree Graph') + lines(Mcap_data.eigen$values)

Mcap_treatment <- autoplot(Mcap_scaled_data, data = Mcap_data, colour = 'Treatment',
         loadings = TRUE, loadings.colour = 'black', frame=TRUE, size=0.5, frame.type = 'convex',
         loadings.label = TRUE, loadings.label.size = 3, loadings.label.colour = 'black', loadings.label.vjust=-1) + theme_bw() +
  #xlim() + 
  scale_color_manual(values = cols) + scale_fill_manual(values = cols) + ggtitle("M. capitata"); Mcap_treatment

Mcap_timepoint <- autoplot(Mcap_scaled_data, data = Mcap_data, colour = 'Timepoint',
         loadings = TRUE, loadings.colour = 'black', frame=TRUE, size=0.5, frame.type = 'convex',
         loadings.label = TRUE, loadings.label.size = 3, loadings.label.colour = 'black', loadings.label.vjust=-1) + theme_bw() +
  
  #xlim(-0.4,0.4) + 
  scale_colour_brewer() + ggtitle("M. capitata"); Mcap_timepoint

Mcap_phase <- autoplot(Mcap_scaled_data, data = Mcap_data, colour = 'Phase',
         loadings = TRUE, loadings.colour = 'black', frame=TRUE, size=0.5, frame.type = 'convex',
         loadings.label = TRUE, loadings.label.size = 3, loadings.label.colour = 'black', loadings.label.vjust=-1) + theme_bw() +
  
  #xlim(-0.4,0.4) + 
  scale_colour_brewer() + ggtitle("M. capitata"); Mcap_phase

ggsave(file="Output/Final_Figures/Mcap-Treatment-PCA.pdf", Mcap_treatment, width = 11, height = 6, units = c("in"))
ggsave(file="Output/Final_Figures/Mcap-Treatment-PCA.png", Mcap_treatment, width = 11, height = 6, units = c("in"))

ggsave(file="Output/Final_Figures/Mcap-Timepoint-PCA.pdf", Mcap_timepoint, width = 11, height = 6, units = c("in"))
ggsave(file="Output/Final_Figures/Mcap-Timepoint-PCA.png", Mcap_timepoint, width = 11, height = 6, units = c("in"))

Mcap.stress.PCAs <- arrangeGrob(Mcap_treatment, Mcap_timepoint, ncol=2)
ggsave(file="Output/Final_Figures/Mcap-stress-PCAs.pdf", Mcap.stress.PCAs, width = 10, height = 4, units = c("in"))
ggsave(file="Output/Final_Figures/Mcap-stress-PCAs.png", Mcap.stress.PCAs, width = 10, height = 4, units = c("in"))
```
```

