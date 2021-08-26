### Master fragment sheets

# loading dataframes 
master <- read.csv("Environmental_data/Master_Fragment.csv") %>% select(Plug_ID)
master.all <- read.csv("Environmental_data/Master_Fragment_ALL.csv") %>% select(Plug_ID)
survivorship <- read.csv("Physiology_variables/coral_survivorship_QC.csv") %>% rename(Plug_ID = PLUG.ID) %>% select(Plug_ID)

# dplyr::setdiff(y, z)
# Rows that appear in y but not z

surv_butnot_master <- dplyr::setdiff(survivorship, master)
surv_butnot_masterall <- dplyr::setdiff(survivorship, master.all)
masterall_butnot_master <- dplyr::setdiff(master.all, master)
