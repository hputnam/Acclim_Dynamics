#Title: Testing tank temps with heaters set at 31°C
#Author: HM Putnam 
#Edited by: HM Putnam
#Date Last Modified: 2018903
#See Readme file for details

rm(list=ls()) #clears workspace 

library(lubridate)
library(tidyr)
library(plotrix)
library(tidyverse)
library(dplyr)
library(reshape2)
library(gridExtra)

setwd("~/MyProjects/Holobiont_Integration/RAnalysis/")

##### Empty tank Heater test #####

Tank1 <- read.csv("Data/Hobo_Loggers/20190117/20190117_Tank1.csv", sep=",", skip=c(40), header=FALSE, na.strings = "NA")[ ,2:3]
Tank2 <- read.csv("Data/Hobo_Loggers/20190117/20190117_Tank2.csv", sep=",", skip=c(40), header=FALSE, na.strings = "NA")[ ,2:3]
Tank2 <- Tank2[1:nrow(Tank1),]
Tank3 <- read.csv("Data/Hobo_Loggers/20190117/20190117_Tank3.csv", sep=",", skip=c(40), header=FALSE, na.strings = "NA")[ ,2:3]
Tank3 <- Tank3[1:nrow(Tank1),]
Tank4 <- read.csv("Data/Hobo_Loggers/20190117/20190117_Tank4.csv", sep=",", skip=c(40), header=FALSE, na.strings = "NA")[ ,2:3]
Tank4 <- Tank4[1:nrow(Tank1),]
Tank5 <- read.csv("Data/Hobo_Loggers/20190117/20190117_Tank5.csv", sep=",", skip=c(40), header=FALSE, na.strings = "NA")[ ,2:3]
Tank5 <- Tank5[1:nrow(Tank1),]
Tank6 <- read.csv("Data/Hobo_Loggers/20190117/20190117_Tank6.csv", sep=",", skip=c(40), header=FALSE, na.strings = "NA")[ ,2:3]
Tank6 <- Tank6[1:nrow(Tank1),]
Tank7 <- read.csv("Data/Hobo_Loggers/20190117/20190117_Tank7.csv", sep=",", skip=c(40), header=FALSE, na.strings = "NA")[ ,2:3]
Tank7 <- Tank7[1:nrow(Tank1),]
Tank8 <- read.csv("Data/Hobo_Loggers/20190117/20190117_Tank8.csv", sep=",", skip=c(40), header=FALSE, na.strings = "NA")[ ,2:3]
Tank8 <- Tank8[1:nrow(Tank1),]
Tank9 <- read.csv("Data/Hobo_Loggers/20190117/20190117_Tank9.csv", sep=",", skip=c(40), header=FALSE, na.strings = "NA")[ ,2:3]
Tank9 <- Tank9[1:nrow(Tank1),]
Tank10 <- read.csv("Data/Hobo_Loggers/20190117/20190117_Tank10.csv", sep=",", skip=c(40), header=FALSE, na.strings = "NA")[ ,2:3]
Tank10 <- Tank10[1:nrow(Tank1),]
#Tank10 <- Tank10[seq(6, NROW(Tank10), by = 6),]
#Tank10[c(nrow(Tank10)+1:(nrow(Tank1)-nrow(Tank10))),2] <- "NA"
#Tank10$V3 <- as.numeric(Tank10$V3)
Tank11 <- read.csv("Data/Hobo_Loggers/20190117/20190117_Tank11.csv", sep=",", skip=c(40), header=FALSE, na.strings = "NA")[ ,2:3]
Tank11 <- Tank11[1:nrow(Tank1),]
Tank12 <- read.csv("Data/Hobo_Loggers/20190117/20190117_Tank12.csv", sep=",", skip=c(40), header=FALSE, na.strings = "NA")[ ,2:3]
Tank12 <- Tank12[1:nrow(Tank1),]

data <- cbind(Tank2, Tank1$V3, Tank3$V3, Tank4$V3, Tank5$V3, Tank6$V3, Tank7$V3, Tank8$V3, Tank9$V3, Tank10$V3, Tank11$V3, Tank12$V3)
colnames(data) <- c("Date.Time", "Tank2", "Tank1", "Tank3", "Tank4", "Tank5", "Tank6", "Tank7", "Tank8", "Tank9", "Tank10", "Tank11", "Tank12")
data <- data [1:(nrow(data )-10),]
data$Date.Time <- parse_date_time(data$Date.Time, "%m/%d/%y %I:%M:%S %p", tz="HST")


