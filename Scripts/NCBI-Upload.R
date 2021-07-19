## NCBI Upload 

library(readr)
library(plyr)
library(tidyr)
library(dplyr)
library(lubridate)

all.data <- read_csv("Environmental_data/Master_Fragment.csv") %>%
  filter(ANALYSIS == "Molecular" | ANALYSIS == "Physiology/Molecular") 
seq.id <- read_csv("16S_seq/16s-sample-ids.csv") %>% dplyr::rename(host_subject_id = "16s_ID")
all.data <- full_join(all.data, seq.id, by = "Plug_ID") %>%
  unite(NCBI_Sample_Name, Plug_ID, Treatment, sep = "_", remove = FALSE)

all.data$Project <- "HoloInt"

all.data <- all.data %>% unite(NCBI_Sample_Title, NCBI_Sample_Name, Project, sep = "_", remove = FALSE) 

ncbi <- all.data %>% select(NCBI_Sample_Name, host_subject_id, NCBI_Sample_Title, Species, Sample.Date, Site.Name) %>%
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
ncbi$host_life_stage <- "adult"
ncbi$host_tissue_sampled <- "tissue biopsy"
ncbi$isolation_source <- "seawater in experimental tanks" 
ncbi$samp_collect_device <- "sterile whirlpak"
ncbi$samp_mat_process <- "whole fragment snap frozen"
ncbi$size_frac <- "0.5 - 1 cm in any single dimension tissue biopsy"
ncbi$samp_size <- "3 - 4 cm in any single dimension tissue biopsy"

## There should be 251 samples (rows). or 252??? 
nrow(ncbi) 
## Take out 1177 -- couldn't extract and no sub fragment for this timepoint 
ncbi <- ncbi[!(ncbi$NCBI_Sample_Name=="1177_HTHC"),]
## Take out 1236 -- subbed with phys/molecular frag 
ncbi <- ncbi[!(ncbi$NCBI_Sample_Name=="1236_HTAC"),]

write_csv(path = "16S_seq/NCBI-Upload-16s.csv", ncbi)



