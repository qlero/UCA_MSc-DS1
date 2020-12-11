n <- 10 
a <- 1
b <- 3

# Generate a sample from the uniform distribution [a,b], containing n observations
data <- runif(n, min=a, max=b)

# to calculate the ML estimator of tau = E(X_i)
tau_ML <- function(data){
  a_ML <- min(data)
  b_ML <- max(data)
  return(.5*(a_ML+b_ML))
}
tau_ML(data)

# We want to estimate numerically, MSE(tau_ML) = E[[tau_ML -2]^2]
# We repeat the sampling (line 6) L times, and for each l we compute tau_ML^{(l)}
# Finally we estimate MSE(tau_ML) = 1/L \sum_{l=1}^L (tau_ML^{(l)} -2)^2

L <- 1000
store_tau_ML <- vector(length=L)
for (l in 1:L) {
  data <- runif(n, a, b)
  tau_hat <- tau_ML(data)
  store_tau_ML[l] <- tau_hat
}

MSE_tau_ML <- mean((store_tau_ML -2)^2)
MSE_tau_Pin <- 1/30

# The MLE is the one that add the smallest amount of error