# ##### Cross Calibration and Acclimation data ####
# 
# Tank1 <- read.csv("Hobo_Loggers/20180915/20180915_Tank1.csv", sep=",", skip=c(1), header=TRUE, na.strings = "NA")[ ,2:3]
# Tank1 <- Tank1[-c((nrow(Tank1)-2):(nrow(Tank1))),]
# Tank2 <- read.csv("Hobo_Loggers/20180915/20180915_Tank2.csv", sep=",", skip=c(2), header=FALSE, na.strings = "NA")[ ,2:3]
# Tank2 <- Tank2[-c((nrow(Tank2)-1):(nrow(Tank2))),]
# Tank3 <- read.csv("Hobo_Loggers/20180915/20180915_Tank3.csv", sep=",", skip=c(2), header=FALSE, na.strings = "NA")[ ,2:3]
# Tank3 <- Tank3[-c((nrow(Tank3)-2):(nrow(Tank3))),]
# Tank4 <- read.csv("Hobo_Loggers/20180915/20180915_Tank4.csv", sep=",", skip=c(2), header=FALSE, na.strings = "NA")[ ,2:3]
# Tank4 <- Tank4[-c((nrow(Tank4)-2):(nrow(Tank4))),]
# Tank5 <- read.csv("Hobo_Loggers/20180915/20180915_Tank5.csv", sep=",", skip=c(2), header=FALSE, na.strings = "NA")[ ,2:3]
# Tank5 <- Tank5[-c((nrow(Tank5)-1):(nrow(Tank5))),]
# Tank6 <- read.csv("Hobo_Loggers/20180915/20180915_Tank6.csv", sep=",", skip=c(2), header=FALSE, na.strings = "NA")[ ,2:3]
# Tank6 <- Tank6[-c((nrow(Tank6)-0):(nrow(Tank6))),]
# Tank7 <- read.csv("Hobo_Loggers/20180915/20180915_Tank7.csv", sep=",", skip=c(2), header=FALSE, na.strings = "NA")[ ,2:3]
# Tank7 <- Tank7[-c((nrow(Tank7)-0):(nrow(Tank7))),]
# Tank8 <- read.csv("Hobo_Loggers/20180915/20180915_Tank8.csv", sep=",", skip=c(2), header=FALSE, na.strings = "NA")[ ,2:3]
# Tank8 <- Tank8[-c((nrow(Tank8)-2):(nrow(Tank8))),]
# Tank9 <- read.csv("Hobo_Loggers/20180915/20180915_Tank9.csv", sep=",", skip=c(2), header=FALSE, na.strings = "NA")[ ,2:3]
# Tank9 <- Tank9[-c((nrow(Tank9)-1):(nrow(Tank9))),]
# Tank10 <- read.csv("Hobo_Loggers/20180915/20180915_Tank10.csv", sep=",", skip=c(2), header=FALSE, na.strings = "NA")[ ,2:3]
# Tank10 <- Tank10[-c((nrow(Tank10)-1):(nrow(Tank10))),]
# Tank11 <- read.csv("Hobo_Loggers/20180915/20180915_Tank11.csv", sep=",", skip=c(2), header=FALSE, na.strings = "NA")[ ,2:3]
# Tank11 <- Tank11[-c((nrow(Tank11)-1):(nrow(Tank11))),]
# Tank12 <- read.csv("Hobo_Loggers/20180915/20180915_Tank12.csv", sep=",", skip=c(2), header=FALSE, na.strings = "NA")[ ,2:3]
# Tank12 <- Tank12[-c((nrow(Tank12)-0):(nrow(Tank12))),]
# 
# 
# data <- cbind(Tank1, Tank2$V3, Tank3$V3, Tank4$V3, Tank5$V3, Tank6$V3, Tank7$V3, Tank8$V3, Tank9$V3, Tank10$V3, Tank11$V3, Tank12$V3)
# colnames(data) <- c("Date.Time", "Tank1", "Tank2", "Tank3", "Tank4", "Tank5", "Tank6", "Tank7", "Tank8", "Tank9", "Tank10", "Tank11", "Tank12")
# data$Date.Time <- parse_date_time(data$Date.Time, "%m/%d/%y %I:%M:%S %p", tz="HST")
# 
# pdf("~/MyProjects/Holobiont_Integration/RAnalysis/Output/20180915_Tank_Temps.pdf")
# plot(data$Date.Time, data$Tank1, cex=0.2, col="blue", ylim=c(24,31), ylab="Temperature °C", xlab="Date and Time")
# points(data$Date.Time, data$Tank2, cex=0.2, col="red")
# points(data$Date.Time, data$Tank3, cex=0.2, col="blue")
# points(data$Date.Time, data$Tank4, cex=0.2, col="red")
# points(data$Date.Time, data$Tank5, cex=0.2, col="red")
# points(data$Date.Time, data$Tank6, cex=0.2, col="blue")
# points(data$Date.Time, data$Tank7, cex=0.2, col="red")
# points(data$Date.Time, data$Tank8, cex=0.2, col="blue")
# points(data$Date.Time, data$Tank9, cex=0.2, col="red")
# points(data$Date.Time, data$Tank10, cex=0.2, col="red")
# points(data$Date.Time, data$Tank11, cex=0.2, col="blue")
# points(data$Date.Time, data$Tank12, cex=0.2, col="blue")
# dev.off()
# 
# means <- colMeans(data[,c(2:ncol(data))], na.rm=TRUE)
# means
# 
# ##### subset to acclimation tanks only 
# 
# #acc.data <- subset(data, Data.Time >)

