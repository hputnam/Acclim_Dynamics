rm(list=ls()) #clears workspace 
Bleaching.fragments <- read.csv('~/MyProjects/Acclim_Dynamics/Physiology_variables/Bleaching_ImageJ_QC.csv', header=T, sep=",")
  Bleaching.fragments$PLUG.ID <- as.factor(Bleaching.fragments$PLUG.ID)
Coral.survivorship <- read.csv('~/MyProjects/Acclim_Dynamics/Physiology_variables/coral_survivorship.csv', header=T, sep=",")
  Coral.survivorship$PLUG.ID <- as.factor(Coral.survivorship$PLUG.ID)
Master.fragment <- read.csv('~/MyProjects/Acclim_Dynamics/Environmental_data/Master_Fragment_20200616.csv', header=T, sep=",")
  Master.fragment$PLUG.ID <- as.factor(Master.fragment$PLUG.ID)
Buoyant.weight <- read.csv('~/MyProjects/Acclim_Dynamics/Physiology_variables/Growth_Buoyant_Weight/Buoyant_Weight_QC.csv', header=T, sep=",")
  Buoyant.weight$PLUG.ID <- as.factor(Buoyant.weight$PLUG.ID)

library(dplyr)
library(tidyr)
library(stringr)

  ## Prior to R script, survivorship and master spreadsheet were directly compared

##### BLEACHING SCORE QUALITY CONTROL
#### Comparing survivorship datasheet to bleaching fragment datasheet to check if the fragments are alive when they are supposed to be
## Week 1: 20180926; Day 5
Week1_IDs <- subset(Bleaching.fragments, Timepoint=="Week1") %>% select(PLUG.ID)
Day5_IDs <- subset(Coral.survivorship, Day.5=="alive") %>% select(PLUG.ID)

# checking for duplicate Plug.IDs in Week 1's subset of Bleaching Score dataset
  wk1_occur <- data.frame(table(Week1_IDs$PLUG.ID))
  wk1_occur[wk1_occur$Freq > 1,] # prints the coral IDs that occured more than once

# rows that appear in bleaching spreadsheet (Week1_IDs) but not in survivorship as "alive" on Day 5 (Day5_IDs)
  ## dplyr::setdiff(y, z)  : rows that appear in y but not in z
# output is the corals that have a bleaching score data point but were not alive on that day 
Week1_mismatched <- setdiff(Week1_IDs, Day5_IDs) 
Week1_mismatched

## Week 2: 20181003; Day 12
Week2_IDs <- subset(Bleaching.fragments, Timepoint=="Week2") %>% select(PLUG.ID)
Day12_IDs <- subset(Coral.survivorship, Day.12=="alive") %>% select(PLUG.ID)
wk2_occur <- data.frame(table(Week2_IDs$PLUG.ID))
wk2_occur[wk2_occur$Freq > 1,] ## duplicates in blch score
Week2_mismatched <- setdiff(Week2_IDs, Day12_IDs) 
Week2_mismatched ## plug ids that appear in blch score but not as alive on that day

## Week 3: 20181011; Day 20
Week3_IDs <- subset(Bleaching.fragments, Timepoint=="Week3") %>% select(PLUG.ID)
Day20_IDs <- subset(Coral.survivorship, Day.20=="alive") %>% select(PLUG.ID)
wk3_occur <- data.frame(table(Week3_IDs$PLUG.ID))
wk3_occur[wk3_occur$Freq > 1,] ## duplicates in blch score
Week3_mismatched <- setdiff(Week3_IDs, Day20_IDs) 
Week3_mismatched ## plug ids that appear in blch score but not as alive on that day

## Week 4: 20181018; Day 27
Week4_IDs <- subset(Bleaching.fragments, Timepoint=="Week4") %>% select(PLUG.ID)
Day27_IDs <- subset(Coral.survivorship, Day.27=="alive") %>% select(PLUG.ID)
wk4_occur <- data.frame(table(Week4_IDs$PLUG.ID))
wk4_occur[wk4_occur$Freq > 1,] ## duplicates in blch score
Week4_mismatched <- setdiff(Week4_IDs, Day27_IDs) 
Week4_mismatched ## plug ids that appear in blch score but not as alive on that day

