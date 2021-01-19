#####
#### Bootstrapping - first

#set.seed(0)
N <- 100 
dat <- rcauchy(N)
m_hat  <- median(dat)

##########################
## bootstrap intervals##
##########################

B <- 1000
bm_hat <- vector(length = B)
for (idx in 1:B){
  bdat <- sample(dat, replace = TRUE)
  bm_hat[idx] <- median(bdat)
}

# three types of bootstrap CI (95%)
se <- sd(bm_hat) 
z <- qnorm(0.975)
# normal-like
b_CI_1 <- c(m_hat - z*se, m_hat + z*se) 
# pivotal bootstrap
b_CI_2 <- c(2*m_hat - quantile(bm_hat,0.975), 2*m_hat - quantile(bm_hat,0.025))
# quantile bootstrap
b_CI_3 <- c(quantile(bm_hat,0.025),  quantile(bm_hat,0.975))

#####################
## empirical CIs ##
#####################

## Here we can adopt this solution since we know the real distribution of the data
## (Cauchy(0,1)) so we can sample again and build  an empirical CI. This  way is
## clearly not available with real data!

n_rep <- 1000
store_m_hat <- vector(length = n_rep) 
for (idx in 1:n_rep){
  dat_ <- rcauchy(N)
  store_m_hat[idx] <- median(dat_)
}

# empirical CI
e_CI <- c(quantile(store_m_hat, 0.025), quantile(store_m_hat, 0.975))

#####
## Exercise 2, page 117
N  <- 1000
dat <- exp(rnorm(N))

# skewness plug-in estimator!
sk_hat <- function(dat){
  m <- mean(dat)
  num <- mean((dat - m)^3)
  den <- (sd(dat))^3
  return(num/den)
}

# estimate!
sk_ <- sk_hat(dat)

B <- 1000
b_sk <- vector(length = B)
for (idx in 1:B){
  dat_ <- sample(dat, replace = TRUE)
  b_sk[idx] <- sk_hat(dat_)
}
se <- sd(b_sk)
## bootstrap CIs
b_CI_1 <- c(sk_ - z*se, sk_ + z*se)
b_CI_2 <- c(2*sk_ - quantile(b_sk, 0.975), 2*sk_ - quantile(b_sk, 0.025))
b_CI_3 <- c(quantile(b_sk, 0.025), quantile(b_sk, 0.975))

check_coverage <- function(N,I,n_rep = 1000){
  counter <- 0
  for (idx in 1:n_rep){
    dat <- exp(rnorm(N))
    sk_ <- sk_hat(dat)
    if (sk_ < I[2] && sk_ > I[1]){
      counter <- counter + 1
    }
  }
  return(counter/n_rep)
}

cat("coverage - 1:", check_coverage(N,b_CI_1),"\n")
cat("coverage - 2:", check_coverage(N,b_CI_2),"\n")
cat("coverage - 3:", check_coverage(N,b_CI_3),"\n")
