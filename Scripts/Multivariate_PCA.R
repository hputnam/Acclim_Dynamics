# set working directory and load necessary packages
library(vegan)
library(tidyverse)
library(reshape2)
#library(ggbiplot)
library(broom)  # devtools::install_github("tidymodels/broom")
library(cowplot)
library(ggpubr)
library(ggfortify)
library(ggrepel)
library(gridExtra)
library(ggforce)

############### 5 TP FOR CSP 

######## Mcap 

# set seed
set.seed(54321)

# import data; results physiology csv is from 'Statistics' Rmd. 
data <- read.csv("Output/results_physiology.csv") %>% #read in file
  select(-Pnet_umol.cm2.hr, -Rdark_umol.cm2.hr, -Pgross_umol.cm2.hr, -chla.ug.cm2) %>% na.omit() %>%
  filter(Timepoint=="Day 2"| Timepoint== "2 week"| Timepoint== "4 week" | Timepoint== "8 week" | Timepoint== "12 week")
data$Timepoint <- factor(data$Timepoint, levels = c("Day 2", "2 week", "4 week", "8 week", "12 week"))

cols <- c("lightblue", "red")

unique(data$Phase) # checking that all three phases are present

M.data <- data %>% filter(Species=="Mcapitata") %>% select(c(10:15))
P.data <- data %>% filter(Species=="Pacuta") %>% select(c(10:15))

#Identify Factors 
Mcap.info <- data %>% filter(Species=="Mcapitata") %>% select(c(1:9,16))
Pact.info <-  data %>% filter(Species=="Pacuta") %>% select(c(1:9,16))

#Scale and center datasets
Mcap.data.scaled <- scale(M.data, center = T, scale = T) # scaled variables
Pact.data.scaled <- scale(P.data, center = T, scale = T) # scaled variables

### Mcap
#PCA
Mcap.pca.out <- prcomp(Mcap.data.scaled, center=FALSE, scale=FALSE) #run PCA
M.summary <- summary(Mcap.pca.out); M.summary #view results
biplot(Mcap.pca.out) #plot results

# PERMANOVA
Mcap.mod <- adonis2(Mcap.data.scaled ~ Temperature * CO2 * Timepoint, data = Mcap.info, method = "euclidian"); Mcap.mod # PERMANOVA


## Biplot 
Mcap.biplot <- autoplot(Mcap.pca.out, data = Mcap.info, colour = 'Temperature', 
                       loadings = TRUE, loadings.colour = 'black', frame=TRUE, frame.type = 'norm',
                       loadings.label = TRUE, loadings.label.size = 4, loadings.label.colour = 'black', repel=TRUE,
                       loadings.label.vjust=2, loadings.label.hjust=0.1) +
  scale_color_manual(values = c("deepskyblue", "firebrick1")) + scale_fill_manual(values = c("white", "white")) +
  theme_bw() + ggtitle("Montipora capitata") + 
  theme(plot.title = element_text(face = 'bold.italic', size = 14, hjust = 0)) + 
  theme(legend.title = element_text(size=12, face="bold")) + 
  theme(legend.text = element_text(size=12)) +
  theme(legend.position = c(0.9, 0.1)) + 
  theme(legend.background = element_rect(size=0.1, linetype="solid", colour ="black")); Mcap.biplot

ggsave(file="Output/Final_Figures/CSP-PCA-Mcap.png", Mcap.biplot, width = 6, height = 5, units = c("in"))

# Mcap.pca.out %>%
#   augment(M.data) %>% # add original dataset back in
#   ggplot(aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
#   geom_point(size = 1.5) +
#   theme_half_open(12) + background_grid()+
#   stat_ellipse() +
#   facet_grid(cols=vars(Phase))+
#   xlab("PC1 48%") + ylab("PC2 18%")