## Week 5: 20181025; Day 34
Week5_IDs <- subset(Bleaching.fragments, Timepoint=="Week5") %>% select(PLUG.ID)
Day34_IDs <- subset(Coral.survivorship, Day.34=="alive") %>% select(PLUG.ID)
wk5_occur <- data.frame(table(Week5_IDs$PLUG.ID))
wk5_occur[wk5_occur$Freq > 1,] ## duplicates in blch score
Week5_mismatched <- setdiff(Week5_IDs, Day34_IDs) 
Week5_mismatched ## plug ids that appear in blch score but not as alive on that day

## Week 6: 20181102; Day 42
Week6_IDs <- subset(Bleaching.fragments, Timepoint=="Week6") %>% select(PLUG.ID)
Day42_IDs <- subset(Coral.survivorship, Day.42=="alive") %>% select(PLUG.ID)
wk6_occur <- data.frame(table(Week6_IDs$PLUG.ID))
wk6_occur[wk6_occur$Freq > 1,] ## duplicates in blch score
Week6_mismatched <- setdiff(Week6_IDs, Day42_IDs) 
Week6_mismatched ## plug ids that appear in blch score but not as alive on that day

## Week 7: 20181109; Day 49
Week7_IDs <- subset(Bleaching.fragments, Timepoint=="Week7") %>% select(PLUG.ID)
Day49_IDs <- subset(Coral.survivorship, Day.49=="alive") %>% select(PLUG.ID)
wk7_occur <- data.frame(table(Week7_IDs$PLUG.ID))
wk7_occur[wk7_occur$Freq > 1,] ## duplicates in blch score
Week7_mismatched <- setdiff(Week7_IDs, Day49_IDs) 
Week7_mismatched ## plug ids that appear in blch score but not as alive on that day

## Week 8: 20181116; Day 56
Week8_IDs <- subset(Bleaching.fragments, Timepoint=="Week8") %>% select(PLUG.ID)
Day56_IDs <- subset(Coral.survivorship, Day.56=="alive") %>% select(PLUG.ID)
wk8_occur <- data.frame(table(Week8_IDs$PLUG.ID))
wk8_occur[wk8_occur$Freq > 1,] ## duplicates in blch score
Week8_mismatched <- setdiff(Week8_IDs, Day56_IDs) 
Week8_mismatched ## plug ids that appear in blch score but not as alive on that day

## Week 9: 20181123; Day 63
Week9_IDs <- subset(Bleaching.fragments, Timepoint=="Week9") %>% select(PLUG.ID)
Day63_IDs <- subset(Coral.survivorship, Day.63=="alive") %>% select(PLUG.ID)
wk9_occur <- data.frame(table(Week9_IDs$PLUG.ID))
wk9_occur[wk9_occur$Freq > 1,] ## duplicates in blch score
Week9_mismatched <- setdiff(Week9_IDs, Day63_IDs) 
Week9_mismatched ## plug ids that appear in blch score but not as alive on that day

## Week 10: 20181130; Day 70
Week10_IDs <- subset(Bleaching.fragments, Timepoint=="Week10") %>% select(PLUG.ID)
Day70_IDs <- subset(Coral.survivorship, Day.70=="alive") %>% select(PLUG.ID)
wk10_occur <- data.frame(table(Week10_IDs$PLUG.ID))
wk10_occur[wk10_occur$Freq > 1,] ## duplicates in blch score
Week10_mismatched <- setdiff(Week10_IDs, Day70_IDs) 
Week10_mismatched ## plug ids that appear in blch score but not as alive on that day

## Week 11: 20181207; Day 77
Week11_IDs <- subset(Bleaching.fragments, Timepoint=="Week11") %>% select(PLUG.ID)
Day77_IDs <- subset(Coral.survivorship, Day.77=="alive") %>% select(PLUG.ID)
wk11_occur <- data.frame(table(Week11_IDs$PLUG.ID))
wk11_occur[wk11_occur$Freq > 1,] ## duplicates in blch score
Week11_mismatched <- setdiff(Week11_IDs, Day77_IDs) 
Week11_mismatched ## plug ids that appear in blch score but not as alive on that day

