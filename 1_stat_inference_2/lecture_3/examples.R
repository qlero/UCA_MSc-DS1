# We know the law of our data in this framework -- which is not the case in real life

# A primer on resampling

N <- 100 # number of observations
dat <- rcauchy(N) # observations from a distribution
hist(dat, breaks=30)

# estimating the median of a Cauchy(0,1) distribution
hat_m <- median(dat) #plug-in estimate of the median!

n_rep <- 1000
store_hat_m <- vector(length=n_rep) #set of estimates of the median

for (idx in 1:n_rep) {
  dat_ <- rcauchy(N)
  store_hat_m[idx] <- median(dat_) #median of an independent sample
}

hist(store_hat_m, breaks=100)
empirical_sd <- sd(store_hat_m)

#plot(ecdf(store_hat_m))
#grid_ <- seq(-3, .3, by=0.001)
#val <- pnorm(grid_, mean(store_hat_m), sd=sd(store_hat_m))
#lines(grid_, val, col="red")

# the previous solution is not likely.

# estimating "resampling" sd of the median.
B <- 1000
store_hat_m_B <- vector(length=B)
for (idx in 1:B) {
  dat_ <- sample(dat, replace=TRUE)
  store_hat_m_B[idx] <- median(dat_)
}

bootstrap_sd <- sd(store_hat_m_B)
hist(store_hat_m_B, breaks=100)
plot(ecdf(store_hat_m_B))

b_CI <- c(quantile(store_hat_m_B, 0.025), quantile(store_hat_m_B, 0.975))
b_CI

