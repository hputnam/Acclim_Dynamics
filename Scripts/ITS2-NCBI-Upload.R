## NCBI Upload ITS2 
rm(list=ls())

library(readr)
library(plyr)
library(tidyr)
library(dplyr)
library(lubridate)

all.data <- read_csv("Environmental_data/Master_Fragment.csv") %>%
  filter(ANALYSIS == "Molecular" | ANALYSIS == "Physiology/Molecular") 
seq.id <- read_csv("ITS2_seq/R_Input/ITS2_ids.csv") %>% dplyr::rename(host_subject_id = sample_name) %>% dplyr::rename(Plug_ID = PLUG.ID) %>%
  select(Plug_ID, host_subject_id)
all.data <- full_join(all.data, seq.id, by = "Plug_ID") %>%
  unite(NCBI_Sample_Name, Plug_ID, Treatment, sep = "_", remove = FALSE)

all.data$Project <- "HoloInt"

all.data <- all.data %>% unite(NCBI_Sample_Title, NCBI_Sample_Name, Project, sep = "_", remove = FALSE) 
all.data$NCBI_Sample_Name <- paste(all.data$NCBI_Sample_Name, "ITS2", sep="_")

write_csv(file = "ITS2_seq//NCBI-sample-title-ITS2.csv", all.data)

ncbi <- all.data %>% select(NCBI_Sample_Name, host_subject_id, NCBI_Sample_Title, Species, Sample.Date, Site.Name, Plug_ID, Timepoint, Treatment) %>%
  mutate(Species = case_when(
    Species == "Mcapitata" ~ "Montipora capitata",
    Species == "Pacuta" ~ "Pocillopora acuta"
  )) %>% dplyr::rename(host = Species) %>% dplyr::rename(geo_loc_name = Site.Name)

ncbi$Sample.Date <- as.Date(ymd(ncbi$Sample.Date))
ncbi$env_broad_scale <- "coral reef" 
ncbi$lat_lon <- ncbi$geo_loc_name

ncbi <- ncbi %>% na.omit() %>%
  mutate(lat_lon = case_when(
    lat_lon == "HIMB" ~ "21.436056, -157.786861",
    lat_lon == "Lilipuna.Fringe" ~ "21.429417, -157.791111",
    lat_lon == "Reef.11.13" ~ "21.450806, -157.794944",
    lat_lon == "Reef.35.36" ~ "21.473889, -157.833667",
    lat_lon == "Reef.18" ~ "21.450806, -157.811139",
    lat_lon == "Reef.42.43" ~ "21.477194, -157.826889",
  ))

ncbi$env_medium <- "sea water" 
ncbi$geo_loc_name <- paste("USA: Hawaii", ncbi$geo_loc_name, sep=" ")
ncbi$env_local_scale <- "fringing reef"
ncbi$organism <- "metagenome"
ncbi$host_life_stage <- "adult"
ncbi$host_tissue_sampled <- "tissue biopsy"
ncbi$isolation_source <- "seawater in experimental tanks" 
ncbi$samp_collect_device <- "sterile whirlpak"
ncbi$samp_mat_process <- "whole fragment snap frozen"
ncbi$size_frac <- "0.5 - 1 cm in any single dimension tissue biopsy"
ncbi$samp_size <- "3 - 4 cm in any single dimension tissue biopsy"

nrow(ncbi) 

ncbi$SRA_upload <- "Symbiont metagenome (ITS2 sequencing) from " 
ncbi <- ncbi %>% unite(title, SRA_upload, host, sep = "", remove = FALSE)

# create raw list of files in terminal 
# cd to the folder that contains the files then $ ls > file-names.txt
# scp **user**@bluewaves.uri.edu:/data/putnamlab/KITT/hputnam/ITS2/FULL_ITS2/file-names.txt /Users/emmastrand/MyProjects/Acclim_Dynamics/ITS2

raw.reads <- read.table("ITS2_seq/file-names.txt", sep = ",", header=TRUE) %>% dplyr::rename(seq.title = "file.names.txt") %>%
  filter(!seq.title=="SymPortal_datasheet_20200212.xlsx")
raw.reads$host_subject_id <- gsub("_.*","", raw.reads$seq.title)

# filename1 = R1 = forward 
# filename2 = R2 = reverse
raw.reads <- raw.reads %>% 
  mutate(direction = case_when(grepl("R1", seq.title) ~ "filename1",
                               grepl("R2", seq.title) ~ "filename2")) %>%
  spread(direction, seq.title)

#combing the above dataframe with the ncbi one already made 
ncbi <- full_join(ncbi, raw.reads, by = "host_subject_id") %>% na.omit()

all.data <- all.data %>% filter(!Plug_ID == "1177" & !Plug_ID == "1236") 
all.data$description <- all.data$Treatment 
all.data <- all.data %>%
  mutate(description = case_when(
    description == "HTAC" ~ "High Temperature Ambient pCO2",
    description == "HTHC" ~ "High Temperature High pCO2",
    description == "ATHC" ~ "Ambient Temperature High pCO2",
    description == "ATAC" ~ "Ambient Temperature Ambient pCO2")) #%>%
  
ncbi$description <- paste("Sampled from:", all.data$description, sep=" ")
ncbi$timepoint <- paste("at", all.data$Timepoint, sep=" ")

ncbi <- ncbi %>% unite(description, description, timepoint, sep=" ", remove=FALSE)

## SRA upload - attributes file comes from NCBI 

attributes <- read.table("ITS2_seq/attributes-NCBI-SRA-upload.tsv", sep = '\t', header = TRUE) %>% select(-message) %>% distinct() %>% select(accession, sample_name) %>%
  dplyr::rename(NCBI_Sample_Name = sample_name)

ncbi <- full_join(ncbi, attributes, by = "NCBI_Sample_Name")

write_csv(file = "ITS2_seq//NCBI-Upload-ITS2.csv", ncbi)

## in bluewaves, cd /data/putnamlab/KITT/hputnam/ITS2/FULL_ITS2
