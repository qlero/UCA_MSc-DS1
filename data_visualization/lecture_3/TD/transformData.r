setwd("~/Documents/lecturer")

library(tidyverse)

library(readxl)

region_names <- read_csv("data/regions.csv") %>% rename(region_name = name) 
region_ref <- read_csv("data/departments.csv") %>% 
  left_join(region_names, by = c("region_code"="code")) %>% 
  select(region_code, region_name, code)

for (i in 1:2) {
  data <- read_xls(paste0('data/Presidentielle_2017_Resultats_Tour_', i, '_c.xls'), sheet = 3, skip = 2) %>% # sheet 2 contains results per region
    rename(dept_code = `Code du département`,
           dept_name = `Libellé du département`,
           registered_voters = Inscrits,
           absent_voters = Abstentions,
           present_voters = Votants,
           blank_ballot = Blancs,
           null_ballot = Nuls,
           votes_cast = Exprimés) %>%
    select(-contains('%'), -contains('Sexe'), -contains('Prénom')) %>%
    filter(!grepl("Z", dept_code)) %>%
    mutate(dept_code = str_pad(dept_code, 2, pad = "0"))
  
  data_bis <- data %>% 
    group_by(dept_code) %>%
    gather(key, value, contains('...')) %>%
    mutate(key = sub("[...].*", "", key)) %>%
    mutate(rn = row_number()) %>% 
    ungroup() %>%
    spread(key, value) %>%
    arrange(dept_code) %>%
    rename(candidate = Nom,
           votes = Voix) %>%
    group_by(dept_code) %>%
    mutate(index = (row_number()-1) %/% 2) %>%
    group_by(dept_code, index) %>%
    summarise_all(~first(na.omit(.))) %>%
    select(-index, -rn) %>%
    spread(candidate, votes) %>%
    left_join(region_ref, by = c("dept_code"="code")) %>%
    select(region_code, region_name, everything())
  
  write_csv(data_bis, paste0('data/results_pres_elections_dept_2017_round_', i, '.csv'))
}

geo_data <- read_csv2("data/geographical_shape_regions_2016.csv") %>%
  select(insee_reg, geo_point_2d) %>%
  mutate(insee_reg = as.numeric(insee_reg)) %>%
  separate(geo_point_2d, into=c('latitude', 'longitude'), sep = ',')

write_csv(geo_data, "data/coordinates_regions_2016.csv")

regions_sf <- st_read('data/shapefile/contours-geographiques-des-regions-2019.shp') 
