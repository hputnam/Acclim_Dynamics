## NCBI Upload 

library(readr)
library(plyr)
library(tidyr)
library(dplyr)
library(lubridate)

all.data <- read_csv("Environmental_data/Master_Fragment.csv") %>%
  unite(NCBI_Sample_Name, Plug_ID, Treatment, sep = "_", remove = FALSE)

all.data$Project <- "HoloInt"

all.data <- all.data %>% unite(NCBI_Sample_Title, NCBI_Sample_Name, Project, sep = "_", remove = FALSE) 

ncbi <- all.data %>% select(NCBI_Sample_Name, NCBI_Sample_Title, Species, Sample.Date, Site.Name) %>%
  mutate(Species = case_when(
    Species == "Mcapitata" ~ "Montipora capitata",
    Species == "Pacuta" ~ "Pocillopora acuta"
  )) %>% dplyr::rename(host = Species) %>% dplyr::rename(geo_loc_name = Site.Name)

#ncbi$Sample.Date <- parse_date_time(ncbi$Sample.Date, orders = c("ymd"))
ncbi$Sample.Date <- as.Date(ymd(ncbi$Sample.Date))

ncbi$env_broad_scale <- "coral reef" 
ncbi$lat_lon <- ncbi$geo_loc_name

ncbi <- ncbi %>% 
  mutate(lat_lon = case_when(
    lat_lon == "HIMB" ~ "21.436056, -157.786861",
    lat_lon == "Lilipuna.Fringe" ~ "21.429417, -157.791111",
    lat_lon == "Reef.11.13" ~ "21.450806, -157.794944",
    lat_lon == "Reef.35.36" ~ "21.473889, -157.833667",
    lat_lon == "Reef.18" ~ "21.450806, -157.811139",
    lat_lon == "Reef.42.43" ~ "21.477194, -157.826889",
  ))
  
ncbi$env_medium <- "sea water" 
ncbi$geo_loc_name <- paste("Hawaii:", ncbi$geo_loc_name, sep=" ")
ncbi$env_local_scale <- "fringing reef"
ncbi$organism <- "metagenome"

write_csv(path = "Environmental_data/NCBI-Upload.csv", ncbi)

## Decide on organism vs. host columns 

