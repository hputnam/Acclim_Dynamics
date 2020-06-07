#Title: Thermal Transplant 2017-2018 - BEACON field temps
#Author: KH Wong
#Date Last Modified: 202023
#See Readme file for details 

library(dbplyr)
library(tidyverse)
library(readr)
library(stringr)
library(gridExtra)
library(grid)
library(ggplot2)
library(lattice)
library(Rmisc)
library(doBy)
library(devtools)
devtools::install_github("ricardo-bion/ggradar", dependencies = TRUE)
library(ggradar)
library(ggiraphExtra)
library(tidyverse)
library(scales)

##### 2012-2016 field temps #####
#Import data
Crescent.2010 <- read.csv("data/2018/Field_Temp/Crescent_64W_32N_Nov2010_Feb2012.csv") 
Crescent.2012 <- read.csv("data/2018/Field_Temp/Crescent_64W_32N_Feb2012_Feb2013.csv") 
Crescent.2013 <- read.csv("data/2018/Field_Temp/Crescent_64W_32N_Apr2013_Mar2014.csv")
Crescent.2014 <- read.csv("data/2018/Field_Temp/Crescent_64W_32N_Jul2014_Jul2015.csv")
Crescent.2015 <- read.csv("data/2018/Field_Temp/Crescent_64W_32N_Jul2015_Apr2016.csv")

Hog.2010 <- read.csv("data/2018/Field_Temp/Hog_Reef_64W_32N_Dec2010_Jan2012.csv")
Hog.2012 <- read.csv("data/2018/Field_Temp/Hog_Reef_64W_32N_Feb2012_Mar2013.csv")
Hog.2013 <- read.csv("data/2018/Field_Temp/Hog_Reef_64W_32N_Apr2013_Jun2014.csv")
Hog.2014.a <- read.csv("data/2018/Field_Temp/Hog_Reef_64W_32N_Jul2014_Oct2014.csv")
Hog.2014.b <- read.csv("data/2018/Field_Temp/Hog_Reef_64W_32N_Oct2014_Jan2015.csv")
Hog.2015 <- read.csv("data/2018/Field_Temp/Hog_Reef_64W_32N_Jul2015_Aug2016.csv")

# Selecting Columns 
Crescent.2010.1 <- Crescent.2010 %>% select(Mooring.Name, Date, Time, SST_C, Salinity, pCO2_SW_uatm)
Crescent.2012.1 <- Crescent.2012 %>% select(Mooring.Name, Date, Time, SST_C, Salinity, pCO2_SW_uatm)
Crescent.2013.1 <- Crescent.2013 %>% select(Mooring.Name, Date, Time, SST_C, Salinity, pCO2_SW_uatm)
Crescent.2014.1 <- Crescent.2014 %>% select(Mooring.Name, Date, Time, SST_C, Salinity, pCO2_SW_uatm)
Crescent.2015.1 <- Crescent.2015 %>% select(Mooring.Name, Date, Time, SST_C, Salinity, pCO2_SW_uatm)

Hog.2010.1 <- Hog.2010 %>% select(Mooring.Name, Date, Time, SST_C, Salinity, pCO2_SW_uatm)
Hog.2012.1 <- Hog.2012 %>% select(Mooring.Name, Date, Time, SST_C, Salinity, pCO2_SW_uatm)
Hog.2013.1 <- Hog.2013 %>% select(Mooring.Name, Date, Time, SST_C, Salinity, pCO2_SW_uatm)
Hog.2014.a1 <- Hog.2014.a %>% select(Mooring.Name, Date, Time, SST_C, Salinity, pCO2_SW_uatm)
Hog.2014.b1 <- Hog.2014.b %>% select(Mooring.Name, Date, Time, SST_C, Salinity, pCO2_SW_uatm)
Hog.2015.1 <- Hog.2015 %>% select(Mooring.Name, Date, Time, SST_C, Salinity, pCO2_SW_uatm)

#Binding Data by reef site 
Crescent.2010.2015 <- rbind(Crescent.2010.1, Crescent.2012.1, Crescent.2013.1, Crescent.2014.1, Crescent.2015.1)
Hog.2010.2015 <- rbind(Hog.2010.1, Hog.2012.1, Hog.2013.1, Hog.2014.a1, Hog.2014.b1, Hog.2015.1)

