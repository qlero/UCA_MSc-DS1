# install.packages("tseries")
library(tseries)

mean_estimator <- function(x){
  return(mean(x))
}

bad_estimator <- function(x){
  if (x[1]==0){
    return(0)
  } else {
    return(1)
  }
}

simulation <- function(sample_size, estimator){
  N <- sample_size #number of individuals in a sample
  p <- 0.4 #probability of success (Bernouilli)
  x <- runif(N)
  x[x>=p] = 0
  x[x!=0] = 1 # sampling of a Bernouilli rv. with p. of success 0.4
  p_hat <- estimator(x) #with set.seed(0) p_hat always = 0.38
  return(p_hat)
}

rep_simulation <- function(sample_size, repetition, estimator){ # repeats simulation rep times
  stock_p_hat <- vector(length=repetition)
  for (idx in 1:repetition){
    stock_p_hat[idx]=simulation(sample_size, estimator)
  }
  return(stock_p_hat)
}

#############################################################################
p_hat <- simulation(100, mean_estimator)
bad_p_hat <- simulation(100, bad_estimator)
p_hat
bad_p_hat #the estimator is inconsistent as it gives only 0 or 1

# testing Unbiasness
good_rep_1000 = rep_simulation(1000, 1000, mean_estimator)
mean(good_rep_1000)
hist(good_rep_1000,breaks=50)

bad_rep_1000 = rep_simulation(1000, 1000, bad_estimator)
mean(bad_rep_1000)
hist(bad_rep_1000,breaks=50)

############################################################################
rep_alot = rep_simulation(100, 100000, mean_estimator)
mean(rep_alot)
hist(rep_alot, breaks=60)
# Q: Is rep_alot sampled from a gaussian distribution?
jarque.bera.test(rep_alot) #p-value = 1.547e-09

# There are two numbers to take into account, the number of times the coin is flipped in 
# a single simulation, and the number of times the simulation is run
# The JBtest takes much more into account the first number (the number of flips in a 
# single simulation)
rep_alot = rep_simulation(100000, 100, mean_estimator)
mean(rep_alot)
hist(rep_alot)
jarque.bera.test(rep_alot)
