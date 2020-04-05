#Title: Flow Assessment
#Project: NSF BSF
#Author: HM Putnam 
#Edited by: HM Putnam
#Date Last Modified: 20180927
#See Readme file for details

rm(list=ls()) #clears workspace 

#Read in required libraries
##### Include Versions of libraries

rm(list=ls()) #clears workspace 

#Read in required libraries
##### Include Versions of libraries

# Set Working Directory:
setwd("~/MyProjects/Holobiont_Integration/RAnalysis/Data/") #set working

# load data 
Tank.Info <-read.csv('Tank_to_Treatment.csv', header=T, sep=",")
FlowData<-read.csv('Flow_rate.csv', header=T, sep=",")
FlowData<- merge(FlowData,Tank.Info, by="Tank" )
FlowData$ml.sec <- FlowData$Volume.ml/FlowData$Time.sec

pdf("../Output/Flow.by.Position.Treatment.pdf")
par(mfrow=c(2,2))
boxplot(ml.sec ~ Tank, data=FlowData, xlab="Tank", ylab="Flow rate ml sec -1")
boxplot(ml.sec ~ Treatment, data=FlowData, xlab="Tank", ylab="Flow rate ml sec -1")
dev.off()

tank.model <- lm(ml.sec ~ Tank, data=FlowData)
summary(tank.model)

trt.model <- lm(ml.sec ~ Treatment, data=FlowData)
summary(trt.model)