Mcapitata.plot <- Mcap.pca.out %>%
  augment(Mcap.info) %>% # add original dataset back in
  ggplot(aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
  geom_point(size = 1.5, alpha=0.5) +
  theme_half_open(12) + background_grid()+
  stat_ellipse() +
  theme_classic() +
  ggtitle("Montipora capitata") + 
  facet_grid(cols=vars(Timepoint)) +
  theme(plot.title = element_text(face = 'bold.italic', size = 14, hjust = 0)) +
  theme(legend.title = element_text(size=12, face="bold"), legend.position = "none") +
  scale_color_manual(values = c("deepskyblue", "firebrick1"), aesthetics = c("colour")) +
  xlab("PC1 47%") + ylab("PC2 21%"); Mcapitata.plot 

ggsave(file="Output/Final_Figures/CSP-5TP-Mcap.png", Mcapitata.plot, width = 6, height = 5, units = c("in"))

Mcapitata.all <- Mcap.pca.out %>%
  augment(Mcap.info) %>% # add original dataset back in
  group_by(Timepoint, Temperature) %>%
  mutate(PC1.mean = mean(.fittedPC1),
         PC2.mean = mean(.fittedPC2)) %>% select(-.fittedPC4, -.fittedPC5, -.fittedPC6)
high <- Mcapitata.all %>% subset(Temperature == "High")
amb <- Mcapitata.all %>% subset(Temperature == "Ambient")

d2 <- filter(Mcapitata.all, Timepoint == "Day 2" & Temperature == "High")
w2 <- filter(Mcapitata.all, Timepoint == "2 week" & Temperature == "High")
w4 <- filter(Mcapitata.all, Timepoint == "4 week" & Temperature == "High")
w8 <- filter(Mcapitata.all, Timepoint == "8 week" & Temperature == "High")
w12 <- filter(Mcapitata.all, Timepoint == "12 week" & Temperature == "High")

### come back to finding a more elegant way to do geom segment; this will have to change after I do protein  

Mcapitata.all.fig <- ggplot(Mcapitata.all, aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
  geom_point(size = 1.5, alpha=0.3) +
  geom_point(aes(x=PC1.mean, y=PC2.mean)) +
  # geom_segment(aes(x = 1.009253, y = 0.1522638, xend = -0.3706539, yend = -0.06665108, colour = Temperature), data=high) + # Day 2 to 2 week
  # geom_segment(aes(x = -0.3706539, y = -0.06665108, xend = 0.7987893, yend = 0.2311786, colour = Temperature), data=high) + # 2 week to 4 week
  # geom_segment(aes(x = 0.7987893, y = 0.2311786, xend = -1.592824, yend = -0.281, colour = Temperature), data=high) + # 4 week to 8 week
  # geom_segment(aes(x = -1.592824, y = -0.281, xend = -0.821, yend = 0.662, colour = Temperature), data=high, arrow = arrow()) + # 8 week to 12 week
  # geom_segment(aes(x = 0.1876167, y = -0.07391899, xend = 0.5884197, yend = -0.2212294, colour = Temperature), data=amb) + # Day 2 to 2 week
  # geom_segment(aes(x = 0.5884197, y = -0.2212294, xend = 1.037685, yend = -0.09580057, colour = Temperature), data=amb) + # 2 week to 4 week
  # geom_segment(aes(x = 1.037685, y = -0.09580057, xend = -1.592824, yend = -0.002057404, colour = Temperature), data=amb) + # 4 week to 8 week
  # geom_segment(aes(x = -1.592824, y = -0.002057404, xend = -0.7918154, yend = 0.4534351, colour = Temperature), data=amb, arrow = arrow()) + # 8 week to 12 week
  geom_text(aes(PC1.mean, PC2.mean, label=Timepoint), vjust=-1.5, color="black") +
  theme_half_open(12) + background_grid() +
  ggtitle("Montipora capitata") + 
  theme(legend.position = c(0.8, 0.9)) +
  theme(plot.title = element_text(face = 'bold.italic', size = 14, hjust = 0)) +
  theme(legend.title = element_text(size=12, face="bold")) +
  scale_color_manual(values = c("deepskyblue", "firebrick1"), aesthetics = c("colour")) +
  xlab("PC1 47%") + ylab("PC2 21%"); Mcapitata.all.fig 

ggsave(file="Output/Final_Figures/CSP-all-Mcap.png", Mcapitata.all.fig, width = 6, height = 5, units = c("in"))

######## Pacuta  

#PCA
Pact.pca.out <- prcomp(Pact.data.scaled, center=FALSE, scale=FALSE) #run PCA
P.summary <- summary(Pact.pca.out); P.summary #view results
biplot(Pact.pca.out) #plot results

# PERMANOVA
Pact.mod <- adonis2(Pact.data.scaled ~ Temperature * CO2 * Timepoint, data = Pact.info, method = "euclidian"); Pact.mod # PERMANOVA

## Biplot 
Pacuta.biplot <- autoplot(Pact.pca.out, data = Pact.info, colour = 'Temperature', 
                        loadings = TRUE, loadings.colour = 'black', frame=TRUE, frame.type = 'norm',
                        loadings.label = TRUE, loadings.label.size = 4, loadings.label.colour = 'black', repel=TRUE,
                        loadings.label.vjust = 2) +
  scale_color_manual(values = c("deepskyblue", "firebrick1")) + scale_fill_manual(values = c("white", "white")) +
  theme_bw() + ggtitle("Pocillopora acuta") + 
  theme(plot.title = element_text(face = 'bold.italic', size = 14, hjust = 0)) + 
  theme(legend.title = element_text(size=12, face="bold")) + 
  theme(legend.text = element_text(size=12)) +
  theme(legend.position = c(0.9, 0.1)) + 
  theme(legend.background = element_rect(size=0.1, linetype="solid", colour ="black")); Pacuta.biplot

ggsave(file="Output/Final_Figures/CSP-PCA-Pacuta.png", Pacuta.biplot, width = 6, height = 5, units = c("in"))

Biplots <- arrangeGrob(Mcap.biplot, Pacuta.biplot, ncol = 2)
ggsave(file="Output/Final_Figures/CSP-PCAs.png", Biplots, width = 12, height = 5, units = c("in"))

# Pact.pca.out %>%
#   augment(P.data) %>% # add original dataset back in
#   ggplot(aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
#   geom_point(size = 1.5) +
#   theme_half_open(12) + background_grid()+
#   stat_ellipse() +
#   facet_grid(cols=vars(Phase))+
#   xlab("PC1 45%") + ylab("PC2 21%")

Pacuta.plot <- Pact.pca.out %>%
  augment(Pact.info) %>% # add original dataset back in
  ggplot(aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
  geom_point(size = 1.5, alpha=0.5) +
  theme_half_open(12) + background_grid()+
  stat_ellipse() +
  theme_classic() +
  ggtitle("Pocillopora acuta") + 
  facet_grid(cols=vars(Timepoint)) +
  theme(legend.position = c(0.9, 0.1)) +
  theme(plot.title = element_text(face = 'bold.italic', size = 14, hjust = 0)) +
  theme(legend.title = element_text(size=12, face="bold")) +
  scale_color_manual(values = c("deepskyblue", "firebrick1"), aesthetics = c("colour")) +
  xlab("PC1 44%") + ylab("PC2 24%"); Pacuta.plot 

ggsave(file="Output/Final_Figures/CSP-5TP-Pact.png", Pacuta.plot, width = 6, height = 5, units = c("in"))

Five.TP <- arrangeGrob(Mcapitata.plot, Pacuta.plot, ncol=2)
ggsave(file="Output/Final_Figures/CSP-5TP.png", Five.TP, width = 12, height = 6, units = c("in"))


Pact.all <- Pact.pca.out %>%
  augment(Pact.info) %>% # add original dataset back in
  group_by(Timepoint, Temperature) %>%
  mutate(PC1.mean = mean(.fittedPC1),
         PC2.mean = mean(.fittedPC2)) %>% select(-.fittedPC4, -.fittedPC5, -.fittedPC6)

high <- Pact.all %>% subset(Temperature == "High")
amb <- Pact.all %>% subset(Temperature == "Ambient")

d2<- filter(Pact.all, Timepoint == "Day 2" & Temperature == "Ambient")
w2 <- filter(Pact.all, Timepoint == "2 week" & Temperature == "Ambient")
w4 <- filter(Pact.all, Timepoint == "4 week" & Temperature == "Ambient")
w8 <- filter(Pact.all, Timepoint == "8 week" & Temperature == "Ambient")
w12 <- filter(Pact.all, Timepoint == "12 week" & Temperature == "High")
  
Pact.all.fig <- ggplot(Pact.all, aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
  geom_point(size = 1.5, alpha=0.3) +
  geom_point(aes(x=PC1.mean, y=PC2.mean)) +
  geom_segment(aes(x = -0.8570813, y = -0.7157772, xend = -1.391668, yend = 0.107712, colour = Temperature), data=amb) + # Day 2 to 2 week
  geom_segment(aes(x = -1.391668, y = 0.107712, xend = 0.07845254, yend = -0.6590729, colour = Temperature), data=amb) + # 2 week to 4 week
  geom_segment(aes(x = 0.07845254, y = -0.6590729, xend = -0.01105945, yend = -0.004638033, colour = Temperature), data=amb) + # 4 week to 8 week
  geom_segment(aes(x = -0.01105945, y = -0.004638033, xend = -0.1590089, yend = 0.5087522, colour = Temperature), data=amb, arrow = arrow()) + # 8 week to 12 week
  geom_segment(aes(x = -0.863, y = -0.127, xend = -0.1864421, yend = 0.2238403, colour = Temperature), data=high) + # Day 2 to 2 week
  geom_segment(aes(x = -0.1864421, y = 0.2238403, xend = 0.6347599, yend = -0.1661942, colour = Temperature), data=high) + # 2 week to 4 week
  geom_segment(aes(x = 0.6347599, y = -0.1661942, xend = 1.955725, yend = 0.4820474, colour = Temperature), data=high) + # 4 week to 8 week
  geom_segment(aes(x = 1.955725, y = 0.4820474, xend = 4.210992, yend = 0.9925344, colour = Temperature), data=high, arrow = arrow()) + # 8 week to 12 week
  geom_text(aes(PC1.mean, PC2.mean, label=Timepoint), vjust=-1.5, color="black") +
  theme_half_open(12) + background_grid() +
  ggtitle("Pocillopora acuta") + 
  theme(legend.position = c(0.8, 0.1)) +
  theme(plot.title = element_text(face = 'bold.italic', size = 14, hjust = 0)) +
  theme(legend.title = element_text(size=12, face="bold")) +
  scale_color_manual(values = c("deepskyblue", "firebrick1"), aesthetics = c("colour")) +
  xlab("PC1 44%") + ylab("PC2 24%"); Pact.all.fig 

ggsave(file="Output/Final_Figures/CSP-all-Pact.png", Pact.all.fig, width = 6, height = 5, units = c("in"))

All <- arrangeGrob(Mcapitata.all.fig, Pact.all.fig, ncol=2)
ggsave(file="Output/Final_Figures/CSP-all.png", All, width = 12, height = 6, units = c("in"))

############### 

################ FINAL FIGURES 

library(grid)
library(ggmap)

### PACUTA 

Pacuta.inset <- autoplot(Pact.pca.out, data = Pact.info, colour = 'Temperature', 
                       loadings = TRUE, loadings.colour = 'black', frame=TRUE, frame.type = 'norm',
                       loadings.label = TRUE, loadings.label.size = 3, loadings.label.colour = 'black', repel=TRUE,
                       loadings.label.vjust=2, loadings.label.hjust=0.1) +
  scale_color_manual(values = c("deepskyblue", "firebrick1")) + scale_fill_manual(values = alpha(c("white", "white"), .001)) +
  theme_bw() + theme(legend.position = "none"); Pacuta.inset

Pacuta.inset.final <- Pact.all.fig +
  inset(ggplotGrob(Pacuta.inset), xmin = -5.8, xmax = -1, ymin = -5.8, ymax = -2); Pacuta.inset.final

ggsave(file="Output/Final_Figures/CSP-inset-pacuta.png", Pacuta.inset.final, width = 10, height = 8, units = c("in"))


### MCAP 
# revision of Mcap.biplot

Mcap.inset <- autoplot(Mcap.pca.out, data = Mcap.info, colour = 'Temperature', 
                        loadings = TRUE, loadings.colour = 'black', frame=TRUE, frame.type = 'norm',
                        loadings.label = TRUE, loadings.label.size = 3, loadings.label.colour = 'black', repel=TRUE,
                        loadings.label.vjust=2, loadings.label.hjust=0.1) +
  scale_color_manual(values = c("deepskyblue", "firebrick1")) + scale_fill_manual(values = alpha(c("white", "white"), .001)) +
  theme_bw() + theme(legend.position = "none"); Mcap.inset

Mcap.inset.final <- Mcapitata.all.fig +
  inset(ggplotGrob(Mcap.inset), xmin = 3.2, xmax = 9, ymin = -3.1, ymax = 0); Mcap.inset.final

ggsave(file="Output/Final_Figures/CSP-inset-mcap.png", Mcap.inset.final, width = 10, height = 8, units = c("in"))

### Export both 
inset.all <- arrangeGrob(Mcap.inset.final, Pacuta.inset.final, ncol=2)
ggsave(file="Output/Final_Figures/CSP-inset-all.png", inset.all, width = 12, height = 6, units = c("in"))

################ STATISTICS 

## Pacuta - effect of treatment and timepoint

# scaled dataframe = Pact.data.scaled
# metadata = Pact.info
# PerMANOVA - partitioning the euclidean distance matrix by species
adonis(Pact.data.scaled ~ Timepoint*Temperature*CO2, data = Pact.info, method='eu')

## Mcap - effect of treatment and timepoint

# scaled dataframe = Mcap.data.scaled
# metadata = Mcap.info
# PerMANOVA - partitioning the euclidean distance matrix by species
adonis(Mcap.data.scaled ~ Timepoint*Temperature*CO2, data = Mcap.info, method='eu')



