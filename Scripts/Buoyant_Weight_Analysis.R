#Title: Buoyant Weight Data
#Project: NSF BSF
#Author: HM Putnam 
#Edited by: HM Putnam; EL Strand
#Date Last Modified: 20190405
#See Readme file for details

rm(list=ls()) #clears workspace 

#Read in required libraries
##### Include Versions of libraries
library("tidyverse")
library("ggpubr")
library("ggplot2")
library("sciplot")
library("plotrix")
library("reshape2")
library("nlme") #mixed model, repeated measures ANOVA
library("lsmeans") #mixed model posthoc  statistical comparisons
if ("gridExtra" %in% rownames(installed.packages()) == 'FALSE') install.packages('gridExtra') 
library("gridExtra")

#Required Data files


#Timepoints
#Time0 - 20180920, 20180921 
#Time1 - 20180927, 20180928 - Week 1
#Time2 - 201801004, 20181005 - Week 2
#Time3 - 201801018, 201801019 - Week 4
#Time4 - 201801101, 201801102 - Week 6
#Time5 - 201801115, 201801116 - Week 8 
#Time6 - 201801129 - Week 10
#Time7 - 201801213 - Week 12
#Time8 - 201801227 - Week 14
#Time9 - 20190110 - Week 16


##### Standards ##### 
CalData<-read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_weight_calibration_curve.csv', header=T, sep=",")
#Data with Standard weights in grams in deionized water, saltwater, and the temp that they were measured at
  # No deionized water measurements 20190405 EL Strand

#plot relationship between temp and Standard in fresh and salt water
pdf("Physiology_variables/Growth_Buoyant_Weight/Buoyant Weight Standard Curves.pdf")
plot(CalData$Temp, CalData$StandardSalt, col = 'red', ylab = 'Salt Weight (g)', xlab = 'Temp C')
par(new=TRUE) #allows another set of data to be plotted on the same frame
plot(CalData$Temp, CalData$StandardFresh, col = 'blue',xaxt="n",yaxt="n",xlab="",ylab="")
axis(4) #adds a fourth axis on the right of the graph
mtext("'Fresh Weight (g)'",side=4,line=3) # text isn't printing on the graph
legend("topleft",col=c("red","blue"),lty=1,legend=c("Salt","Fresh"), bty = "n")
dev.off()

#linear regression between temp and Standard
#Salt water standard measures
StandardSaltModel <- lm(CalData$StandardSalt~CalData$Temp)
summary(StandardSaltModel)
summary(StandardSaltModel)$r.squared
StandardSaltModel$coef

#Fresh water standard measures
StandardFreshModel <- lm(CalData$StandardFresh~CalData$Temp)
summary(StandardFreshModel)
summary(StandardFreshModel)$r.squared
StandardFreshModel$coef


##### BW Function #####
BWCalc <- function(StandardAir= 31.348, Temp, BW, CoralDensity = 2.93){
  #Parameters---------------------------------------------------------------
  # StandardAir is the weight of the Standard in air (Default set at the grams weighed on top of the balance)
  # Temp is the temperature of the water during the coral measurement
  # BW is the buoywant weight of the coral
  # CoralDensity <- 2.03 #g cm-3, set aragonite density for Montipora from literature 
  # Montipora Arag = 2.03 g cm-3 average from table 2 in Anthony 2003 Functional Ecology 17:246-259
  # You can change the density to literatrue values for the specific coral species of interest in the function. 
  
  #Calculation------------------------------------------------------------
  #Step 1: correct the Standard weights for temperature
  # StandardFresh is the weight of the Standard in  fresh water at temp x
  # StandardSalt is the weight of the Standard in salt water at temp x
  
  # This is based on a calibration curve for Standards weighed in fresh and salt water at many temps
StandardFresh <- StandardFreshModel$coef[-1]*Temp + StandardFreshModel$coef[1] 
StandardSalt <- StandardSaltModel$coef[-1]*Temp + StandardSaltModel$coef[1] 
  
  # Step 2: Use weight in air and freshwater of the glass Standard to calculate
  # the density of the Standard (Spencer Davies eq. 4)
FreshDensity <- 1 #Fresh water has a density of 1 g/cm3
StandardDensity <- FreshDensity/(1-(StandardFresh/StandardAir)) 
  
  # Step 3: Calculate the density of seawater using the density of the Standard
  # (Spencer Davies eq. 3)
SWDensity <- StandardDensity*(1-(StandardSalt/StandardAir))
  
  # Step 4: Calculate the dry weight of the coral (Spencer Davies eq. 1)
CoralWeight <- BW/(1-(SWDensity/CoralDensity))
  
  return(CoralWeight) #returns coral dry weights in g
}

