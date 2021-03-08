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

# set seed
set.seed(54321)

# import data
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
  scale_color_manual(values = c("deepskyblue", "firebrick1"), aesthetics = c("colour", "fill")) +
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
         PC2.mean = mean(.fittedPC2))

Mcapitata.all.fig <- ggplot(Mcapitata.all, aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
  geom_point(size = 1.5, alpha=0.3) +
  geom_point(aes(x=PC1.mean, y=PC2.mean)) +
  geom_line(aes(x=PC1.mean, y=PC2.mean)) +
  geom_text(aes(PC1.mean, PC2.mean, label=Timepoint), vjust=-1.5, color="black") +
  theme_half_open(12) + background_grid() +
  ggtitle("Montipora capitata") + 
  theme(plot.title = element_text(face = 'bold.italic', size = 14, hjust = 0)) +
  theme(legend.title = element_text(size=12, face="bold")) +
  scale_color_manual(values = c("deepskyblue", "firebrick1"), aesthetics = c("colour")) +
  xlab("PC1 47%") + ylab("PC2 21%"); Mcapitata.all.fig 

ggsave(file="Output/Final_Figures/CSP-all-Mcap.png", Mcapitata.plot.all, width = 6, height = 5, units = c("in"))

### Pact
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
  scale_color_manual(values = c("deepskyblue", "firebrick1"), aesthetics = c("colour", "fill")) +
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
         PC2.mean = mean(.fittedPC2))
  
Pact.all.fig <- ggplot(Pact.all, aes(.fittedPC1, .fittedPC2, color = Temperature)) + 
  geom_point(size = 1.5, alpha=0.3) +
  geom_point(aes(x=PC1.mean, y=PC2.mean)) +
  geom_line(aes(x=PC1.mean, y=PC2.mean)) +
  geom_text(aes(PC1.mean, PC2.mean, label=Timepoint), vjust=-1.5, color="black") +
  theme_half_open(12) + background_grid() +
  ggtitle("Pocillopora acuta") + 
  theme(plot.title = element_text(face = 'bold.italic', size = 14, hjust = 0)) +
  theme(legend.title = element_text(size=12, face="bold")) +
  scale_color_manual(values = c("deepskyblue", "firebrick1"), aesthetics = c("colour")) +
  xlab("PC1 44%") + ylab("PC2 24%"); Pact.all.fig 

ggsave(file="Output/Final_Figures/CSP-all-Pact.png", Pact.all.fig, width = 6, height = 5, units = c("in"))

All <- arrangeGrob(Mcapitata.plot.all, Pact.all.fig, ncol=2)
ggsave(file="Output/Final_Figures/CSP-all.png", All, width = 12, height = 6, units = c("in"))


multi.page <- ggarrange(Mcapitata.plot, Pacuta.plot, Mcapitata.plot.all, Pacuta.plot.all,
                        nrow = 2, ncol = 2)

ggexport(multi.page, filename = "Output/multi.page.ggplot2.pdf")


## 4 panel figure 
## Timeseries, general PCA, bleaching score, survfit plot 


four <- arrangeGrob(Biplots, ncol=1)
ggsave(file="Output/Final_Figures/CSP-4panel.png", four, width = 12, height = 5, units = c("in"))
