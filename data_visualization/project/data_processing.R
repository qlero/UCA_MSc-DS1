setwd("D:/repositories/UCA_MSc-DS1/data_visualization/project")
library(readr)

sankey_var_albums <- c('_id', "id_artist", "genre", "publicationDate", "title")
sankey_var_artists <- c('_id', "nameVariations_fold")

choro_var_albums <- c("id_artist", "genre", "dateRelease")
choro_var_artists <- c('_id',"location.country", "members.XX.ended", 
                       "members.XX.begin", "members.XX.end")

albums <- read_csv("wasabi_albums.csv")
albums_lite_sankey <- albums %>% select(sankey_var_albums)
albums_lite_choro <- albums %>% select(choro_var_albums)
rm(albums)

artists <- read_csv("wasabi_artists.csv")
artists_lite_sankey <- artists %>% select(sankey_var_artists)
artists_lite_choro <- artists %>% select(choro_var_artists)
rm(artists)

