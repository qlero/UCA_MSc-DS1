### DPLYR

# Libraries
install.packages("dplyr")
library("dplyr")

# Importing data
filename <- "chicago"
path <- paste0(getwd(), 
               "/Programming/UCA_MSc-DS1/processing_datasets_with_R/exercises/lecture_2/")
filepath <- paste0(path,filename)
chicago <- readRDS(filepath)

dim(chicago)
str(chicago)
names(chicago)[1:3]
subset <- select(chicago, city:dptp)
head(subset)

select(chicago, -(city:dptp))
i <- match("city", names(chicago))
j <- match("dptp", names(chicago))
head(chicago[, -(i:j)])
      
subset <- select(chicago, ends_with("2"))
str(subset)
 
subset <- select(chicago, starts_with("d"))
str(subset)

chic.f <- filter(chicago, pm25tmean2 > 30)
str(chic.f)

summary(chic.f$pm25tmean2)

chic.f <- filter(chicago, pm25tmean2 > 30 & tmpd > 80)
select(chic.f, date, tmpd, pm25tmean2)

# arrange
chicago <- arrange(chicago, date)
head(select(chicago, date, pm25tmean2), 3)
tail(select(chicago, date, pm25tmean2), 3)

head(select(chicago, date, pm25tmean2), 3)
tail(select(chicago, date, pm25tmean2), 3)

# rename
head(chicago[, 1:5], 3)
chicago <- rename(chicago, dewpoint = dptp, pm25 = pm25tmean2)
head(chicago[, 1:5], 3)

#mutate
chicago <- mutate(chicago, pm25detrend = pm25 - mean(pm25, na.rm = TRUE))
head(chicago)
head(transmute(chicago, 
               pm10detrend = pm10tmean2 - mean(pm10tmean2, na.rm = TRUE), 
               o3detrend = o3tmean2 - mean(o3tmean2, na.rm = TRUE)))

# groupby
chicago <- mutate(chicago, year = as.POSIXlt(date)$year+1900)
years <- group_by(chicago, year)
   
summarize(years, pm25 = mean(pm25, na.rm = TRUE), 
          o3 = max(o3tmean2, na.rm = TRUE), 
          no2 = median(no2tmean2, na.rm = TRUE))
               
qq <- quantile(chicago$pm25, seq(0, 1, 0.2), na.rm = TRUE)
chicago <- mutate(chicago, pm25.quint = cut(pm25, qq))

quint <- group_by(chicago, pm25.quint)
summarize(quint, o3 = mean(o3tmean2, na.rm = TRUE), 
          no2 = mean(no2tmean2, na.rm = TRUE))

#pipeline
mutate(chicago, pm25.quint = cut(pm25, qq)) %>% 
  group_by(pm25.quint) %>% 
  summarize(o3 = mean(o3tmean2, na.rm = TRUE), 
            no2 = mean(no2tmean2, na.rm = TRUE))

mutate(chicago, month = as.POSIXlt(date)$mon + 1) %>% 
  group_by(month) %>% 
  summarize(pm25 = mean(pm25, na.rm = TRUE), 
            o3 = max(o3tmean2, na.rm = TRUE), 
            no2 = median(no2tmean2, na.rm = TRUE))

### CONTROL STRUCTURES

x <- c("a", "b", "c", "d")

for(i in 1:4) {
  ## Print out each element of 'x'
  print(x[i])  
}

for(i in seq_along(x)) {   
  print(x[i])
}

count <- 0
while(count < 10) {
  print(count)
  count <- count + 1
}
