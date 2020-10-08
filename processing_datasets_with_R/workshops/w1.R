### EXERCISE 1
# 1.a ####
v <- seq(1, 10, 0.5)
# 1.b ####
foo <- function(vec) {
  return(sort(vec, decreasing = TRUE))
}
z <- foo(v) 
# 1.c ####
set.seed(123)
sampleFromV <- sample(v, 100, replace=TRUE, prob=runif(19))
mostOccuring <- sort(table(sampleFromV), decreasing=TRUE)[1]
print(mostOccuring) # with this seed, 3 occurred 13 times
hist(sampleFromV, 
     main="Sampling with replacements",
     col="yellow",
     breaks=19,
     freq=TRUE)
#1.d ####
gaussianMatrix <- matrix(rnorm(7*8,mean=0,sd=1), 7, 8)
#incr <- function(x) {                                                   
#  if (x < 0) {return(x+1)} 
#  else {return(x)}
#}
#newGaussianMatrix <- sapply(gaussianMatrix, incr)
incrGaussianMatrix <- ifelse(gaussianMatrix<mean(gaussianMatrix),
                             gaussianMatrix+1,
                             gaussianMatrix)
#
#1.e ####
data <- iris
dataToPlot <- data[1:length(data)-1]
boxplot(dataToPlot)
my_cols <- c("red", "blue", "green")  
my_shapes <- c(1, 7, 18)
pairs(dataToPlot,
      cex = 0.7,
      pch = as.numeric(iris$Species),  
      col = as.numeric(iris$Species),
      lower.panel=NULL)
#1.f ####
x = seq(0, 1000, by = 1)
y1 = rgamma(x, 1)
plot(density(y1), col=2, lwd=3)
y2 = rgamma(x, 2)
lines(density(y2), col = 3, lwd=3)
y3 = rgamma(x, 3)
lines(density(y2), col = 6, lwd=3)
y4 = rgamma(x, 4)
lines(density(y2), col = 5, lwd=2, lty=2)

###############################################################################

### EXERCISE 2
install.packages("nycflights13")
install.packages("tidyverse")
library(dplyr)    
# 2.a ###
data <- as.data.frame(nycflights13::flights)
df_130408 <- filter(data, month==4, day==8)
ordered_delay_df_130408 <- df_130408[order(df_130408$dep_delay),]
lowest_delay <- head(ordered_delay_df_130408,1)
lowest_delay
# 2.b ###
delay4h_flights <- filter(data, dep_delay>4*60) 
max_mean_df <- data %>% 
  select(year, month, day, dep_delay) %>% 
  group_by(month) %>% 
  mutate(mean_delay = mean(dep_delay, na.rm = TRUE)) %>%
  filter(dep_delay==max(dep_delay, na.rm=TRUE)) %>%
  arrange(month)
head(max_mean_df)
# 2.c ###
LAX_arrivals <- data %>%  
  filter(dest=="LAX") %>%
  select(dep_delay,arr_delay) %>%
  arrange(desc(dep_delay))
head(LAX_arrivals)
  
###############################################################################

### EXERCISE 3
# 3.a ###
people_df <- data.frame(age=runif(100,20,40),
                        weight=runif(100,50.0,90.0),
                        graduated=(rnorm(100,0,1)<0.2257))
# no 3.b
# 3.c ###
columns = c(1,2,3)
rows = seq(1,nrow(people_df))
for (i in seq(1,5)) {
    people_df[sample(rows,1),sample(columns,1)]=NA
}
# 3.d ###
names(people_df)[-1] <- "Driving_License"
sum(is.na(people_df))
people_df <- na.omit(people_df)
sum(is.na(people_df))

# send to Giulia Marchello