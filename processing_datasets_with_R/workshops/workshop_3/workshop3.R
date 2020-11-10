#Workshop3

# Libraries
library(ggplot2)
library(dplyr)
library(tidyverse)

data <- read.csv2("bcl-data.csv", header=TRUE, sep=",")
#df <- subset(data, select=c("Type","Country","Price"))

head(data, 1)
data$Alcohol_Content <- as.data.frame(sapply(data$Alcohol_Content, as.numeric))
data$Price <- as.data.frame(sapply(data$Price, as.numeric))

new_data = data %>% filter(Country %in% c("CANADA")) %>% 
  filter(Alcohol_Content >= 5, Alcohol_Content <= 10) %>%
  filter(Type == "BEER")


new_data$Alcohol_Content


ggplot(new_data, aes(Alcohol_Content)) + geom_histogram()
