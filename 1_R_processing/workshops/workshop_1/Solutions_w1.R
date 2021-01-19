#####WORKSHOP 1####


## Exercise 1

##1a )create a a vector v going from 1 to 10 in increments of 0.5.
##1b )build the function "foo" that sorts the elements of v in a decreasing order, store the results in vector z.
##1c )from vector v create a sample,t, of size 100 with replacement where the probabilities are given by a random uniform distribution.
##   Which number occur the most?
##   Create an histogram from t with yellow cells that has as main title = "Sampling with replacements".
##1d) Create a 7×8 matrix filled by row of Gaussian random numbers, with mean 1 and standard deviation 2.  
##   Add 1 to the elements lower than the mean.
##1e)Using the iris datasets make a boxplot of the variables in the dataset, last column excluded.
##    Make a matrix of scatterplots of the previous variables where color and form of the points depend on the species
##1f)Plot with different colors the estimated density functions of four random gamma distribution  
##    with n =1000 and scale parameter respectively: 1, 2 , 3, 4. 

## Exercise 2   
##install.packages("nycflights13")  install.packages("tidyverse")
##    we’ll use nycflights13::flights. This data frame contains all 336,776 flights that departed from New York City in 2013. 
##    The data comes from the US Bureau of Transportation Statistics, and is documented in ?flights.
##2a)Create a new data frame that contains only the flights on 8 April 2013. 
##       Find the flight with the lowest departure delay.
##2b) How many flights were delayed (on arrival or departure) by more than four hours?
##       Create a new data frame containing the dep_delay variable for the flights with the highest departure delay for each month, the month, the day and the mean of the departure delay for each month. 
##2c) Considering only the flights that landed in LAX airport, show the departure delay and the arrival delay, 
##     ordered according to the departure delay in a descendent order. Then compute the column mean.

## Exercise 3   
##3a) Create a dataframe of 100 people where the first column represents the age, distribuited as a random uniform,from 20 to 40 years old, 
# the second column represents the Weight, distributed as a random uniform, from 50 to 90 kg with one decimal and
# the third column if they are graduated or not, respectively with a proportion of 60% and 40%.

##3c)  Insert 5 missing values in each column at random locations, with a for loop.
##
##3d) Change column name "Graduated" to "Driving_License". 
##    Count the number of missing values in the dataframe. Now remove them.
##3e) Make a Min-Max Normalization: (X – min(X)) / (max(X) – min(X)) of the first two columns-
##3f) Make a a z-score standardization: (X – μ) / σ of the first two columns.




###EXERCISE 1
## 1a)
v= seq(1,10,0.5)

## 1b)
foo = function(v){
  z = sort(v, decreasing = TRUE)
  return(z)
  print(z)
}
z = foo(v)
## 1c)
set.seed(123)
t = sample(v, 100, replace = T, prob=runif(19))
t
sort(table(t)) #To check
hist(t,freq=T, breaks =19, col = "yellow", main = "Sampling with replacement")
#ok also: hist(z,freq=T, breaks =19, col = "yellow", main = "Sampling with replacement")

#1d)

A=matrix(rnorm(56, 1,2), nrow = 7, ncol = 8)

B =ifelse(A<mean(A),A+1,A) 

A
#1e)
data("iris")
boxplot(iris[,-5])

x = iris[,-5]
y = iris$Species
pairs(x,col=as.numeric(y),pch=as.numeric(y))

##1f)
x= rgamma(1000,1)
fx=density(x)
plot(fx, col=2, lwd=3)

y= rgamma(1000,2)
fy=density(y)
lines(fy, col =3,  lwd=3)

z= rgamma(1000,3)
fz=density(z)
lines(fz, col =6, lwd=3)

t= rgamma(1000,4)
ft=density(t)
lines(ft, col =5, lwd=2, lty = 2)


##2a)
filter(flights, month == 4 & day == 8)%>%
  filter(dep_delay==min(dep_delay, na.rm = T))



#2b
filter(flights, (arr_delay > 240 | dep_delay > 240))

Mean_del=flights %>% 
  group_by(month) %>% 
  mutate(mean_delay_month = mean(dep_delay, na.rm = TRUE)) %>%
  filter(dep_delay == max(dep_delay, na.rm = TRUE))  %>% 
   
   select(dep_delay, month, day,mean_delay_month)
           


#2c
Lax=flights %>% 
       filter(dest == "LAX") %>% 
       select(dep_delay, arr_delay) %>% 
      arrange(desc(dep_delay))



##3a)
df = data.frame(Age=round(runif(100,20, 40),0), Weight= round(runif(100, 50, 100),1), 
                Graduated=sample(c("No","Yes"), size = 100, replace = T, prob = c(0.4,0.6)))
df
##3b)
for(i in 1:3){
  df[sample(1:100, 5), i] =NA
}


#3c)
colnames(df)[which(names(df) == "Graduated")] = "Driving_License"
colSums(is.na.data.frame(df))
df=na.omit(df)

#3d)
#define Min-Max normalization function
min_max_norm <- function(x) {
  (x - min(x)) / (max(x) - min(x))
}
df_norm <- as.data.frame(lapply(df[,-3], min_max_norm))

#3e)
z_std = function(x){
  (x-mean(x))/sd(x)
}
df_std <- as.data.frame(lapply(df[,-3], z_std))
#Notice that each of the columns now have values that range from 0 to 1. 
#Also notice that the third column “Driving_License” was dropped from this data frame.
#We can easily add it back by using the following code:
df_norm$Driving_License <- df$Driving_License