##### Treatments #####

data.trt <-data[2502:11160,]
head(data.trt) #20180921
tail(data.trt) #20181119

data.ramp <-data[11161:15201,]
head(data.ramp) #20181120
tail(data.ramp) #20181218

data.recovery <- data[15202:(nrow(data)-2),]
head(data.recovery) #20181219
tail(data.recovery) #2090117

pdf("~/MyProjects/Holobiont_Integration/RAnalysis/Output/Trt_Temps.pdf")
par(mfrow=c(1,3))
plot(data.trt$Date.Time, data.trt$Tank1, cex=0.2, col="red", ylim=c(21,31), ylab="Temperature °C", xlab="Date and Time")
points(data.trt$Date.Time, data.trt$Tank2, cex=0.2, col="orange")
points(data.trt$Date.Time, data.trt$Tank3, cex=0.2, col="yellow")
points(data.trt$Date.Time, data.trt$Tank4, cex=0.2, col="green")
points(data.trt$Date.Time, data.trt$Tank5, cex=0.2, col="blue")
points(data.trt$Date.Time, data.trt$Tank6, cex=0.2, col="cyan")
points(data.trt$Date.Time, data.trt$Tank7, cex=0.2, col="purple")
points(data.trt$Date.Time, data.trt$Tank8, cex=0.2, col="grey")
points(data.trt$Date.Time, data.trt$Tank9, cex=0.2, col="black")
points(data.trt$Date.Time, data.trt$Tank10, cex=0.2, col="brown")
points(data.trt$Date.Time, data.trt$Tank11, cex=0.2, col="pink")
points(data.trt$Date.Time, data.trt$Tank12, cex=0.2, col="darkgreen")

plot(data.ramp$Date.Time, data.ramp$Tank1, cex=0.2, col="red", ylim=c(21,31), ylab="Temperature °C", xlab="Date and Time")
points(data.ramp$Date.Time, data.ramp$Tank2, cex=0.2, col="orange")
points(data.ramp$Date.Time, data.ramp$Tank3, cex=0.2, col="yellow")
points(data.ramp$Date.Time, data.ramp$Tank4, cex=0.2, col="green")
points(data.ramp$Date.Time, data.ramp$Tank5, cex=0.2, col="blue")
points(data.ramp$Date.Time, data.ramp$Tank6, cex=0.2, col="cyan")
points(data.ramp$Date.Time, data.ramp$Tank7, cex=0.2, col="purple")
points(data.ramp$Date.Time, data.ramp$Tank8, cex=0.2, col="grey")
points(data.ramp$Date.Time, data.ramp$Tank9, cex=0.2, col="black")
points(data.ramp$Date.Time, data.ramp$Tank10, cex=0.2, col="brown")
points(data.ramp$Date.Time, data.ramp$Tank11, cex=0.2, col="pink")
points(data.ramp$Date.Time, data.ramp$Tank12, cex=0.2, col="darkgreen")
legend("bottomright", c("Tank_1-ATAC", "Tank_2-HTHC","Tank_3-ATHC", "Tank_4-HTAC","Tank_5-HTHC", "Tank_6-ATAC","Tank_7-HTAC", "Tank_8-ATAC","Tank_9-HTAC", "Tank_10-HTHC","Tank_11-ATHC", "Tank_12-ATHC"), col=c("red", "orange", "yellow","green","blue","cyan","purple","grey","black","brown","pink","darkgreen"),cex=0.5, lty=1,
       inset=c(0,1), xpd=TRUE, horiz=TRUE, bty="n")

