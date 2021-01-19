set.seed = 0

# Variable declaration
observations <- 1000
p <- 4
k_folds = 5

# Distribution declaration
exponential <- rexp(observations, 0.5) 
uniform <- runif(observations, -2, 2)
student <- rt(observations, 7)
binomial <- rbinom(observations, 10, 0.5)
normal <- rnorm(observations, 0, 1)
Y <- 3 - 2*exponential + 3*uniform + student - 5*binomial
data <- data.frame(exponential = exponential,
                 uniform = uniform,
                 student = student,
                 binomial = binomial,
                 normal = normal,
                 Y = Y)

# Plotting Y
hist(Y, breaks = 50, main = "") #barchart
plot(Y) # plot

# Constructing the model
model <- lm(data[,"Y"]~exponential+uniform+student+binomial+normal, 
            data=data)
summary(model)
confint(model)

cross_validation <- function(k_folds, data, observations) {
  # declaring the list holding the predictions
  preds = c()
  # shuffling the dataset
  data = data[sample(1:nrow(data)),]
  # Modeling
  for (fold in 1:k_folds) {
    print(paste("Cross-validating on fold ", fold))
    # creating the folds
    validation_fold_start = 1 + (observations/k_folds)*(fold-1)
    validation_fold_end = (observations/k_folds)*(fold)
    training_set = data[-(validation_fold_start:validation_fold_end),]
    validation_set = data[validation_fold_start:validation_fold_end,]
    print(validation_fold_start)
    print(validation_fold_end)
    # training on the training sets
    model = lm(training_set[,"Y"]~exponential+uniform+student+binomial+normal, 
                data=training_set)
    # predicting on the k_fold
    predictions = predict(model, validation_set, se.fit=TRUE)
    # recording the error
    crossvalidation_error = (1/k_folds) * sum(predictions$se.fit^2)
    preds = append(preds, crossvalidation_error)
  }
  return(preds)
}

run_CV <- cross_validation(k_folds, data, observations)
run_CV