#Adding reef zone
Crescent.2010.2015$Reef <- "Patch"
Hog.2010.2015$Reef <- "Rim"

#Binding all datasets together
bda.2010.2015 <- rbind(Crescent.2010.2015, Hog.2010.2015)

#Changing date format 
bda.2010.2015$Date <- as.Date(bda.2010.2015$Date, "%m/%d/%Y")

#Removing NAs
bda.2010.2015 <- na.omit(bda.2010.2015)

#Removing rows with -999 values 
bda.2010.2015.clean <- bda.2010.2015 %>% 
  filter(SST_C != -999) 

#Raw temp plot
raw.2010.2015 <- ggplot(bda.2010.2015.clean, aes(x=Date, y = SST_C, group = Reef, color = Reef)) +
  geom_line() +
  scale_color_manual(values=c("tomato3", "dodgerblue3")) +
  scale_x_date(date_breaks = "1 year", date_labels= "%Y") +
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),
                     axis.text.x=element_text())






##### 2017-2018 field temps #####
#Import data 
Crescent <- read.csv("data/2018/Field_Temp/Crescent_Reef_Aug2017_Jul2018.csv")
Hog <- read.csv("data/2018/Field_Temp/Hog_Reef_Aug2018_Jul2018.csv")

#Adding Reef Column
Crescent$Reef <- "Patch"
Hog$Reef <- "Rim"

#Binding datasets together
temp.all <- rbind(Crescent, Hog)
temp.all$Date <- as.Date(temp.all$Date, "%m/%d/%Y")
temp.all <- na.omit(temp.all)
temp.subset <- temp.all %>% # removing extra rim datapoints 
  filter(Date < "2018-06-10")

raw.2017.2018 <- ggplot(temp.subset, aes(x=Date, y = SST_C, group = Reef, color = Reef)) +
  geom_point() + 
                    geom_line() +
  ylab("Temperature °C")+
                    scale_color_manual(values=c("tomato3", "dodgerblue3")) +
                    scale_x_date(date_breaks = "2 month", date_labels= "%b %Y") +
  scale_y_continuous(limits = c(17, 32), breaks = seq(17, 32, by = 2)) +
  theme_bw() + theme(panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(),
                     panel.background = element_rect(colour = "black", size=1)) +
  theme(axis.text = element_text(size = 30, color = "black"),
        axis.title = element_text(size = 36, color = "black"),
        axis.title.x = element_blank()) +
  theme(legend.position = "none")

ggsave(file = "output/Graphs/2017.2018.temp.pdf", raw.2017.2018, width = 20, height = 11, units = c("in"))


# Mean by Date and reef
mean.temps <- summarySE(temp.all, measurevar="SST_C", groupvars=c("Date", "Reef"))
mean.temps.corrected <- na.omit(mean.temps) 

ggplot(mean.temps.corrected, aes(x=Date, y = SST_C, group = Reef, color = Reef)) + 
  geom_point() + 
  geom_line() +
  geom_ribbon(aes(ymin=(mean.temps.corrected$SST_C - mean.temps.corrected$ci), ymax=(mean.temps.corrected$SST_C + mean.temps.corrected$ci)), linetype=2, alpha=0.1) +
  scale_x_date(date_breaks = "1 month", date_labels= "%b %Y") +
  scale_shape_manual(values=c(21,24),
                     name = "Reef")+
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
  theme(axis.text.x=element_text(angle=60, hjust=1)) 

#Lolipop graph 

mean.temps.patch <- summarySE(Crescent, measurevar="SST_C", groupvars=c("Date", "Reef"))
mean.temps.patch <-na.omit(mean.temps.patch) 
mean.temps.rim <- summarySE(Hog, measurevar="SST_C", groupvars=c("Date", "Reef"))
mean.temps.patch$Date <- as.Date(mean.temps.patch$Date, "%m/%d/%Y")
mean.temps.rim$Date <- as.Date(mean.temps.rim$Date, "%m/%d/%Y")

merge.temps <- merge(mean.temps.patch, mean.temps.rim, by = "Date")
merge.temps$mean.difference <- merge.temps$SST_C.x - merge.temps$SST_C.y