##### load coral weight data #####
#Initial points
T0.Init <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time0Init.csv', header=T, na.strings = "NA") 
T0.Init$Dry.Weigh.g <- BWCalc(BW=T0.Init$Mass.g, Temp=T0.Init$Temp.C) #use function to calculate dry weight
T1.Init <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time1Init.csv', header=T, na.strings = "NA") 
T1.Init$Dry.Weigh.g <- BWCalc(BW=T1.Init$Mass.g, Temp=T1.Init$Temp.C) #use function to calculate dry weight
T2.Init <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time2Init.csv', header=T, na.strings = "NA") 
T2.Init$Dry.Weigh.g <- BWCalc(BW=T2.Init$Mass.g, Temp=T2.Init$Temp.C) #use function to calculate dry weight
T3.Init <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time3Init.csv', header=T, na.strings = "NA") 
T3.Init$Dry.Weigh.g <- BWCalc(BW=T3.Init$Mass.g, Temp=T3.Init$Temp.C) #use function to calculate dry weight
T4.Init <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time4Init.csv', header=T, na.strings = "NA") 
T4.Init$Dry.Weigh.g <- BWCalc(BW=T4.Init$Mass.g, Temp=T4.Init$Temp.C) #use function to calculate dry weight
T5.Init <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time5Init.csv', header=T, na.strings = "NA") 
T5.Init$Dry.Weigh.g <- BWCalc(BW=T5.Init$Mass.g, Temp=T5.Init$Temp.C) #use function to calculate dry weight
T6.Init <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time6Init.csv', header=T, na.strings = "NA") 
T6.Init$Dry.Weigh.g <- BWCalc(BW=T6.Init$Mass.g, Temp=T6.Init$Temp.C) #use function to calculate dry weight
T7.Init <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time7Init.csv', header=T, na.strings = "NA") 
T7.Init$Dry.Weigh.g <- BWCalc(BW=T7.Init$Mass.g, Temp=T7.Init$Temp.C) #use function to calculate dry weight
T8.Init <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time8Init.csv', header=T, na.strings = "NA") 
T8.Init$Dry.Weigh.g <- BWCalc(BW=T8.Init$Mass.g, Temp=T8.Init$Temp.C) #use function to calculate dry weight

#Final points
T0.Fin <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time0Fin.csv', header=T, na.strings = "NA") 
T0.Fin$Dry.Weigh.g <- BWCalc(BW=T0.Fin$Mass.g, Temp=T0.Fin$Temp.C) #use function to calculate dry weight
T1.Fin <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time1Fin.csv', header=T, na.strings = "NA") 
T1.Fin$Dry.Weigh.g <- BWCalc(BW=T1.Fin$Mass.g, Temp=T1.Fin$Temp.C) #use function to calculate dry weight
T2.Fin <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time2Fin.csv', header=T, na.strings = "NA") 
T2.Fin$Dry.Weigh.g <- BWCalc(BW=T2.Fin$Mass.g, Temp=T2.Fin$Temp.C) #use function to calculate dry weight
T3.Fin <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time3Fin.csv', header=T, na.strings = "NA") 
T3.Fin$Dry.Weigh.g <- BWCalc(BW=T3.Fin$Mass.g, Temp=T3.Fin$Temp.C) #use function to calculate dry weight
T4.Fin <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time4Fin.csv', header=T, na.strings = "NA") 
T4.Fin$Dry.Weigh.g <- BWCalc(BW=T4.Fin$Mass.g, Temp=T4.Fin$Temp.C) #use function to calculate dry weight
T5.Fin <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time5Fin.csv', header=T, na.strings = "NA") 
T5.Fin$Dry.Weigh.g <- BWCalc(BW=T5.Fin$Mass.g, Temp=T5.Fin$Temp.C) #use function to calculate dry weight
T6.Fin <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time6Fin.csv', header=T, na.strings = "NA") 
T6.Fin$Dry.Weigh.g <- BWCalc(BW=T6.Fin$Mass.g, Temp=T6.Fin$Temp.C) #use function to calculate dry weight
T7.Fin <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time7Fin.csv', header=T, na.strings = "NA") 
T7.Fin$Dry.Weigh.g <- BWCalc(BW=T7.Fin$Mass.g, Temp=T7.Fin$Temp.C) #use function to calculate dry weight
T8.Fin <- read.csv('Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_Time8Fin.csv', header=T, na.strings = "NA") 
T8.Fin$Dry.Weigh.g <- BWCalc(BW=T8.Fin$Mass.g, Temp=T8.Fin$Temp.C) #use function to calculate dry weight

