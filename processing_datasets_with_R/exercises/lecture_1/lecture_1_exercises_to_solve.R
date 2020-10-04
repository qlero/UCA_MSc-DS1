# EXERCISE 1
# What is the sum of the first 100 positive integers? 
# The formula for the sum of integers 1 through n is n(n+1)/2. 
# Define n=100 and then use R to compute the sum of 1 through 100 
# using the formula. What is the sum?

# version 1
sum100 <- function(num){
  (num*(num+1))/2
}
# version 2
recursiveSum100 <- function(num){
  if(num <= 1) {
    1
  } else {
    num + recursiveSum100(num-1)
  }
}

n = 100
recursiveSum100(n)
sum100(n) 

# The sum is 5050.

###############################################################################

# EXERCISE 2
# Load the US murder database
# 1. Use the accessor $ to extract the state abbreviations and assign 
# them to the object a. What is the class of this object?
# 2. Now use the square brackets to extract the state abbreviations and 
# assign them to the object b. Use the identical function to determine 
# if a and b are the same.
# 3. The function table takes a vector and returns the frequency of each 
# element. You can quickly see how many states are in each region by 
# applying this function. Use this function in one line of code to 
# create a table of states per region.

#install.packages("dslabs")
library(dslabs)
dataset <- murders

### Question 1
a <- dataset$abb
class(a) 

# class is "character"

### Question 2
b <- dataset["abb"]
class(b) # class is "data.frame"
a==b
class(a)==class(b) 

# a and b contain the same data, but they are not sharing the same class/data 
# structure. Therefore a and b are not the same

### Question 3
regions <- dataset$region
table(c(regions),regions)

###############################################################################

# EXERCISE 3
# 1. Create two vectors of different dimensions and insert the second one in 
# the first one between the 2nd and 3rd elements.
# 2. Draw 100 numbers from a Uniform distribution on [0,1] and count how many 
# values are larger than 0.5
# 3. Compute the per 100,000 murder rate for each state and store it in the 
# object murder_rate. Then compute the average murder rate for the US using 
# the function mean. What is the average?

# Question 1
vec1 <- c("this", "is", "a", "test"); vec2 <- c(".")
vec1=append(vec1, vec2, after=2)
vec1

# Question 2
datapoints <- runif(100,0,1)
sum((datapoints>0.5)==TRUE)

# Question 3
murder_rate <- with(dataset, total/population*100000)
average <- mean(murder_rate)
print(paste("The average murder rate is: ",as.character(round(average,digits=2))," murders per 100,000 people in the US."))

# "The average murder rate is:  2.78  murders per 100,000 people in the US."

###############################################################################

# EXERCISE 4
# Write a script allowing to load a vector file and "remove" the missing values.

library(readr)

load_and_clean <- function(pack, filename){
  # determines the full path of the vector file (here in the case of dslabs)
  dir      <- system.file("extdata", package=pack)
  fullpath <- file.path(dir, filename)
  # returns a loaded fector file
  return(na.omit(read_csv(fullpath)))
}

clean_data = load_and_clean("dslabs", "murders.csv")
head(clean_data)

###############################################################################

# Exercise 5
# Create a histogram of the state populations.
# Generate boxplots of the state populations by region.

# Question 1
d <- aggregate(dataset$population/1000000, by=list(state=dataset$state),FUN=sum)
d <- d[order(d$x, decreasing=T),]
t <- d$x
names(t) <- d$state
barplot(t, las=3, space=3, col="pink", 
        main="Population by US States",ylab="US State Population (in millions)",
        cex.lab=1,cex.axis=0.8,cex=0.5,cex.main=1)

# Question 2
boxplot(population/1000000~region, data = dataset, 
        main="Population by US States per US Regions"
        ,xlab="US Regions",ylab ="US State Population (in millions)")

###############################################################################

# Exercise 6 - Data normalization
# Create a function that normalizes a vector:
#  x_new = (x-mean(x))/std(x)
# Use this function on the iris dataset so that each column is normalized. 
# You can also make the function more general x_new = (x-a)/b and use it 
# to preprocess the data with min/(max-min) instead of mean/std
# 2 Trainig/test sets
# Create a new file with a function that split a dataframe into train-valid-test 
# set, given 3 ratios

normalize <- function(vector){
  (vector-mean(vector))/sd(vector)
}
test <- as.data.frame(lapply(iris[1:4],normalize))
test$Species <- iris$Species
head(test)

# Exercise 6 - Training/Test Sets

# > see other file: train_test_sets.R