ggplot(merge.temps, aes(x=Date, y=mean.difference)) +
  geom_segment( aes(x=Date, xend=Date, y=0, yend=mean.difference), color="grey") +
  geom_point( color="orange", size=4) +
  theme_light() +
  theme(
    panel.grid.major.x = element_blank(),
    panel.border = element_blank(),
    axis.ticks.x = element_blank()
  ) +
  xlab("") +
  ylab("Mean Temperature Difference")


# Daily tempertaure range --> variability 
Daily.range <- summaryBy(SST_C ~ Date + Reef, data=temp.all, FUN=c(max,min,mean,sd))

Daily.range$range <- Daily.range$SST_C.max - Daily.range$SST_C.min
Daily.range.edit <- Daily.range[3:635,] #removing unmatched data points between rim and patch

Daily_range_density <- ggplot(data=Daily.range.edit, aes(x=range, group=Reef, fill=Reef)) +
  geom_density(adjust=1.5, alpha=.4) 

Daily_range_2 <- ggplot(data=Daily.range.edit, aes(x=range, group=Reef, fill=Reef, color = Reef)) +
  geom_histogram(binwidth=.05, alpha = 0.5, position="identity", color = "black") +
  scale_fill_manual(values=c("tomato3", "dodgerblue3")) +
#  xlim(17,30) + 
  theme_classic() +
  theme(legend.position="top")


range.2017.2018 <- ggplot(Daily.range.edit, aes(x=Date, y = range, group = Reef, color = Reef)) +
  geom_line() +
  scale_color_manual(values=c("tomato3", "dodgerblue3")) +
  scale_x_date(date_breaks = "1 month", date_labels= "%b %Y") +
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"),
                     axis.text.x=element_text(angle=60, hjust=1))


# mean Daily temperature categories 

which.max(density(Daily.range.edit$waiting)$y)


Daily_mean_density <- ggplot(data=Daily.range.edit, aes(x=SST_C.mean, group=Reef, fill=Reef)) +
  geom_density(adjust=1.5, alpha=.4) + 
  scale_fill_manual(values=c("tomato3", "dodgerblue3")) +
  xlim(13,34) + 
  theme_classic() +
  theme(legend.position="top")

# mean Daily temperature categories 
Daily_mean_hist1 <- ggplot(data=Daily.range.edit, aes(x=SST_C.mean, group=Reef, fill=Reef, color = Reef)) +
  geom_histogram(binwidth=.5, alpha = 0.5, position="identity", color = "black") +
  scale_fill_manual(values=c("tomato3", "dodgerblue3")) +
  xlim(17,30) + 
  theme_classic() +
  theme(legend.position="top")

Daily_mean_hist3 <- ggplot(data=Daily.range.edit, aes(x=SST_C.mean, group=Reef, fill=Reef, color = Reef)) +
  geom_freqpoly(binwidth=.5, alpha = 0.5, position="identity") +
  scale_color_manual(values=c("tomato3", "dodgerblue3")) +
  xlim(17,30) + 
  theme_classic() +
  theme(legend.position="top")

Daily_mean_hist2 <- ggplot(data=Daily.range.edit, aes(x=SST_C.mean, group=Reef, fill=Reef, color = Reef)) +
  geom_histogram(binwidth=.5, position="identity", color = "black") +
  scale_fill_manual(values=c("tomato3", "dodgerblue3")) +
  xlim(17,30) + 
  theme_classic() +
  theme(legend.position="top")


##### 2011-2013 Temp and light #####

#Import data
BDA.2011.2013 <- read.csv("data/2018/Field_Temp/BDA_2011-2013_TempLight.csv") 

#Changing date format 
BDA.2011.2013$Date <- as.Date(BDA.2011.2013$Date, "%m/%d/%Y")

#Removing rows with -999 values 
BDA.2011.2013.clean <- BDA.2011.2013 %>% 
  filter(Temp != -9999) %>%
  filter(Light != -9999) %>%
  filter(Temp < 32)  %>%
  filter(Date < "2012-09-05") %>%
  filter(Date > " 2010-10-18")

# Mean Temp by date
mean.temps.2011.2013 <- summarySE(BDA.2011.2013.clean, measurevar="Temp", groupvars=c("Date","Site"))
mean.temps.2011.2013.select <- mean.temps.2011.2013 %>%
  filter(Date < "2012-09-05") %>%
  filter(Date > " 2010-10-18")

