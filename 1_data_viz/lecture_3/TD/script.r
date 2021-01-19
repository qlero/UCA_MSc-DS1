setwd("~/Documents/latex_projects/R_Lecture/ScriptsR")

library(tidyverse)

round_1 <- read_csv('data/results_pres_elections_2017_round_1.csv')
round_2 <- read_csv('data/results_pres_elections_2017_round_2.csv')

"Parsed with column specification:
cols(
  dept_name = col_character(),
  muni_code = col_double(),
  dept_code = col_double(),
  muni_name = col_character(),
  registered_voters = col_double(),
  absent_voters = col_double(),
  present_voters = col_double(),
  blank_ballot = col_double(),
  null_balot = col_double(),
  votes_cast = col_double(),
  name = col_character(),
  firstname = col_character(),
  gender = col_character(),
  votes = col_double()
)"

round_1_bis <- round_1 %>% select(dept_code, dept_name, muni_code, muni_name, everything(), -gender, -firstname) %>%
  rename(commune_code = muni_code, commune_name = muni_name) %>%
  spread(name, votes)
write_csv(round_1_bis, 'data/results_pres_elections_2017_round_1.csv')

round_2_bis <- round_2 %>% select(dept_code, dept_name, muni_code, muni_name, everything(), -gender, -firstname) %>%
  rename(commune_code = muni_code, commune_name = muni_name) %>%
  spread(name, votes)
write_csv(round_2_bis, 'data/results_pres_elections_2017_round_2.csv')
