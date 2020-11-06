set.seed(4)
N <- 100
data <- rnorm(N)

par(bty="n")
my_grid <- seq(-4.0, 4.0, by=0.1)
true_cdf <- pnorm(my_grid) # CDF of a Gaussian

plot(my_grid, true_cdf, col="Black", type="l")

# empirical CDF
empirical_CDF <- function(data, x){
  # 1/n.sum(ID(X_i)]-infty,x])
  return(mean((data <= x)))
}

F_hat <- vector(length=length(my_grid))
for (idx in 1:length(my_grid)) {
  F_hat[idx]=empirical_CDF(data,my_grid[idx])
}

lines(my_grid, F_hat, col="red")

#set.seed(1)
#N <- 100
#data <- rnorm(N)

#F_hat <- vector(length=length(my_grid))
#for (idx in 1:length(my_grid)) {
#  F_hat[idx]=empirical_CDF(data,my_grid[idx])
#}

lines(my_grid, F_hat, col="RoyalBlue")

get_quantile <- function(confidence_level) {
  alpha <- 1-confidence_level
  alpha_half <- alpha/2
  return(qnorm(1-alpha_half))
}

# We need a 95% confidence interval. I.e. We need the quantile
# z_{\frac{\alpha}{2}} = \Phi^{-1}(0.975)

z <- qnorm(0.975)
estimate_sd <- sqrt((F_hat*(1-F_hat))/N)
lower_bound <- F_hat-z*estimate_sd
upper_bound <- F_hat+z*estimate_sd

lines(my_grid, lower_bound, lty=2)
lines(my_grid, upper_bound, lty=2)

####################################

# CAUCHY

set.seed(0)
N <- 1000
dat <- rcauchy(N)

par(bty= "n")
my_grid <- seq(-4.0, 4.0, by = 0.1)
# pnorm -> cdf
# dnorm -> pdf
# qnorm -> for quantiles: it equal to \Phi^{-1}
true_cdf <- pcauchy(my_grid) # Phi- cumulative distribution function (cdf)  of Gaussian 0,1
plot(my_grid, true_cdf, col =  "RoyalBlue3", type = "l")

# empirical cdf
empirical_cdf <- function(dat, x){
  out = mean(dat <= x)
  return(out)
}

F_hat <- vector(length = length(my_grid))
for (idx in 1:length(my_grid)){
  F_hat[idx] = empirical_cdf(dat, my_grid[idx])
}

lines(my_grid, F_hat, col= "green3")

## function to compute the quantile given a confidence level
get_quantile<-function(confidence_level){
  alpha <- 1-confidence_level
  alpha_half <- alpha/2
  return(qnorm(1 - alpha_half))
}

### We need a 95% confidence interval => z_{\alpha/2} = Phi^{-1}(0.975)
z = qnorm(0.975)
e_sd = sqrt((F_hat*(1-F_hat))/N)
lower_bound = F_hat - z*e_sd
upper_bound = F_hat + z*e_sd
lines(my_grid, lower_bound, lty = 2)