Mean.temp.20112013.plot <- ggplot(mean.temps.2011.2013.select, aes(x=Date, y = Temp, group = Site, color = Site)) + 
                            geom_point() + 
                            geom_line() +
#                            geom_ribbon(aes(ymin=(Temp - ci), ymax=(Temp + ci)), linetype=2, alpha=0.1) +
                            ylab("Temperature °C")+
                            scale_x_date(date_breaks = "3 month", date_labels= "%b %Y") +
                            scale_y_continuous(limits = c(17, 32), breaks = seq(17, 32, by = 2)) +
                            scale_shape_manual(values=c(21,24),
                                               name = "Site")+
                            scale_color_manual(values=c("tomato3", "dodgerblue3")) +
  theme_bw() + theme(panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(),
                     panel.background = element_rect(colour = "black", size=1)) +
  theme(axis.text = element_text(size = 30, color = "black"),
        axis.title = element_text(size = 36, color = "black"),
        axis.title.x = element_blank()) +
  theme(legend.position = "none")

ggsave(file = "output/Graphs/2010.2012.temp.pdf", Mean.temp.20112013.plot, width = 20, height = 11, units = c("in"))


                          
# Mean light by date
mean.light.2011.2013 <- summarySE(BDA.2011.2013.clean, measurevar="Light", groupvars=c("Date", "Site"))

Mean.light.20112013.plot <- ggplot(mean.light.2011.2013, aes(x=Date, y = Light, group = Site, color = Site)) + 
  geom_point() + 
  geom_line() +
#  geom_ribbon(aes(ymin=(mean.temps.2011.2013$Temp - mean.temps.2011.2013$ci), ymax=(mean.temps.2011.2013$Temp + mean.temps.2011.2013$ci)), linetype=2, alpha=0.1) +
  scale_x_date(date_breaks = "1 month", date_labels= "%b %Y") +
  scale_shape_manual(values=c(21,24),
                     name = "Site")+
  theme_bw() + theme(panel.border = element_blank(), panel.grid.major = element_blank(),
                     panel.grid.minor = element_blank(), axis.line = element_line(colour = "black"))+
  theme(axis.text.x=element_text(angle=60, hjust=1)) 


# Summary statistics 
library(doBy)
temp.summary<- summaryBy(Temp ~ Site, data = BDA.2011.2013.clean,
          FUN = function(x) { c(max = max(x), min = min(x)) } )
temp.summary$Temp.seasonal <- temp.summary$Temp.max - temp.summary$Temp.min

# Daily Range
Daily.range <- summaryBy(Temp ~ Date + Site, data=BDA.2011.2013.clean, FUN=c(max,min,mean,sd))

Daily.range$temp.daily.range <- Daily.range$Temp.max - Daily.range$Temp.min

temp.d.range <- summaryBy(temp.daily.range ~ Site, data = Daily.range,
                          FUN = function(x) { c(mean = mean(x)) } )

temp.d.30 <- summaryBy(Temp.max ~ Site, data = Daily.range,
                          FUN = function(x) { c(d.above.30 = count(x>30)) } )
Temp.days.30 <- c(70, 4)

light.summary<- summaryBy(Light ~ Site, data = BDA.2011.2013.clean,
                         FUN = function(x) { c(m = mean(x), var = sd(x), max = max(x)) } )

temp.summary2 <- merge(temp.summary, temp.d.range, by = "Site")
temp.summary3 <- data.frame(temp.summary2, Temp.days.30)

temp.light.summary <- merge(temp.summary3, light.summary, by = "Site")
temp.light.summary2 <- temp.light.summary[c(2:9)]

fn <- function(x) x * 100/max(x, na.rm = TRUE)
fn(c(0,1,0))

## to all columns of your data frame
rad.data <- data.frame(lapply(temp.light.summary2, fn))
rownames(rad.data) <- c("Patch", "Rim")
colnames(rad.data) <- c("Maximum Temperature", "Minimum Temperature", "Mean Seasonal Temperature Range", "Mean Daily Temperature Range", "Days above 30°C", "Mean Seasonal Light Level", "Light Variability", "Maximum Light Level")
rad.data <- rad.data[,c(1,2,5,4,3,6,7,8)]

# To use the fmsb package, I have to add 2 lines to the dataframe: the max and min of each variable to show on the plot!
rad.data <- rbind(rep(100,5) , rep(0,5) , rad.data)

