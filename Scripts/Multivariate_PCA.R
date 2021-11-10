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
data <- read.csv("Output/results_physiology.csv") %>%  #read in file
  select(-Pnet_umol.cm2.hr, -Rdark_umol.cm2.hr, -Pgross_umol.cm2.hr, -chla.ug.cm2) %>% na.omit() %>%
  filter(Timepoint=="Day 2"| Timepoint== "2 week"| Timepoint== "4 week" | Timepoint== "8 week" | Timepoint== "12 week")
data$Timepoint <- factor(data$Timepoint, levels = c("Day 2", "2 week", "4 week", "8 week", "12 week"))

cols <- c("lightblue", "red")

#unique(data$Phase) # checking that all three phases are present

M.data <- data %>% filter(Species=="Mcapitata") %>% select(c(11:16)) ## By Reef = 11:16
P.data <- data %>% filter(Species=="Pacuta") %>% select(c(11:16)) ## By Reef = 11:16

#Identify Factors 
Mcap.info <- data %>% filter(Species=="Mcapitata") %>% select(c(1:10,17))
Pact.info <-  data %>% filter(Species=="Pacuta") %>% select(c(1:10,17))

#Scale and center datasets
Mcap.data.scaled <- scale(M.data, center = T, scale = T) # scaled variables
Pact.data.scaled <- scale(P.data, center = T, scale = T) # scaled variables

### Mcap
#PCA
Mcap.pca.out <- prcomp(Mcap.data.scaled, center=FALSE, scale=FALSE) #run PCA
M.summary <- summary(Mcap.pca.out); M.summary #view results
biplot(Mcap.pca.out) #plot results


#### Plotting just by reef

## MCap 

Mcap.reef.info <- Mcap.info %>% subset(Treatment == "ATAC") 
Mcap.reef.data <- data %>% subset(Treatment == "ATAC") %>% filter(Species=="Mcapitata") %>% select(c(11:16))
M.reef.scaled <- scale(Mcap.reef.data, center = T, scale = T)
M.reef.pca.out <- prcomp(M.reef.scaled, center=FALSE, scale=FALSE)

Mcap.reef <- autoplot(M.reef.pca.out, data = Mcap.reef.info, colour = 'Site.Name', 
                        loadings = TRUE, loadings.colour = 'black', frame=TRUE, #frame.type = 'norm',
                        loadings.label = TRUE, loadings.label.size = 4, loadings.label.colour = 'black', repel=TRUE,
                        loadings.label.vjust=2, loadings.label.hjust=0.1) +
  #scale_color_manual(values = c("deepskyblue", "firebrick1")) + scale_fill_manual(values = c("white", "white")) +
  theme_bw() + ggtitle("Montipora capitata - ATAC all time points") + 
  theme(plot.title = element_text(face = 'bold.italic', size = 14, hjust = 0)) + 
  theme(legend.title = element_text(size=12, face="bold")) + 
  theme(legend.text = element_text(size=12)) +
  theme(legend.position = c(0.9, 0.1)) + 
  theme(legend.background = element_rect(size=0.1, linetype="solid", colour ="black")); Mcap.reef

## Pacuta 
Pact.reef.info <- Pact.info %>% subset(Treatment == "ATAC") 
Pact.reef.data <- data %>% subset(Treatment == "ATAC") %>% filter(Species=="Pacuta") %>% select(c(11:16))
P.reef.scaled <- scale(Pact.reef.data, center = T, scale = T)
P.reef.pca.out <- prcomp(P.reef.scaled, center=FALSE, scale=FALSE)

Pact.reef <- autoplot(P.reef.pca.out, data = Pact.reef.info, colour = 'Site.Name', 
                      loadings = TRUE, loadings.colour = 'black', frame=TRUE, #frame.type = 'norm',
                      loadings.label = TRUE, loadings.label.size = 4, loadings.label.colour = 'black', repel=TRUE,
                      loadings.label.vjust=2, loadings.label.hjust=0.1) +
  #scale_color_manual(values = c("deepskyblue", "firebrick1")) + scale_fill_manual(values = c("white", "white")) +
  theme_bw() + ggtitle("Pocillopora acuta - ATAC all time points") + 
  theme(plot.title = element_text(face = 'bold.italic', size = 14, hjust = 0)) + 
  theme(legend.title = element_text(size=12, face="bold")) + 
  theme(legend.text = element_text(size=12)) +
  theme(legend.position = "left") + 
  theme(legend.background = element_rect(size=0.1, linetype="solid", colour ="black")); Pact.reef



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

mcap.high.segments <- Mcapitata.all %>% subset(Temperature == "High") %>%
  select(Timepoint, Temperature, PC1.mean, PC2.mean) %>%
  gather(variable, value, -(Timepoint:Temperature)) %>%
  unite(group, Timepoint, variable) %>% distinct() %>%
  spread(group, value)

mcap.amb.segments <- Mcapitata.all %>% subset(Temperature == "Ambient") %>%
  select(Timepoint, Temperature, PC1.mean, PC2.mean) %>%
  gather(variable, value, -(Timepoint:Temperature)) %>%
  unite(group, Timepoint, variable) %>% distinct() %>%
  spread(group, value)