#check for outliers by plotting dry weight by tank and time
BW.data.long <- rbind(T0.Init,T0.Fin,T1.Init,T1.Fin,T2.Init,T2.Fin,T3.Init,T3.Fin,T4.Init,T4.Fin,
                      T5.Init,T5.Fin,T6.Init,T6.Fin,T7.Init,T7.Fin,T8.Init,T8.Fin)
ggboxplot(BW.data.long, x = "Tank", y = "Dry.Weigh.g", facet.by = "TimePoint")

#format to wide data for analysis
data <- reshape(BW.data.long, timevar = "TimePoint",drop = c("Analysis", "Tank", "Mass.g", "Temp.C"), idvar=c("PLUG.ID","Species", "Temperature", "CO2", "Treatment"), direction="wide")

#calculating time between measurements
data$Days.Time0 <- as.Date(as.character(data$Date.Format.Time0_Fin), format="%m/%d/%y")-
  as.Date(as.character(data$Date.Format.Time0_Init), format="%m/%d/%y")

data$Days.Time1 <- as.Date(as.character(data$Date.Format.Time1_Fin), format="%m/%d/%y")-
  as.Date(as.character(data$Date.Format.Time1_Init), format="%m/%d/%y")

data$Days.Time2 <- as.Date(as.character(data$Date.Format.Time2_Fin), format="%m/%d/%y")-
  as.Date(as.character(data$Date.Format.Time2_Init), format="%m/%d/%y")

data$Days.Time3 <- as.Date(as.character(data$Date.Format.Time3_Fin), format="%m/%d/%y")-
  as.Date(as.character(data$Date.Format.Time3_Init), format="%m/%d/%y")

data$Days.Time4 <- as.Date(as.character(data$Date.Format.Time4_Fin), format="%m/%d/%y")-
  as.Date(as.character(data$Date.Format.Time4_Init), format="%m/%d/%y")

data$Days.Time5 <- as.Date(as.character(data$Date.Format.Time5_Fin), format="%m/%d/%y")-
  as.Date(as.character(data$Date.Format.Time5_Init), format="%m/%d/%y")

data$Days.Time6 <- as.Date(as.character(data$Date.Format.Time6_Fin), format="%m/%d/%y")-
  as.Date(as.character(data$Date.Format.Time6_Init), format="%m/%d/%y")

data$Days.Time7 <- as.Date(as.character(data$Date.Format.Time7_Fin), format="%m/%d/%y")-
  as.Date(as.character(data$Date.Format.Time7_Init), format="%m/%d/%y")

data$Days.Time8 <- as.Date(as.character(data$Date.Format.Time8_Fin), format="%m/%d/%y")-
  as.Date(as.character(data$Date.Format.Time8_Init), format="%m/%d/%y")

#Growth Normalized to surface area
#Surface area by wax dipping Veal et al 


#load wax weight for standards
Stnds <- read.csv("Physiology_variables/Wax_dipping_standards.csv", header=TRUE)
Stnds$delta.mass.g <- Stnds$weight2.g-Stnds$weight1.g
stnd.curve <- lm(Surface_area~delta.mass.g, data=Stnds)
plot(Surface_area~delta.mass.g, data=Stnds)

#load wax weight for standards and samples
SA <- read.csv("Physiology_variables/Wax_dipping.csv", header=TRUE)
SA$delta.mass.g <- SA$weight2.g-SA$weight1.g
SA$SA.cm2 <- (stnd.curve$coefficients[2]*SA$delta.mass.g) + stnd.curve$coefficients[1]

#merge growth and surface area
data <- left_join(data, SA, by="PLUG.ID")

