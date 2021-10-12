## Cellometer testing script

# Haemocytometer test count data
haemo.raw <- read_csv("Physiology_variables/cell-counts/cell-counts-testing-haemo.csv") %>% filter(Tech == "Emma Strand")
  haemo.raw$Plug_ID <- as.character(haemo.raw$Plug_ID)
cellometer.raw <- read_csv("Physiology_variables/cell-counts/cell-counts-testing-cellometer.csv") %>% filter(Tech == "Emma Strand")
  cellometer.raw$Plug_ID <- as.character(cellometer.raw$Plug_ID)

  haemo <- haemo.raw %>%
    select(Haemocytometer_Date, Homogenization, Plug_ID, Squares_Counted, matches("Count[0-9]")) %>%
    gather("rep", "count", -Haemocytometer_Date, -Homogenization, -Plug_ID, -Squares_Counted) %>% filter(!is.na(count)) %>%
    dplyr::group_by(Plug_ID, Homogenization) %>%
    mutate(count.mean = mean(count))
  
  
  ### Cellometer
  
  ```{r}
  cellometer <- cellometer.raw %>% 
    select(Homogenization, Plug_ID, matches("Cell_mL[0-2]")) %>%
    gather("rep", "count", -Homogenization, -Plug_ID) %>% filter(!is.na(count)) %>%
    dplyr::group_by(Plug_ID, Homogenization) %>%
    mutate(count.mean = mean(count))
  
  cellometer <-full_join(cellometer, metadata) %>% filter(!is.na(Species)) %>% filter(!is.na(Homogenization))
  
  cellometer <- cellometer %>% spread(rep, count) %>%
    mutate(cells.mL = count.mean,
           cells = cells.mL * vol_mL,
           cellometer.cells.cm2 = cells / surface.area.cm2) %>%
    mutate(cells1.mL = Cell_mL1,
           cells1 = cells1.mL * vol_mL,
           cellometer.cells1.cm2 = cells1 / surface.area.cm2) %>%
    mutate(cells2.mL = Cell_mL2,
           cells2 = cells2.mL * vol_mL,
           cellometer.cells2.cm2 = cells2 / surface.area.cm2)
  
  cellometer$Timepoint <- factor(cellometer$Timepoint, levels=c("Day 1","Day 2","1 week","2 week","4 week","6 week","8 week","12 week","16 week"))
  ```
  
  ## Count1 vs Count2 comparison
  
  ### Create data frame and run model
  ```{r}
  cellometer.c1c2.comparison <- cellometer %>% select(Plug_ID, Species, Cell_mL1, Cell_mL2, Homogenization)
  
  c1c2.lm <- cellometer.c1c2.comparison %>%
    group_by(Homogenization, Species) %>%
    nest() %>% # nest to do this for each group (Species, Period) defined above 
    mutate(Mod = map(data, ~lm(Cell_mL1 ~ Cell_mL2, data = .x))) %>% # Fit linear model
    mutate(R2 = map_dbl(Mod, ~round(summary(.x)$r.squared, 3))) %>%   # Get the R2
    unnest(cols = c(data)) # unnest to plot below
  
  c1c2 <- cellometer.c1c2.comparison %>%
    ggplot(aes(x=Cell_mL1, y=Cell_mL2, group = Homogenization, color = Homogenization)) + 
    geom_jitter(width = 0.1) + 
    facet_grid(Species ~ Homogenization) +
    labs(color='Period') + 
    theme_classic() +
    ylim(0, 1500000) + 
    xlim(0, 1500000) + 
    geom_abline(slope=1) + 
    geom_label(data = c1c2.lm, 
               aes(x = Inf, y = Inf, 
                   label = paste("R2 = ", R2, sep = " ")),
               hjust = 1, vjust = 1); c1c2
  
  ggsave(file="Physiology_variables/cell-counts/Cellometer-c1c2.png", c1c2, width = 11, height = 6, units = c("in"))
  ```
  
  
  ### Creating large dataframe.
  
  ```{r}
  cellometer.comparison <- cellometer %>%
    select(Homogenization, Plug_ID, cellometer.cells.cm2, Species, cellometer.cells1.cm2, cellometer.cells2.cm2) 
  haemo.comparison <- haemo %>% select(Homogenization, Plug_ID, haemo.cells.cm2)
  
  ## come back to 1048 -- this is full joining both of these 
  method.comparison <- full_join(cellometer.comparison, haemo.comparison, join_by = "Plug_ID") %>% 
    filter(!is.na(Species)) %>%
    summarise_each(funs(first(na.omit(.)))) # combining rows that have the same data (plug ids with cellometer and haemcy but originally on two different rows)
  
  mcap.comparison.samples <- method.comparison %>% subset(Species == "Mcapitata" & Homogenization == "1min") %>% na.omit()
  nrow(mcap.comparison.samples)
  
  pacuta.comparison.samples <- method.comparison %>% subset(Species == "Pacuta" & Homogenization == "1min") %>% na.omit()
  nrow(pacuta.comparison.samples)
  ```
  
  ### Creating models for regression between cellometer and haemocytometer.
  
  ```{r}
  methods.lm.mean <- method.comparison %>%
    group_by(Species, Homogenization) %>%
    nest() %>% # nest to do this for each group (Species, Homogenization) defined above 
    mutate(Mod = map(data, ~lm(cellometer.cells.cm2 ~ haemo.cells.cm2, data = .x))) %>% # Fit linear model
    mutate(R2 = map_dbl(Mod, ~round(summary(.x)$r.squared, 3))) %>%   # Get the R2
    unnest(cols = c(data)) # unnest to plot below 
  
  methods.lm.count1 <- method.comparison %>%
    group_by(Species, Homogenization) %>%
    nest() %>% # nest to do this for each group (Species, Homogenization) defined above 
    mutate(Mod = map(data, ~lm(cellometer.cells1.cm2 ~ haemo.cells.cm2, data = .x))) %>% # Fit linear model
    mutate(R2 = map_dbl(Mod, ~round(summary(.x)$r.squared, 3))) %>%   # Get the R2
    unnest(cols = c(data)) # unnest to plot below 
  
  methods.lm.count2 <- method.comparison %>%
    group_by(Species, Homogenization) %>%
    nest() %>% # nest to do this for each group (Species, Homogenization) defined above 
    mutate(Mod = map(data, ~lm(cellometer.cells2.cm2 ~ haemo.cells.cm2, data = .x))) %>% # Fit linear model
    mutate(R2 = map_dbl(Mod, ~round(summary(.x)$r.squared, 3))) %>%   # Get the R2
    unnest(cols = c(data)) # unnest to plot below 
  ```
  
  ### Plotting regressions for methods comparison. 
  
  ```{r}
  methods.mean <- method.comparison %>%
    ggplot(aes(x=cellometer.cells.cm2, y=haemo.cells.cm2, group = Homogenization, color = Homogenization)) + 
    geom_jitter(width = 0.1) + 
    facet_grid(Species ~ Homogenization) +
    labs(color='Homogenization') +
    theme_classic() + 
    ylim(0, 3000000) + 
    xlim(0, 3000000) +
    ggtitle("Mean cellometer value") +
    geom_abline(slope=1) +
    geom_label(data = methods.lm.mean, 
               aes(x = Inf, y = Inf, 
                   label = paste("R2 = ", R2, sep = " ")),
               hjust = 1, vjust = 1); methods.mean
  
  methods.count1 <- method.comparison %>%
    ggplot(aes(x=cellometer.cells1.cm2, y=haemo.cells.cm2, group = Homogenization, color = Homogenization)) + 
    geom_jitter(width = 0.1) + 
    facet_grid(Species ~ Homogenization) +
    labs(color='Homogenization') +
    theme_classic() + 
    ylim(0, 3000000) + 
    xlim(0, 3000000) +
    ggtitle("Count1 cellometer value") +
    geom_abline(slope=1) +
    geom_label(data = methods.lm.count1, 
               aes(x = Inf, y = Inf, 
                   label = paste("R2 = ", R2, sep = " ")),
               hjust = 1, vjust = 1); methods.count1
  
  methods.count2 <- method.comparison %>%
    ggplot(aes(x=cellometer.cells2.cm2, y=haemo.cells.cm2, group = Homogenization, color = Homogenization)) + 
    geom_jitter(width = 0.1) + 
    facet_grid(Species ~ Homogenization) +
    labs(color='Homogenization') +
    theme_classic() + 
    ylim(0, 3000000) + 
    xlim(0, 3000000) +
    ggtitle("Count2 cellometer value") +
    geom_abline(slope=1) +
    geom_label(data = methods.lm.count2, 
               aes(x = Inf, y = Inf, 
                   label = paste("R2 = ", R2, sep = " ")),
               hjust = 1, vjust = 1); methods.count2
  
  ggsave(file="Output/Cellometer-methodscompare-mean.png", methods.mean, width = 11, height = 6, units = c("in"))
  ```