## Week 12: 20181214; Day 84
Week12_IDs <- subset(Bleaching.fragments, Timepoint=="Week12") %>% select(PLUG.ID)
Day84_IDs <- subset(Coral.survivorship, Day.84=="alive") %>% select(PLUG.ID)
wk12_occur <- data.frame(table(Week12_IDs$PLUG.ID))
wk12_occur[wk12_occur$Freq > 1,] ## duplicates in blch score
Week12_mismatched <- setdiff(Week12_IDs, Day84_IDs) 
Week12_mismatched ## plug ids that appear in blch score but not as alive on that day

## Week 13: 20181221; Day 91
Week13_IDs <- subset(Bleaching.fragments, Timepoint=="Week13") %>% select(PLUG.ID)
Day91_IDs <- subset(Coral.survivorship, Day.91=="alive") %>% select(PLUG.ID)
wk13_occur <- data.frame(table(Week13_IDs$PLUG.ID))
wk13_occur[wk13_occur$Freq > 1,] ## duplicates in blch score
Week13_mismatched <- setdiff(Week13_IDs, Day91_IDs) 
Week13_mismatched ## plug ids that appear in blch score but not as alive on that day

## Week 14: 20181231; Day 101
Week14_IDs <- subset(Bleaching.fragments, Timepoint=="Week14") %>% select(PLUG.ID)
Day101_IDs <- subset(Coral.survivorship, Day.101=="alive") %>% select(PLUG.ID)
wk14_occur <- data.frame(table(Week14_IDs$PLUG.ID))
wk14_occur[wk14_occur$Freq > 1,] ## duplicates in blch score
Week14_mismatched <- setdiff(Week14_IDs, Day101_IDs) 
Week14_mismatched 

## Week 15: 20190107; Day 108
Week15_IDs <- subset(Bleaching.fragments, Timepoint=="Week15") %>% select(PLUG.ID)
Day108_IDs <- subset(Coral.survivorship, Day.108=="alive") %>% select(PLUG.ID)
wk15_occur <- data.frame(table(Week15_IDs$PLUG.ID))
wk15_occur[wk15_occur$Freq > 1,] ## duplicates in blch score
Week15_mismatched <- setdiff(Week15_IDs, Day108_IDs) 
Week15_mismatched 

## Week 16: 20190111; Day 112
Week16_IDs <- subset(Bleaching.fragments, Timepoint=="Week16") %>% select(PLUG.ID)
Day112_IDs <- subset(Coral.survivorship, Day.112=="alive") %>% select(PLUG.ID)
wk16_occur <- data.frame(table(Week16_IDs$PLUG.ID))
wk16_occur[wk16_occur$Freq > 1,] ## duplicates in blch score
Week16_mismatched <- setdiff(Week16_IDs, Day112_IDs) 
Week16_mismatched 

##### BUOYANT WEIGHT QUALITY CONTROL
#### Comparing survivorship datasheet to buoyant weight datasheet to check if the fragments are alive when they are supposed to be

## Time0: 20180920; Acclimation 
Time0_IDs <- subset(Buoyant.weight, TimePoint=="Time0") %>% select(PLUG.ID)
Acclim_IDs <- subset(Coral.survivorship, Acclimation.End=="alive") %>% select(PLUG.ID)
Time0_occur <- data.frame(table(Time0_IDs$PLUG.ID))
Time0_occur[Time0_occur$Freq > 1,] ## duplicates in BW
Time0_mismatched <- setdiff(Time0_IDs, Acclim_IDs)  
Time0_mismatched # output is the corals that have a buoyant weight data point but were not alive on that day 

## Time1: 20180928; Day7 
Time1_IDs <- subset(Buoyant.weight, TimePoint=="Time1") %>% select(PLUG.ID)
Day7_IDs <- subset(Coral.survivorship, Day.7=="alive") %>% select(PLUG.ID)
Time1_occur <- data.frame(table(Time1_IDs$PLUG.ID))
Time1_occur[Time1_occur$Freq > 1,] ## duplicates in BW
Time1_mismatched <- setdiff(Time1_IDs, Day7_IDs)  
Time1_mismatched # output is the corals that have a buoyant weight data point but were not alive on that day