plot(data.recovery$Date.Time, data.recovery$Tank1, cex=0.2, col="red", ylim=c(21,31), ylab="Temperature °C", xlab="Date and Time")
points(data.recovery$Date.Time, data.recovery$Tank2, cex=0.2, col="orange")
points(data.recovery$Date.Time, data.recovery$Tank3, cex=0.2, col="yellow")
points(data.recovery$Date.Time, data.recovery$Tank4, cex=0.2, col="green")
points(data.recovery$Date.Time, data.recovery$Tank5, cex=0.2, col="blue")
points(data.recovery$Date.Time, data.recovery$Tank6, cex=0.2, col="cyan")
points(data.recovery$Date.Time, data.recovery$Tank7, cex=0.2, col="purple")
points(data.recovery$Date.Time, data.recovery$Tank8, cex=0.2, col="grey")
points(data.recovery$Date.Time, data.recovery$Tank9, cex=0.2, col="black")
points(data.recovery$Date.Time, data.recovery$Tank10, cex=0.2, col="brown")
points(data.recovery$Date.Time, data.recovery$Tank11, cex=0.2, col="pink")
points(data.recovery$Date.Time, data.recovery$Tank12, cex=0.2, col="darkgreen")
dev.off()

x <- gather(data.trt)
x <- x[ grep("Date.Time", x$key, invert = TRUE) , ] 

Info <- read.csv("Data/Tank_to_Treatment.csv", header=TRUE, sep=",")
Info$Tank.Name <- as.character(Info$Tank.Name)

means <- aggregate(value~key, data=x, FUN=mean)
ses <- aggregate(value~key, data=x, FUN=std.error)
means$se <- ses$value
colnames(means) <- c("Tank.Name", "mean", "se")

means <- merge(means, Info, by="Tank.Name")
boxplot(means$mean ~ as.factor(means$Tank.Name) )


data.hrly <- data.trt[c(180:nrow(data.trt)),]
data.hrly$hourly <- format(as.POSIXct(data.hrly$Date.Time) ,format = "%H")
data.hrly <- melt(data.hrly)
data.hrly <- subset(data.hrly, variable!="Date.Time")

temp.sums <- aggregate(value~variable*hourly, data=data.hrly, FUN=mean)
ses <- aggregate(value~variable*hourly, data=data.hrly, FUN=std.error)
temp.sums$se <- ses$value
temp.sums$hour <-as.factor(as.numeric(temp.sums$hour))
colnames(temp.sums) <- c("Tank.Name", "hour", "mean", "se")

#Tank Temperature Data 
Fig2 <- ggplot(temp.sums) + #Plot average diurnal cycle of temperature data
  geom_point(aes(x = as.factor(hour), y = mean), colour="darkgray", cex=0.2) + #Plot points using time as the x axis, light as the Y axis and black dots
  geom_errorbar(aes(x=as.factor(hour), ymax=mean+se, ymin=mean-se), position=position_dodge(0.9), data=temp.sums, col="black", width=0.1) + #set values for standard error bars and offset on the X axis for clarity
  #scale_x_discrete(breaks=c("01:00", "06:00", "12:00", "18:00", "23:00")) + #set discrete breaks on the X axis
  ggtitle("Hourly Tank Temperature") + #Label the graph with the main title
  ylim(21.5,28.5) + #Set Y axis limits
  xlab("Time") + #Label the X Axis
  ylab("Temperature (°C)") + #Label the Y Axis
  theme_bw() + #Set the background color
  theme(axis.line = element_line(color = 'black'), #Set the axes color
        axis.ticks.length=unit(-0.2, "cm"), #turn ticks inward
        axis.text.y = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm")), #set margins on labels
        axis.text.x = element_text(margin=unit(c(0.5,0.5,0.5,0.5), "cm"), angle = 90, vjust = 0.5, hjust=1), #set margins on labels
        panel.grid.major = element_blank(), #Set the major gridlines
        panel.grid.minor = element_blank(), #Set the minor gridlines
        plot.background=element_blank(), #Set the plot background
        panel.border=element_rect(size=1.25, fill = NA), #set outer border
        plot.title=element_text(hjust=0)) #Justify the title to the top left
Fig2 #View figure

Tmp.Figs <- arrangeGrob(Fig2, ncol=1)
ggsave(file="Output/Hourly_Avg_temps.pdf", Tmp.Figs, width = 4, height = 3, units = c("in"))