# Color vector
colors_border=c("tomato3", "dodgerblue3")
colors_in=c("tomato3", "dodgerblue3")

# Color vector
colors_border=c( rgb(0.9,0,0,0.9), rgb(0,0,0.9,0.9) )
colors_in=c( rgb(0.9,0,0,0.4), rgb(0,0,0.9,0.4))

library(fmsb)
# plot with default options:
radarchart(rad.data, axistype=1 , 
            #custom polygon
            pcol=colors_border , pfcol=colors_in , plwd=4 , plty=1,
            #custom the grid
            cglcol="grey", cglty=1, axislabcol="grey", caxislabels=seq(0,100,25), cglwd=0.8,
            #custom labels
            vlcex=0.9
)

# Add a legend
legend(x=0.9, y=0.9, legend = rownames(rad.data[-c(1,2),]), bty = "n", pch=20 , col=colors_border , text.col = "black", cex=1.2, pt.cex=3)





###### EXPERIMENTAL TEMPERATURE 2017 ########


#Tank 1: Patch Ambient, Tank 2: Rim Ambient, Tank 3: Patch Hot, Tank 4: Rim HoT

### Data Manipulation

#load data (Acclimation)
PA <-read.csv('data/2017/Tank.Measurements/Logger/PA-705.csv', header=T, sep=",")
PB <-read.csv('data/2017/Tank.Measurements/Logger/RB-705.csv', header=T, sep=",")
RA <-read.csv('data/2017/Tank.Measurements/Logger/RA-705.csv', header=T, sep=",")
RB <-read.csv('data/2017/Tank.Measurements/Logger/RB-705.csv', header=T, sep=",")

PA$Tank <- rep(1,nrow(PA)) #adding a row with corresponding tank number
PB$Tank <- rep(1,nrow(PB))
RA$Tank <- rep(2,nrow(RA))
RB$Tank <- rep(2,nrow(RB))

PA$Treatment <- rep("Ambient",nrow(PA)) #adding a column with corresponding tank treatment
PB$Treatment <- rep("Ambient",nrow(PB))
RA$Treatment <- rep("Ambient",nrow(RA))
RB$Treatment <- rep("Ambient",nrow(RB))

# load data (Treatment JUL 5-11)
T1A <-read.csv('data/2017/Tank.Measurements/Logger/T1A-711.csv', header=T, sep=",")
T1B <-read.csv('data/2017/Tank.Measurements/Logger/T1B-711.csv', header=T, sep=",")
T2A <-read.csv('data/2017/Tank.Measurements/Logger/T2A-711.csv', header=T, sep=",")
T2B <-read.csv('data/2017/Tank.Measurements/Logger/T2B-711.csv', header=T, sep=",")
T3A <-read.csv('data/2017/Tank.Measurements/Logger/T3A-711.csv', header=T, sep=",")
T3B <-read.csv('data/2017/Tank.Measurements/Logger/T3B-711.csv', header=T, sep=",")
T4A <-read.csv('data/2017/Tank.Measurements/Logger/T4A-711.csv', header=T, sep=",")
T4B <-read.csv('data/2017/Tank.Measurements/Logger/T4B-711.csv', header=T, sep=",")

T1A$Tank <- rep(1,nrow(T1A)) #adding a coumn with corresponding tank number
T1B$Tank <- rep(1,nrow(T1B))
T2A$Tank <- rep(2,nrow(T2A))
T2B$Tank <- rep(2,nrow(T2B))
T3A$Tank <- rep(3,nrow(T3A))
T3B$Tank <- rep(3,nrow(T3B))
T4A$Tank <- rep(4,nrow(T4A))
T4B$Tank <- rep(4,nrow(T4B))

T1A$Treatment <- rep("Ambient",nrow(T1A)) #adding a column with corresponding tank treatment
T1B$Treatment <- rep("Ambient",nrow(T1B))
T2A$Treatment <- rep("Ambient",nrow(T2A))
T2B$Treatment <- rep("Ambient",nrow(T2B))
T3A$Treatment <- rep("Heated",nrow(T3A))
T3B$Treatment <- rep("Heated",nrow(T3B))
T4A$Treatment <- rep("Heated",nrow(T4A))
T4B$Treatment <- rep("Heated",nrow(T4B))

