setwd("D:/repositories/UCA_MSc-DS1/data_visualization/lecture_3/TD")

library(readr)
library(tibble)
library(dplyr)
library(tidyr)
library(stringr)
library(ggplot2)

# DATA FORMAT: TIBBLE

round_2 <- read_csv('data/results_pres_elections_dept_2017_round_2.csv')
class(round_2)

# DYPLR DATA MANIPULATION

round_2 %>% select(region_name, `LE PEN`, MACRON)
