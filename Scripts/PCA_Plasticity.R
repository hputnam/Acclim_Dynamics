# set working directory and load necessary packages
library(vegan)
library(tidyverse)
library(reshape2)
#library(ggbiplot)
library(broom)  # devtools::install_github("tidymodels/broom")
library(cowplot)
library(ggpubr)

# set seed
set.seed(54321)

# import data
data <- read.csv("Output/results_physiology.csv") #read in file
data <- data[ ,-c(10:12)]
data <- na.omit(data)
unique(data$Phase)
M.data <- data %>% filter(Species=="Mcapitata")
P.data <- data %>% filter(Species=="Pacuta")
Mcap.data <- M.data[,c(10:16)]
Pact.data <- P.data[,c(10:16)]

#Identify Factors 
Mcap.info <- M.data[,c(1:9,17)]
Pact.info <- P.data[,c(1:9,17)]

#Scale and center datasets
Mcap.data.scaled <- scale(Mcap.data, center = T, scale = T) # scaled variables
Pact.data.scaled <- scale(Pact.data, center = T, scale = T) # scaled variables

### Mcap
#PCA
Mcap.pca.out <- prcomp(Mcap.data.scaled, center=FALSE, scale=FALSE) #run PCA
summary(Mcap.pca.out) #view results
biplot(Mcap.pca.out) #plot results

# PERMANOVA
Mcap.mod <- adonis2(Mcap.data.scaled ~ Temperature * CO2 * Timepoint, data = Mcap.info, method = "euclidian") # PERMANOVA
Mcap.mod

Mcap.pca.out %>%
  augment(M.data) %>% # add original dataset back in
  ggplot(aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
  geom_point(size = 1.5) +
  theme_half_open(12) + background_grid()+
  stat_ellipse() +
  facet_grid(cols=vars(Phase))+
  xlab("PC1 48%") + ylab("PC2 18%")

#Set Factor order for Timepoint
M.data$Timepoint <- factor(M.data$Timepoint, levels = c("Day 1","Day 2","1 week","2 week","4 week","6 week","8 week","12 week","16 week"))

Mcapitata.plot <-Mcap.pca.out %>%
  augment(M.data) %>% # add original dataset back in
  ggplot(aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
  geom_point(size = 1.5) +
  theme_half_open(12) + background_grid()+
  stat_ellipse() +
  facet_grid(cols=vars(Timepoint))+
  xlab("PC1 45%") + ylab("PC2 21%")

### Pact
#PCA
Pact.pca.out <- prcomp(Pact.data.scaled, center=FALSE, scale=FALSE) #run PCA
summary(Pact.pca.out) #view results
biplot(Pact.pca.out) #plot results

# PERMANOVA
Pact.mod <- adonis2(Pact.data.scaled ~ Temperature * CO2 * Timepoint, data = Pact.info, method = "euclidian") # PERMANOVA
Pact.mod

Pact.pca.out %>%
  augment(P.data) %>% # add original dataset back in
  ggplot(aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
  geom_point(size = 1.5) +
  theme_half_open(12) + background_grid()+
  stat_ellipse() +
  facet_grid(cols=vars(Phase))+
  xlab("PC1 45%") + ylab("PC2 21%")

#Set Factor order for Timepoint
P.data$Timepoint <- factor(P.data$Timepoint, levels = c("Day 1","Day 2","1 week","2 week","4 week","6 week","8 week","12 week","16 week"))

Pacuta.plot <- Pact.pca.out %>%
  augment(P.data) %>% # add original dataset back in
  ggplot(aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
  geom_point(size = 1.5) +
  theme_half_open(12) + background_grid()+
  stat_ellipse() +
  facet_grid(cols=vars(Timepoint))+
  xlab("PC1 45%") + ylab("PC2 21%")


multi.page <- ggarrange(Mcapitata.plot, Pacuta.plot,
                        nrow = 2, ncol = 1)

ggexport(multi.page, filename = "Output/multi.page.ggplot2.pdf")