# load data (Treatment JUL 12-30)
Log_data_Treat<-read.csv('data/2017/Tank.Measurements/Logger/Logger_Data_Sum_2.csv', header=T, sep=",")

T1C <- Log_data_Treat %>% 
  filter(Tank == "1")

T2C <- Log_data_Treat %>% 
  filter(Tank == "2")

T3C <- Log_data_Treat %>% 
  filter(Tank == "3")

T4C <- Log_data_Treat %>% 
  filter(Tank == "4")

T1C$Treatment <- rep("Ambient",nrow(T1C)) #adding a column with corresponding tank treatment
T2C$Treatment <- rep("Ambient",nrow(T2C))
T3C$Treatment <- rep("Heated",nrow(T3C))
T4C$Treatment <- rep("Heated",nrow(T4C))

Log_data <- rbind(PA, PB, RA, RB, T1A, T1B, T2A, T2B, T3A, T3B, T4A, T4B, T1C, T2C, T3C, T4C) #Binding all data sets together

#date modification
Log_data$Date <- as.Date(Log_data$Date, format= "%d-%b-%Y")

Log_data$date.time<- paste(Log_data$Date, Log_data$Time, sep=" ") #combining date and time columns together

Log_data$Tank<- as.factor(Log_data$Tank) #Converting tank number from a numeric to a variable factor

#Temperature Data avg per day
Log_data_sum <- summarySE(Log_data, measurevar="Temp", groupvars=c("Date","Treatment")) #Summarizing by date and tank

tank.treat.time <- ggplot(Log_data_sum,aes(x=Date, y=Temp, colour=Treatment))+
#  geom_errorbar(aes(ymin=Temp-se, ymax=Temp+se), width=.1, colour="black") +
  ylab("Temperature °C")+
  scale_x_date(date_labels="%b %d",date_breaks  ="5 day") + #modifies how many dates are shown on the x axis
  scale_y_continuous(limits = c(28, 32), breaks = seq(28, 32, by = 1)) +
#  geom_point(size = 12)+
  geom_line(aes(group=Treatment), size = 3)+
  geom_ribbon(aes(ymin=(Temp - ci), ymax=(Temp + ci)), linetype=2, alpha=0.1) +
  scale_fill_manual(values=c("#FFFFFF", "#999999"),
                    name = "Treatment")+ #colour modification
  scale_color_manual(values=c("black", "#999999"),
                     name = "Treatment")+
  theme_bw() + theme(panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(),
                     panel.background = element_rect(colour = "black", size=1)) +
  theme(axis.text = element_text(size = 30, color = "black"),
        axis.title = element_text(size = 36, color = "black"),
        axis.title.x = element_blank()) +
  theme(legend.position = "none")


ggsave(file = "output/Graphs/Treatment.Time.temp.pdf", tank.treat.time, width = 15, height = 11, units = c("in"))



#Totals
treatment.box <- ggplot(Log_data, aes(x=Treatment, y=Temp, fill = Treatment))+ #boxplot of all data
  geom_boxplot() +
  ylab("Temperature °C")+
  scale_y_continuous(limits = c(27, 34), breaks = seq(27, 34, by = 1)) +
  scale_fill_manual(values=c("#FFFFFF", "#999999"),
                    name = "Treatment")+ #colour modification
  theme_bw() + theme(panel.grid.major = element_blank(), 
                     panel.grid.minor = element_blank(),
                     panel.background = element_rect(colour = "black", size=1)) +
  theme(axis.text = element_text(size = 30, color = "black"),
        axis.title = element_text(size = 36, color = "black"),
        axis.title.x = element_blank()) +
  theme(legend.position = "none")

ggsave(file = "output/Graphs/Treatment.box.temp.pdf", treatment.box, width = 11, height = 11, units = c("in"))


#Tank Stats
#Testing Assumptions
#Normality  
hist(Log_data$Temp)

logtemp<-log(Log_data$Temp)
hist(logtemp)

#Homogeneity of Variance
library(car)
leveneTest(Log_data$Temp~Log_data$Tank)
leveneTest(logtemp~Log_data$Tank)

#Nonparametric stats
kruskal.test(Temp~Tank, data=Log_data)
library(PMCMR)
posthoc.kruskal.nemenyi.test(Temp~Tank, data=Log_data,dist = "Tukey")