#Growth Rate (g/day/cm2)
data$T0.g.d.cm2 <- ((data$Dry.Weigh.g.Time0_Fin -data$Dry.Weigh.g.Time0_Init)/as.numeric(data$Days.Time0))/data$SA.cm2
data$T1.g.d.cm2 <- ((data$Dry.Weigh.g.Time1_Fin -data$Dry.Weigh.g.Time1_Init)/as.numeric(data$Days.Time1))/data$SA.cm2
data$T2.g.d.cm2 <- ((data$Dry.Weigh.g.Time2_Fin -data$Dry.Weigh.g.Time2_Init)/as.numeric(data$Days.Time2))/data$SA.cm2
data$T3.g.d.cm2 <- ((data$Dry.Weigh.g.Time3_Fin -data$Dry.Weigh.g.Time3_Init)/as.numeric(data$Days.Time3))/data$SA.cm2
data$T4.g.d.cm2 <- ((data$Dry.Weigh.g.Time4_Fin -data$Dry.Weigh.g.Time4_Init)/as.numeric(data$Days.Time4))/data$SA.cm2
data$T5.g.d.cm2 <- ((data$Dry.Weigh.g.Time5_Fin -data$Dry.Weigh.g.Time5_Init)/as.numeric(data$Days.Time5))/data$SA.cm2
data$T6.g.d.cm2 <- ((data$Dry.Weigh.g.Time6_Fin -data$Dry.Weigh.g.Time6_Init)/as.numeric(data$Days.Time6))/data$SA.cm2
data$T7.g.d.cm2 <- ((data$Dry.Weigh.g.Time7_Fin -data$Dry.Weigh.g.Time7_Init)/as.numeric(data$Days.Time7))/data$SA.cm2
data$T8.g.d.cm2 <- ((data$Dry.Weigh.g.Time8_Fin -data$Dry.Weigh.g.Time8_Init)/as.numeric(data$Days.Time8))/data$SA.cm2

#check for outliers by plotting dry weight by tank and time
par(mfrow=c(3,3))
boxplot(T0.g.d.cm2 ~Species*Treatment, data=data)
boxplot(T1.g.d.cm2 ~Species*Treatment, data=data)
boxplot(T2.g.d.cm2 ~Species*Treatment, data=data)
boxplot(T3.g.d.cm2 ~Species*Treatment, data=data)
boxplot(T4.g.d.cm2 ~Species*Treatment, data=data)
boxplot(T5.g.d.cm2 ~Species*Treatment, data=data)
boxplot(T6.g.d.cm2 ~Species*Treatment, data=data)
boxplot(T7.g.d.cm2 ~Species*Treatment, data=data)
boxplot(T8.g.d.cm2 ~Species*Treatment, data=data)

#reshape to long dataframe
data <- data[,c(1:5,75:83)]
colnames(data)
data.long <- pivot_longer(data, 
                          cols=c("T0.g.d.cm2","T1.g.d.cm2",  "T2.g.d.cm2",  
                                       "T3.g.d.cm2",  "T4.g.d.cm2",  "T5.g.d.cm2",
                                       "T6.g.d.cm2", "T7.g.d.cm2",  "T8.g.d.cm2"),
                          names_to = "TimePoint")

data.long <- na.omit(data.long)

ggboxplot(data.long, x = "TimePoint", y = "value", facet.by = "Species")

#remove outlier values > 0.01 
data.long <- data.long %>%
  filter(value < 0.005 )

ggboxplot(data.long, x = "TimePoint", y = "value", facet.by = "Species")

#remove outlier values < -0.01 b
data.long <- data.long %>%
  filter(value > -0.001 )

ggboxplot(data.long, x = "TimePoint", y = "value", facet.by = "Species")

data.long$mg.d.cm2 <- data.long$value*1000


All.Means <- ddply(data.long, c('TimePoint','Species', 'Treatment'), summarize,
                   mean= mean(mg.d.cm2, na.rm=T), #mean pnet
                   N = sum(!is.na(mg.d.cm2)), # sample size
                   se = sd(mg.d.cm2, na.rm=T)/sqrt(N)) #SE
All.Means

All.Means$Group <- paste(All.Means$TimePoint, All.Means$Treatment, All.Means$Species)
All.Means$SpGroup <- paste(All.Means$Treatment, All.Means$Species)

Mcap.Means <- subset(All.Means, Species =="Mcapitata")
Pact.Means <- subset(All.Means, Species =="Pacuta")

