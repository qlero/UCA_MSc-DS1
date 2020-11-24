setwd("D:/repositories/UCA_MSc-DS1/data_visualization/project")
library(readr)
library(dplyr)
library(tidyverse)

### LOADING EXTERNAL DATASETS

choro_var_albums <- c("id_artist", "genre", "publicationDate")
choro_var_artists <- c('_id',"location.country")

albums <- read_csv("wasabi_albums.csv")
albums_lite_choro <- albums %>% select(choro_var_albums)

artists <- read_csv("wasabi_artists.csv")
artists_lite_choro <- artists %>% select(choro_var_artists)

population <- read_csv("population.csv")
country_name_matcher <- read_csv("countries.csv")

# Removes superfluous data frame
rm(albums)
rm(artists)

### PRE-PROCESSING THE ALBUM DATASET

sift_df <- function(df, filter_string, name, save=FALSE) {
  new_df <- df %>% mutate(genre = tolower(genre)) %>% 
    filter(grepl(paste(filter_string, collapse="|"), genre)) %>% 
    select(genre) %>% 
    distinct(genre)
  if (save == TRUE) { write.table(new_df, file=paste(name, ".txt"), quote=F) }
  return(new_df$genre)
}

rock_lst <- c("rock")
metal_lst <- c("metal")
punk_lst <- c("punk")
country_folk_lst <- c("country", "folk", "blues", "gospel")
hip_hop_rap_lst <- c("hip","hop","pop","rap", "reggae", "americana")
jazz_lst <- c("jazz")
electro_lst <- c("electro","dubstep","drum and bass", "synth", "ebm", "tech")

rock_genres <- sift_df(albums_lite_choro, rock_lst, "rock")
metal_genres <- sift_df(albums_lite_choro, metal_lst, "metal")
punk_genres <- sift_df(albums_lite_choro, metal_lst, "metal")
country_folk_genres <- sift_df(albums_lite_choro, country_folk_lst, "countr_folk")
hihop_pop_genres <- sift_df(albums_lite_choro, hip_hop_rap_lst, "hip-hop_pop")
jazz_genres <- sift_df(albums_lite_choro, jazz_lst, "jazz")
electro_genres <- sift_df(albums_lite_choro, electro_lst, "electro")

kept_genres <- c(rock_genres, metal_genres, punk_genres, country_folk_genres, 
                 hihop_pop_genres, jazz_genres, electro_genres, electro_genres)

# 1. Drops all entries that are of a genre we are not interested in
# 2. Create a new column genre_family that contains generic genre name of the album
# 3. DSrops the genre column
# 4. Remove all instances older than 1950 and creates a column referencing the 
# decade of the album
# 5. Drops the publicationDate column 
# 6. Removes duplicates
df_album <- as_tibble(albums_lite_choro) %>% 
  filter (tolower(genre) %in% kept_genres) %>% 
  mutate(genre_family = case_when(tolower(genre)%in%rock_genres~"rock",
                                  tolower(genre)%in%metal_genres~"metal",
                                  tolower(genre)%in%punk_genres~"punk",
                                  tolower(genre)%in%country_folk_genres~"countryfolk",
                                  tolower(genre)%in%hihop_pop_genres~"hiphop",
                                  tolower(genre)%in%jazz_genres~"jazz",
                                  tolower(genre)%in%electro_genres~"electro")) %>% 
  select(-c(genre)) %>%
  filter(publicationDate >= 1960) %>% 
  mutate(decade = case_when((publicationDate>=1960 & publicationDate<1970)~1960,
                            (publicationDate>=1970 & publicationDate<1980)~1970,
                            (publicationDate>=1980 & publicationDate<1990)~1980,
                            (publicationDate>=1990 & publicationDate<2000)~1990,
                            (publicationDate>=2000)~2000)) %>%
  select(-c(publicationDate)) %>%
  distinct()

rm(albums_lite_choro)

### PRE-PROCESSING THE ARTIST DATASET

# 1. Removes duplicates
# 2. Renames the _id column to id_artists
artists_lite_choro <- as_tibble(artists_lite_choro) %>% distinct() %>%
  rename("id_artist"="_id")

### PRE-PROCESSING THE POPULATION DATASET

pop_df <- population %>% 
  mutate(decade = case_when((Year>=1960 & Year<1970)~1960,
                            (Year>=1970 & Year<1980)~1970, 
                            (Year>=1980 & Year<1990)~1980, 
                            (Year>=1990 & Year<2000)~1990, 
                            (Year>=2000)~2000)) %>% 
  select(-c("Country Code", "Year"))
pop_df <- data.frame(pop_df)
pop_df <- aggregate(pop_df, by=list(pop_df$decade,
                                    pop_df$Country.Name), FUN=mean)
pop_df <- pop_df %>% select(-c("Country.Name", "Group.1")) %>%
  rename("country"="Group.2") %>% mutate(country = tolower(country))

## CREATING THE JOINT DATA FRAME

# 1. Merges artist_lite_choro and df_album on the id_artist column
# 2. rename location.country column to country
# 3. replace NA with world
# 4. lower case all country names
joined_df <- merge(x=df_album, y=artists_lite_choro, by="id_artist") %>% 
  rename("country"="location.country") %>% mutate(country = replace_na(country, "world")) %>% 
  mutate(country = tolower(country))

joined_df <- joined_df %>% add_column(cleaned_country = NA)

for (i in 1:nrow(joined_df)) {
  for (j in 1:nrow(country_name_matcher)) {
    if (joined_df$country[i]==country_name_matcher$country_raw[j]) {
      joined_df$cleaned_country[i]=country_name_matcher$preprocessed_country[j]
    }
  }
}

joined_df <- joined_df %>% select(-c(country, id_artist)) %>% 
  rename("country"="cleaned_country")

joined_df$country[547]="czech republic"
joined_df$country[548]="czech republic"
joined_df$country[8593]="czech republic"
joined_df$country[8594]="czech republic"
joined_df$country[15816]="romania"
joined_df$country[15817]="romania"
joined_df$country[16025]="panama"
joined_df$country[20639]="poland"
joined_df$country[21793]="niger"

#joined_df[is.na(joined_df$cleaned_country),]

joined_df$count <- 1
joined_df <- joined_df %>% group_by(decade, country, genre_family) %>% 
  summarise(count = n())

joined_df <- merge(x=joined_df, y=pop_df, by=c("country","decade")) %>% 
  rename("population"="Value")

write.csv(joined_df, file="preprocessed_data.csv")

# Removes superfluous data frame
rm(df_album)
rm(artists_lite_choro)
