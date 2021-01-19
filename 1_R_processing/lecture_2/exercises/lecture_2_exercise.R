### Exercise 1
# Random vector
# Generate a random normal vector of size 100
# Compute its mean with for/repeat loop
# Compute its variance with for/repeat loop
n=100
x=rnorm(n,0,1)
mn=0
vr=0
for (i in x) {   
  mn=mn+i/n
}
for (i in x) {
  vr = vr+(i-mn)^2/n
}
mn
vr

###############################################################################

### Exercise 2
# treating missing values
# Use the airquality dataset from base
# Compute the percentage p_na of missing values in a column
# If p_na > 0,5 - delete the column
# If p_na <= 0,5 - replace the missing values by 0 or by the mean of the column,
# depending on a variable "type_na"
data <- airquality
names(data)

clean_data <- function(type_na, dataset) {
  for (i in names(dataset)) {
    j <- match(i, names(dataset))
    na_percent <- sum(is.na(dataset[j]))/nrow(dataset)
    if (na_percent > 0.5) {
      dataset <- select(dataset, -j)
    } else {
      if (type_na == "mean") {
        dataset[j][is.na(dataset[j])] <- dataset[j]/sum(dataset[j])
      } else if (type_na == "0") {
        dataset[j][is.na(dataset[j])] <- 0
      } else {
        print("Wrong argument input.")
      }
    }
  }
  return(dataset)
}

subset1 = clean_data("mean",data)
subset2 = clean_data("0",data)
subset3 = clean_data("test",data)

###############################################################################

### Exercise 3
# mean and standard deviation over the columns
# Compute the mean of all columns of iris dataset
# Compute their standard deviation
dataset <- iris
means <- apply(dataset[1:4], 2, mean)
std <- apply(dataset[1:4], 2, sd)
means
std

