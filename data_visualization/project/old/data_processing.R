setwd("D:/repositories/UCA_MSc-DS1/data_visualization/project")
library(readr)
library(dplyr)
library(tidyverse)
library(jsonlite)

### LOADING EXTERNAL DATASETS

choro_var_albums <- c("id_artist", "genre", "publicationDate")
choro_var_artists <- c('_id',"location.country")

albums <- read_csv("wasabi_albums.csv")
albums_lite_choro <- albums %>% select(choro_var_albums)

artists <- read_csv("wasabi_artists.csv")
artists_lite_choro <- artists %>% select(choro_var_artists)

population <- read_csv("population.csv")
country_name_matcher <- read_csv("countries.csv")

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

standardize_country_names <- function(df, source_df) {
  df <- df %>% add_column(cleaned_country = NA)
  for (i in 1:nrow(df)) {
    for (j in 1:nrow(source_df)) {
      if (tolower(df$country[i])==tolower(source_df$country_raw[j])) {
        df$cleaned_country[i]=source_df$preprocessed_country[j]
      }
    }
  }
  df <- df %>% select(-c(country)) %>% rename("country"="cleaned_country")
  return(df)
}

joined_df <- standardize_country_names(joined_df, country_name_matcher)
pop_df <- standardize_country_names(pop_df, country_name_matcher)

joined_df$country[547]="czechia"
joined_df$country[548]="czechia"
joined_df$country[8593]="czechia"
joined_df$country[8594]="czechia"
joined_df$country[15816]="romania"
joined_df$country[15817]="romania"
joined_df$country[16025]="panama"
joined_df$country[20639]="poland"
joined_df$country[21793]="niger"

pop_df$country[616]="north korea"
pop_df$country[617]="north korea"
pop_df$country[618]="north korea"
pop_df$country[619]="north korea"
pop_df$country[620]="north korea"

joined_df <- joined_df %>% select(-c(id_artist))

joined_df[is.na(joined_df$country),]
pop_df[is.na(pop_df$country),]

joined_df$count <- 1

joined_df <- joined_df %>% group_by(decade, country, genre_family) %>% 
  summarise(count = n())

joined_df <- merge(joined_df, pop_df, by=c("country","decade")) %>% 
  rename("population"="Value")

write.csv(joined_df, file="preprocessed_data.csv")

create_json <- function(df) {

  processed_countries <- c("start")
  nms <- c()
  entries <- list()
  
  for (country_index in 1:nrow(df)) {
    if (!is.element(df$country[country_index],
                    processed_countries)) {
      
      nms <- c(nms, df$country[country_index])
      
      processed_genres <- c("start")
      genre_names <- c()
      genre_entries <- list()
      
      for (genre_index in 1:nrow(df)) {
        if (!is.element(df$genre_family[genre_index],
                        processed_genres) &
            df$country[country_index]==df$country[genre_index]) {
          
          genre_names <- c(genre_names, df$genre_family[genre_index])
          
          processed_decades <- c("start")
          decade_names <- c()
          decade_entries <- list()

          for (decade_index in 1:nrow(df)) {
            if (df$country[country_index]==df$country[decade_index] & 
                df$genre_family[genre_index]==df$genre_family[decade_index] &
                !is.element(df$decade[decade_index], processed_decades)) {
              
              decade_names <- c(decade_names, df$decade[decade_index])
              decade_entries <- list(decade_entries, list(
                population=df$population[decade_index],
                count=df$count[decade_index]
              ))
              processed_decades <- 
                c(processed_decades, df$decade[decade_index])
              
            }
          }
          
          names(decade_entries) <- decade_names
          genre_entries <- list(genre_entries, decade_entries)
          processed_genres <- 
            c(processed_genres, df$genre_family[genre_index])
          
        }
      }
      print(genre_entries)
      names(genre_entries) <- genre_names
      entries <- list(entries, genre_entries)
      processed_countries <- 
        c(processed_countries, df$country[country_index])
      
    }
  }
  names(entries) <- nms
  return(toJSON(entries, pretty = TRUE, auto_unbox = TRUE))
}