## Time2: 20181004; Day13 
Time2_IDs <- subset(Buoyant.weight, TimePoint=="Time2") %>% select(PLUG.ID)
Day13_IDs <- subset(Coral.survivorship, Day.13=="alive") %>% select(PLUG.ID)
Time2_occur <- data.frame(table(Time2_IDs$PLUG.ID))
Time2_occur[Time2_occur$Freq > 1,] ## duplicates in BW
Time2_mismatched <- setdiff(Time2_IDs, Day13_IDs)  
Time2_mismatched 

## Time3: 20181019; Day28 
Time3_IDs <- subset(Buoyant.weight, TimePoint=="Time3") %>% select(PLUG.ID)
Day28_IDs <- subset(Coral.survivorship, Day.28=="alive") %>% select(PLUG.ID)
Time3_occur <- data.frame(table(Time3_IDs$PLUG.ID))
Time3_occur[Time3_occur$Freq > 1,] ## duplicates in BW
Time3_mismatched <- setdiff(Time3_IDs, Day28_IDs)  
Time3_mismatched 

## Time4: 20181102; Day42 
Time4_IDs <- subset(Buoyant.weight, TimePoint=="Time4") %>% select(PLUG.ID)
Day42_IDs <- subset(Coral.survivorship, Day.42=="alive") %>% select(PLUG.ID)
Time4_occur <- data.frame(table(Time4_IDs$PLUG.ID))
Time4_occur[Time4_occur$Freq > 1,] ## duplicates in BW
Time4_mismatched <- setdiff(Time4_IDs, Day42_IDs)  
Time4_mismatched 

## Time5: 20181115; Day55 
Time5_IDs <- subset(Buoyant.weight, TimePoint=="Time5") %>% select(PLUG.ID)
Day55_IDs <- subset(Coral.survivorship, Day.55=="alive") %>% select(PLUG.ID)
Time5_occur <- data.frame(table(Time5_IDs$PLUG.ID))
Time5_occur[Time5_occur$Freq > 1,] ## duplicates in BW
Time5_mismatched <- setdiff(Time5_IDs, Day55_IDs)  
Time5_mismatched 

## Time6: 20181129; Day69 
Time6_IDs <- subset(Buoyant.weight, TimePoint=="Time6") %>% select(PLUG.ID)
Day69_IDs <- subset(Coral.survivorship, Day.69=="alive") %>% select(PLUG.ID)
Time6_occur <- data.frame(table(Time6_IDs$PLUG.ID))
Time6_occur[Time6_occur$Freq > 1,] ## duplicates in BW
Time6_mismatched <- setdiff(Time6_IDs, Day69_IDs)  
Time6_mismatched 

## Time7: 20181213; Day83 
Time7_IDs <- subset(Buoyant.weight, TimePoint=="Time7") %>% select(PLUG.ID)
Day83_IDs <- subset(Coral.survivorship, Day.83=="alive") %>% select(PLUG.ID)
Time7_occur <- data.frame(table(Time7_IDs$PLUG.ID))
Time7_occur[Time7_occur$Freq > 1,] ## duplicates in BW
Time7_mismatched <- setdiff(Time7_IDs, Day83_IDs)  
Time7_mismatched 

## Time8: 20181227; Day97 
Time8_IDs <- subset(Buoyant.weight, TimePoint=="Time8") %>% select(PLUG.ID)
Day97_IDs <- subset(Coral.survivorship, Day.97=="alive") %>% select(PLUG.ID)
Time8_occur <- data.frame(table(Time8_IDs$PLUG.ID))
Time8_occur[Time8_occur$Freq > 1,] ## duplicates in BW
Time8_mismatched <- setdiff(Time8_IDs, Day97_IDs)  
Time8_mismatched 

