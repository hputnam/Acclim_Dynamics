#Title: Bouyant weight standard curves
#Project: NSF BSF
#Author: KH Wong 
#Edited by: KH Wong; EL Strand
#Date Last Modified: 20190405
#See Readme file for details

rm(list=ls()) #clears workspace 

require(dplyr)
library(ggplot2)

setwd("~/MyProjects/Holobiont_Integration/RAnalysis/Data/Buoyant_Weight/") #set working directory

bw.standard <-read.table("Buoyant_weight_calibration_curve.csv", header=TRUE, sep=",", na.string="NA", as.is=TRUE) #reads in the data files

### FRESHWATER STANDARD ###

# fresh <- bw.standard %>% 
#   filter(Standard.Type == "fresh-water") 

pdf("BW Fresh-water Standard.pdf")
ggplot(data = bw.standard, aes(x=Temp, y=StandardFresh))+
  ylab("Mass (g)")+ xlab("Temperature (C)") + 
  geom_point()+
  geom_smooth(method = "lm") +
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()

lmstandard_fresh <- lm (StandardFresh ~ Temp, data = bw.standard)
summary(lmstandard_fresh)

### SALTWATER STANDARD ###

# salt <- bw.standard %>% 
 #  filter(Standard.Type == "salt-water") 

pdf("BW Salt-water Standard.pdf")
ggplot(data = bw.standard, aes(x=Temp, y=StandardSalt))+
  ylab("Mass (g)")+ xlab("Temperature (C)") + 
  geom_point()+
  geom_smooth(method = "lm") +
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black")) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
dev.off()

lmstandard_salt <- lm (StandardSalt ~ Temp, data = bw.standard)
summary(lmstandard_salt)
