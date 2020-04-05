#Title: Light Assessment
#Project: NSF BSF
#Author: HM Putnam 
#Edited by: HM Putnam
#Date Last Modified: 20180927
#See Readme file for details

rm(list=ls()) #clears workspace 

#Read in required libraries
##### Include Versions of libraries

# Set Working Directory:
setwd("~/MyProjects/Holobiont_Integration/RAnalysis/Data/") #set working

# load data 
LightData<-read.csv('BlueTank_Light_Data.csv', header=T, sep=",")

licor6 <- subset(LightData, Instrument=="LICOR-193")
licor6 <- subset(LightData, Measure.Type=="Six-point")
licor1 <- subset(LightData, Instrument=="LICOR-193")
licor1 <- subset(LightData, Measure.Type=="One-point")
  
plot(PAR ~ Tank, data=licor6, col=Position)

tank.model <- lm(PAR ~ Tank,data=licor6)
summary(tank.model)

position.model <- lm(PAR ~ Position, data=licor6)
summary(position.model)


pdf("../Output/Light.by.Position.pdf")
par(mfrow=c(3,4))
Tank1 <- subset(licor6, Tank==1)
plot(PAR ~ Position, data=Tank1, col=Position, ylim=c(0,1000), main = "Tank1")

Tank2 <- subset(licor6, Tank==2)
plot(PAR ~ Position, data=Tank2, col=Position, ylim=c(0,1000), main = "Tank2")

Tank3 <- subset(licor6, Tank==3)
plot(PAR ~ Position, data=Tank3, col=Position, ylim=c(0,1000), main = "Tank3")

Tank4 <- subset(licor6, Tank==4)
plot(PAR ~ Position, data=Tank4, col=Position, ylim=c(0,1000), main = "Tank4")

Tank5 <- subset(licor6, Tank==5)
plot(PAR ~ Position, data=Tank5, col=Position, ylim=c(0,1000), main = "Tank5")

Tank6 <- subset(licor6, Tank==6)
plot(PAR ~ Position, data=Tank6, col=Position, ylim=c(0,1000), main = "Tank6")

Tank7 <- subset(licor6, Tank==7)
plot(PAR ~ Position, data=Tank7, col=Position, ylim=c(0,1000), main = "Tank7")

Tank8 <- subset(licor6, Tank==8)
plot(PAR ~ Position, data=Tank8, col=Position, ylim=c(0,1000), main = "Tank8")

Tank9 <- subset(licor6, Tank==9)
plot(PAR ~ Position, data=Tank9, col=Position, ylim=c(0,1000), main = "Tank9")

Tank10 <- subset(licor6, Tank==10)
plot(PAR ~ Position, data=Tank10, col=Position, ylim=c(0,1000), main = "Tank10")

Tank11 <- subset(licor6, Tank==11)
plot(PAR ~ Position, data=Tank11, col=Position, ylim=c(0,1000), main = "Tank11")

Tank12 <- subset(licor6, Tank==12)
plot(PAR ~ Position, data=Tank12, col=Position, ylim=c(0,1000), main = "Tank12")

dev.off()

mean6 <- aggregate(PAR ~ Tank*Position, data=licor6, FUN=mean)
mean6

pdf("../Output/Light.by.OnePoint.pdf")
plot(as.factor(licor1$Tank), licor1$PAR, xlab="Tank", ylab="PAR", ylim=c(0,800), las=2)
# boxplot(PAR ~ Tank, data = licor1, outpch = NA) 
stripchart(PAR ~ Tank, data = licor1, 
           vertical = TRUE, method = "jitter", 
           pch = 21, col = "blue", bg = "blue", 
           add = TRUE) 
dev.off()

licor1$Tank <- factor(licor1$Tank)

# pdf("~/MyProjects/Holobiont_Integration/RAnalysis/Output/LightbyTime_Output.pdf")
# par(mfrow=c(2,1))
# plot(as.numeric(as.character(PAR)) ~ Time, licor1, col = "red", type="l", ylim=c(0, 1000),  xlab="Time", ylab="Light (PAR)")
# lines(as.numeric(as.character(PAR)) ~ Time, licor1, col = "orange")
# lines(as.numeric(as.character(PAR)) ~ Time, licor1, col = "yellow")
# lines(as.numeric(as.character(PAR)) ~ Time, licor1, col = "green")
# lines(as.numeric(as.character(PAR)) ~ Time, licor1, col = "blue")
# lines(as.numeric(as.character(PAR)) ~ Time, licor1, col = "cyan")
# lines(as.numeric(as.character(PAR)) ~ Time, licor1, col = "purple")
# lines(as.numeric(as.character(PAR)) ~ Time, licor1, col = "grey")
# lines(as.numeric(as.character(PAR)) ~ Time, licor1, col = "black")
# lines(as.numeric(as.character(PAR)) ~ Time, licor1, col = "brown")
# lines(as.numeric(as.character(PAR)) ~ Time, licor1, col = "pink")
# lines(as.numeric(as.character(PAR)) ~ Time, licor1, col = "darkgreen")
# legend("bottomright", c("Tank_1", "Tank_2","Tank_3", "Tank_4","Tank_5", "Tank_6","Tank_7", "Tank_8","Tank_9", "Tank_10","Tank_11", "Tank_12"), col=c("red", "orange", "yellow","green","blue","cyan","purple","grey","black","brown","pink","darkgreen"),cex=0.4, lty=1,
#        inset=c(0,1), xpd=TRUE, horiz=TRUE, bty="n")
# dev.off()