## Time9: 20190110; Day111 
Time9_IDs <- subset(Buoyant.weight, TimePoint=="Time9") %>% select(PLUG.ID)
Day111_IDs <- subset(Coral.survivorship, Day.111=="alive") %>% select(PLUG.ID)
Time9_occur <- data.frame(table(Time9_IDs$PLUG.ID))
Time9_occur[Time9_occur$Freq > 1,] ## duplicates in BW
Time9_mismatched <- setdiff(Time9_IDs, Day111_IDs)  
Time9_mismatched 


##### PLUG ID - SPECIES QUALITY CONTROL 
#### Checking that plug.id is associated with the correct species in both Bleaching and Buoyant Weight
Master_sp <- Master.fragment %>% select(PLUG.ID, Species) %>% unite(ID_Species, PLUG.ID, Species)
  
BW_sp <- Buoyant.weight %>% select(PLUG.ID, Species) %>% unite(ID_Species, PLUG.ID, Species)

Blch_sp <- Bleaching.fragments %>% select(PLUG.ID, Species) 
  Blch_sp$Species <- gsub("Montipora","Mcapitata", Blch_sp$Species)
  Blch_sp$Species <- gsub("Pocillopora","Pacuta", Blch_sp$Species)
  Blch_sp <- Blch_sp %>% unite(ID_Species, PLUG.ID, Species)
  
## Fragments_sp pairs that appear in the BW sheet that do not in the Master fragment sheet
Master_BW_check <- setdiff(BW_sp, Master_sp) 
Master_BW_check 
  
## Fragment_sp pairs that appear in the Blch score sheet that do not in the Master fragment sheet 
# ID - species pairs printed will need to be fixed in the Blch Score sheet
Master_Blch_spcheck <- setdiff(Blch_sp, Master_sp) 
Master_Blch_spcheck 

##### PLUG ID - TREATMENT QUALITY CONTROL 
### Checking all Plug ID and treatments match on master spreadsheet, Bleaching, and BW
Master_trt <- Master.fragment %>% select(PLUG.ID, TREATMENT) %>% unite(ID_Treatment, PLUG.ID, TREATMENT)
Blch_trt <- Bleaching.fragments %>% select(PLUG.ID, Treatment) %>% unite(ID_Treatment, PLUG.ID, Treatment)
BW_trt <- Buoyant.weight %>% select(PLUG.ID, Treatment) %>% unite(ID_Treatment, PLUG.ID, Treatment)

## Fragment_trt pairs that appear in the Blch score sheet that do not in the Master fragment sheet 
# ID - treatment pairs printed will need to be fixed in the Blch Score sheet
Master_Blch_trtcheck <- setdiff(Blch_trt, Master_trt) 
Master_Blch_trtcheck 

## Fragment_trt pairs that appear in the BW sheet that do not in the Master fragment sheet 
# ID - treatment pairs printed will need to be fixed in the BW sheet
Master_BW_trtcheck <- setdiff(BW_trt, Master_trt) 
Master_BW_trtcheck 

### PLUG ID - TANK QUALITY CONTROL 
### Checking all Plug ID and treatments match on master spreadsheet, and BW
Master_tank <- Master.fragment %>% select(PLUG.ID, TANK.) %>% unite(ID_Tank, PLUG.ID, TANK.)
Survivor_tank <- Coral.survivorship %>% select(PLUG.ID, Tank) %>% unite(ID_Tank, PLUG.ID, Tank)
Blch_tank <- Bleaching.fragments %>% select(PLUG.ID, Tank) %>% unite(ID_Tank, PLUG.ID, Tank)
BW_tank <- Buoyant.weight %>% select(PLUG.ID, Tank) 
  BW_tank$Tank <- gsub("^.{0,4}", "", BW_tank$Tank)
  BW_tank <- BW_tank %>% unite(ID_Tank, PLUG.ID, Tank)
  
Master_Surv_tankcheck <- setdiff(Survivor_tank, Master_tank) 
Master_Surv_tankcheck 

Master_Blch_tankcheck <- setdiff(Blch_tank, Master_tank) 
Master_Blch_tankcheck 

Master_BW_tankcheck <- setdiff(BW_tank, Master_tank) 
Master_BW_tankcheck 





  
  