#set time info for plotting
Mcap.Means$week <- c("Week1", "Week1","Week1","Week1","Week2","Week2","Week2","Week2",
                    "Week4", "Week4", "Week4", "Week4", "Week6", "Week6", "Week6", "Week6",
                     "Week8", "Week8", "Week8", "Week8", "Week10", "Week10", "Week10", "Week10",
                    "Week12", "Week12", "Week12", "Week12", "Week14", "Week14", "Week14", "Week14",
                    "Week16", "Week16", "Week16", "Week16")
Mcap.Means$week <- factor(Mcap.Means$week, levels=c("Week1","Week2","Week4","Week6","Week8","Week10","Week12","Week14","Week16"))


#remove sample sizes of 2 or less 
Pact.Means <- Pact.Means[-c(23,26),]

Pact.Means$week <- c("Week1", "Week1","Week1","Week1","Week2","Week2","Week2","Week2",
                     "Week4", "Week4", "Week4", "Week4", "Week6", "Week6", "Week6", "Week6",
                     "Week8", "Week8", "Week8", "Week8", "Week10", "Week10", "Week12", "Week12", 
                     "Week14", "Week14",  "Week16", "Week16")

Pact.Means$week <- factor(Pact.Means$week, levels=c("Week1","Week2","Week4","Week6","Week8","Week10","Week12","Week14","Week16"))

cols <- c("lightblue", "blue", "pink", "red")

Fig.Mcap <- ggplot(Mcap.Means, aes(x=week, y=mean, group=Treatment)) + 
  geom_line(aes(colour=Treatment, group=Treatment), position = position_dodge(width = 0.1), alpha=1) + # colour, group both depend on cond2
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se), colour="darkgray", width=0, size=1, position = position_dodge(width = 0.1)) +
  geom_point(aes(colour=Treatment), size = 3, position = position_dodge(width = 0.1)) +
  scale_colour_manual(values=cols) +
  xlab("Timepoint") +
  ylab(expression(Growth  ~(mg ~CaCO[3] ~cm^-2 ~d^-1))) +
  ylim(-0.5,1.5) +
  theme_bw() + #Set the background color
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), #Set the text angle
        axis.line = element_line(color = 'black'), #Set the axes color
        panel.border = element_blank(), #Set the border
        panel.grid.major = element_blank(), #Set the major gridlines
        panel.grid.minor = element_blank(), #Set the minor gridlines
        legend.position = c(0.15, 0.8 ), #remove legend
        plot.background=element_blank())+  #Set the plot background
  ggtitle("A) M. capitata") +
  theme(plot.title = element_text(face = 'bold.italic', 
                                  size = 12, 
                                  hjust = 0))
Fig.Mcap

Fig.Pact <- ggplot(Pact.Means, aes(x=week, y=mean, group=Treatment)) + 
  geom_line(aes(colour=Treatment, group=Treatment), position = position_dodge(width = 0.1), alpha=1) + # colour, group both depend on cond2
  geom_errorbar(aes(ymin=mean-se, ymax=mean+se), colour="darkgray", width=0, size=1, position = position_dodge(width = 0.1)) +
  geom_point(aes(colour=Treatment, shape=Species), size = 3, position = position_dodge(width = 0.1)) +
  scale_colour_manual(values=cols) +
  xlab("Timepoint") +
  ylab(expression(Growth  ~(mg ~CaCO[3] ~cm^-2 ~d^-1))) +
  ylim(-0.5,1.5) +
  theme_bw() + #Set the background color
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1), #Set the text angle
        axis.line = element_line(color = 'black'), #Set the axes color
        panel.border = element_blank(), #Set the border
        panel.grid.major = element_blank(), #Set the major gridlines
        panel.grid.minor = element_blank(), #Set the minor gridlines
        legend.position = "none", #remove legend
        plot.background=element_blank())+  #Set the plot background
  ggtitle("B) P. acuta") +
  theme(plot.title = element_text(face = 'bold.italic', 
                                  size = 12, 
                                  hjust = 0))
Fig.Pact

Gro.Figs <- arrangeGrob(Fig.Mcap, Fig.Pact, ncol=2)
ggsave(file="Output/Growth_percent_BW.pdf", Gro.Figs, width = 11, height = 6, units = c("in"))
ggsave(file="Output/Growth_percent_BW.png", Gro.Figs, width = 11, height = 6, units = c("in"))