Mcapitata.all.fig <- ggplot(Mcapitata.all, aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
  geom_segment(aes(x = `Day 2_PC1.mean`, y = `Day 2_PC2.mean`, xend = `2 week_PC1.mean`, yend = `2 week_PC2.mean`, colour = Temperature), data = mcap.high.segments, size=1, show.legend=FALSE) + # Day 2 to 2 week HIGH
  geom_segment(aes(x = `2 week_PC1.mean`, y = `2 week_PC2.mean`, xend = `4 week_PC1.mean`, yend = `4 week_PC2.mean`, colour = Temperature), data = mcap.high.segments, size=1, show.legend=FALSE) + # 2 week to 4 week HIGH
  geom_segment(aes(x = `4 week_PC1.mean`, y = `4 week_PC2.mean`, xend = `8 week_PC1.mean`, yend = `8 week_PC2.mean`, colour = Temperature), data = mcap.high.segments, size=1, show.legend=FALSE) + # 4 week to 8 week HIGH
  geom_segment(aes(x = `8 week_PC1.mean`, y = `8 week_PC2.mean`, xend = `12 week_PC1.mean`, yend = `12 week_PC2.mean`, colour = Temperature), data = mcap.high.segments, size=1, show.legend=FALSE, arrow = arrow()) + # 8 week to 12 week HIGH
  geom_segment(aes(x = `Day 2_PC1.mean`, y = `Day 2_PC2.mean`, xend = `2 week_PC1.mean`, yend = `2 week_PC2.mean`, colour = Temperature), data = mcap.amb.segments, size=1, show.legend=FALSE) + # Day 2 to 2 week AMB
  geom_segment(aes(x = `2 week_PC1.mean`, y = `2 week_PC2.mean`, xend = `4 week_PC1.mean`, yend = `4 week_PC2.mean`, colour = Temperature), data = mcap.amb.segments, size=1, show.legend=FALSE) + # 2 week to 4 week AMB
  geom_segment(aes(x = `4 week_PC1.mean`, y = `4 week_PC2.mean`, xend = `8 week_PC1.mean`, yend = `8 week_PC2.mean`, colour = Temperature), data = mcap.amb.segments, size=1, show.legend=FALSE) + # 4 week to 8 week AMB
  geom_segment(aes(x = `8 week_PC1.mean`, y = `8 week_PC2.mean`, xend = `12 week_PC1.mean`, yend = `12 week_PC2.mean`, colour = Temperature), data = mcap.amb.segments, size=1, show.legend=FALSE, arrow = arrow()) + # 8 week to 12 week AMB
  geom_point(size = 1.5, alpha=0.3) +
  geom_point(aes(x=PC1.mean, y=PC2.mean)) +
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

pact.high.segments <- Pact.all %>% subset(Temperature == "High") %>%
  select(Timepoint, Temperature, PC1.mean, PC2.mean) %>%
  gather(variable, value, -(Timepoint:Temperature)) %>%
  unite(group, Timepoint, variable) %>% distinct() %>%
  spread(group, value)

pact.amb.segments <- Pact.all %>% subset(Temperature == "Ambient") %>%
  select(Timepoint, Temperature, PC1.mean, PC2.mean) %>%
  gather(variable, value, -(Timepoint:Temperature)) %>%
  unite(group, Timepoint, variable) %>% distinct() %>%
  spread(group, value)
  
Pact.all.fig <- ggplot(Pact.all, aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
  geom_point(size = 1.5, alpha=0.3) +
  geom_point(aes(x=PC1.mean, y=PC2.mean)) +
  geom_segment(aes(x = `Day 2_PC1.mean`, y = `Day 2_PC2.mean`, xend = `2 week_PC1.mean`, yend = `2 week_PC2.mean`, colour = Temperature), data = pact.high.segments, size=1, show.legend=FALSE) + # Day 2 to 2 week HIGH
  geom_segment(aes(x = `2 week_PC1.mean`, y = `2 week_PC2.mean`, xend = `4 week_PC1.mean`, yend = `4 week_PC2.mean`, colour = Temperature), data = pact.high.segments, size=1, show.legend=FALSE) + # 2 week to 4 week HIGH
  geom_segment(aes(x = `4 week_PC1.mean`, y = `4 week_PC2.mean`, xend = `8 week_PC1.mean`, yend = `8 week_PC2.mean`, colour = Temperature), data = pact.high.segments, size=1, show.legend=FALSE) + # 4 week to 8 week HIGH
  geom_segment(aes(x = `8 week_PC1.mean`, y = `8 week_PC2.mean`, xend = `12 week_PC1.mean`, yend = `12 week_PC2.mean`, colour = Temperature), data = pact.high.segments, size=1, show.legend=FALSE, arrow = arrow()) + # 8 week to 12 week HIGH
  geom_segment(aes(x = `Day 2_PC1.mean`, y = `Day 2_PC2.mean`, xend = `2 week_PC1.mean`, yend = `2 week_PC2.mean`, colour = Temperature), data = pact.amb.segments, size=1, show.legend=FALSE) + # Day 2 to 2 week AMB
  geom_segment(aes(x = `2 week_PC1.mean`, y = `2 week_PC2.mean`, xend = `4 week_PC1.mean`, yend = `4 week_PC2.mean`, colour = Temperature), data = pact.amb.segments, size=1, show.legend=FALSE) + # 2 week to 4 week AMB
  geom_segment(aes(x = `4 week_PC1.mean`, y = `4 week_PC2.mean`, xend = `8 week_PC1.mean`, yend = `8 week_PC2.mean`, colour = Temperature), data = pact.amb.segments, size=1, show.legend=FALSE) + # 4 week to 8 week AMB
  geom_segment(aes(x = `8 week_PC1.mean`, y = `8 week_PC2.mean`, xend = `12 week_PC1.mean`, yend = `12 week_PC2.mean`, colour = Temperature), data = pact.amb.segments, size=1, show.legend=FALSE, arrow = arrow()) + # 8 week to 12 week AMB
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



