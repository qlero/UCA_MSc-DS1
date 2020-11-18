setwd("D:/repositories/UCA_MSc-DS1/data_visualization/project")
library(readr)

albums <- read_csv("wasabi_albums.csv")
albums_lite <- albums %>% select(id_artist, genre, dateRelease)
rm(albums)

artists <- read_csv("wasabi_artists.csv")
artists_lite <- artists %>% select('_id', 
                                   location.country, 
                                   members.XX.ended, 
                                   members.XX.begin, 
                                   members.XX.end)
rm(artists)

