# Normal distribution
dnorm(x, mean=0, sd=1, log=FALSE)
pnorm(q, mean=0, sd=1, lower.tail=TRUE, log.p=FALSE)
qnorm(p, mean=0, sd=1, lower.tail=TRUE, log.p=FALSE)
rnorm(r, mean=0, sd=1)

# setting the random number seed
set.seed(1) #always set the random number seed when conducting simulation
rnorm(5)

x<-rnorm(10) # generates 10 numbers ~ N(0,1)
x<-rnorm(10,20,2) # generates 10 numbers ~ N(20,2)
summary(x)

# simulating a linear model
set.seed(20)
x <- rnorm(100)
e <- rnorm(100,0,2)
y <- 0.5 + 2*x + e
summary(y)
plot(x,y)

set.seed(1)
x <- rnorm(100)
log.mu <- 0.5 + 0.3*x
y <- rpois(100, exp(log.mu))
summary(y)
plot(x,y)
  
#random sampling
set.seed(1)
sample(1:10,4)[1]
