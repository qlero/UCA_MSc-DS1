# Exercise 6 - Training/Test Sets
# Create a new file with a function that split a dataframe into train-valid-test
# set, given 3 ratios

# Train/Val/Test Split function
train_test_split <- function(train_ratio, val_ratio, test_ratio, dataset){
  if (train_ratio+val_ratio+test_ratio>1) {
    print("ERROR: The sum of your ratios is superior to 1")
    return(list())
  } else {
    # create train_set
    train <- sample(nrow(dataset),nrow(dataset)*train_ratio)
    train_set <- dataset[train,]
    # create a smaller dataset for val and test as well as a new splitting ratio
    smaller_dataset <- dataset[-train,]
    new_ratio = (val_ratio)/(val_ratio+test_ratio)
    # create val_set
    val <- sample(nrow(smaller_dataset),nrow(smaller_dataset)*new_ratio)
    val_set   <- smaller_dataset[val,]
    test_set  <- smaller_dataset[-val,]
    return(list(train_set, val_set, test_set))
  }
}

# Unit Tests of Function

library("dslabs")
dataset <- iris

split = train_test_split(0.7, 0.2, 0.2, dataset) 
split
# Should return an error message and empty list

split=train_test_split(0.7, 0.2, 0.1, dataset)
# Should return length "105" for nrow(train_set) i.e. index 1
# Should return length "30" for nrow(val_set) i.e. index 2
# Should return length "15" for nrow(test_set) i.e. index 3
for (i in c(1,2,3)){
  print(nrow(as.data.frame(split[i])))
  print(head(as.data.frame(split[i]),n=5))
}