nm <- c("andora")
entries <- list(list(rock=list(sixties=list(count=0,population=0),
                               seventies=list(count=0,population=0),
                               eighties=list(count=0,population=0),
                               nineties=list(count=0,population=0),
                               twothousands=list(count=0,population=0)),
                     metal=list(sixties=list(count=0,population=0),
                               seventies=list(count=0,population=0),
                               eighties=list(count=0,population=0),
                               nineties=list(count=0,population=0),
                               twothousands=list(count=0,population=0)),
                     punk=list(sixties=list(count=0,population=0),
                               seventies=list(count=0,population=0),
                               eighties=list(count=0,population=0),
                               nineties=list(count=0,population=0),
                               twothousands=list(count=0,population=0)),
                     country=list(sixties=list(count=0,population=0),
                               seventies=list(count=0,population=0),
                               eighties=list(count=0,population=0),
                               nineties=list(count=0,population=0),
                               twothousands=list(count=0,population=0)),
                     hip=list(sixties=list(count=0,population=0),
                               seventies=list(count=0,population=0),
                               eighties=list(count=0,population=0),
                               nineties=list(count=0,population=0),
                               twothousands=list(count=0,population=0)),
                     jazz=list(sixties=list(count=0,population=0),
                               seventies=list(count=0,population=0),
                               eighties=list(count=0,population=0),
                               nineties=list(count=0,population=0),
                               twothousands=list(count=0,population=0)),
                     electro=list(sixties=list(count=0,population=0),
                               seventies=list(count=0,population=0),
                               eighties=list(count=0,population=0),
                               nineties=list(count=0,population=0),
                               twothousands=list(count=0,population=0))
                     ))
names(entries) <- c(nm)
entries

create_json_old <- function(df){
  # Initializes the <json> list to return and a variable
  # <processed_countries> which will hold the country names already
  # processed
  json <- list()
  processed_countries <- c("start")
  # Iterates through each row, creating an index of countries
  for (country_index in 1:nrow(df)) {
    # Checks if the row's country has not yet been processed
    if (!is.element(df$country[country_index],
                    processed_countries)) {
      # Initializes an <entry> for the country's data and a variable
      # <processed_genres>  which will hold the genres already
      # processed for the country
      
      entry <- list(name=df$country[country_index])
      nms2 <- list()
      
      processed_genres <- c("start")
      # Iterates through each row, creating an index of genres
      for (genre_index in 1:nrow(df)) {
        # Checks if the genres's genres has not yet been processed
        # and if the countries match
        if (!is.element(df$genre_family[genre_index],
                        processed_genres) &
            df$country[country_index]==df$country[genre_index]) {
          # Creates a list to be nested in entry which will contain the 
          # genre's data for the country
          
          nms <- list()
          nested_entry <- list()
          
          processed_decades <- c("start")
          # Iterates through each row, creating an index of decades
          for (decade_index in 1:nrow(df)) {
            if (df$country[country_index]==df$country[decade_index] & 
                df$genre_family[genre_index]==df$genre_family[decade_index] &
                !is.element(df$decade[decade_index], processed_decades)) {
              # Adds to the nested list the data for a specific decade
              nms <- c(nms, df$decade[decade_index])
              nested_entry <- c(nested_entry, list(
                population=df$population[decade_index],
                count=df$count[decade_index]
              ))
              processed_decades <- 
                c(processed_decades, df$decade[decade_index])
            }
          }
          processed_genres <- 
            c(processed_genres, df$genre_family[genre_index])
          names(nested_entry) <- nms
          nms2 <- c(nms2, df$genre_family[genre_index])
          entry <- c(entry, nested_entry)
        }
      }
      processed_countries <- 
        c(processed_countries, df$country[country_index])
      names(entry) <- nms2
      json <- c(json, entry)
    }
  }
  return(toJSON(json, pretty = TRUE, auto_unbox = TRUE))
}
exportJSON <- create_json(joined_df)
write(exportJSON, "test.json")

# Removes superfluous data frame
rm(albums)
rm(artists)
rm(albums_lite_choro)
rm(df_album)
rm(artists_lite_choro)

