# data import
setwd("~/Programming/UCA_MSc-DS1/statistical_inference_1/lecture_8")
A1=load("A1.Rdata")
A2=load("A4.Rdata")

x1=rexp(100,2)
x2=rbinom(100,10,0.5)
x3=runif(100,-7,3)
y=-2+3*x2-x3+rnorm(100,0,1)

plot(x1,y) #no apparent link between the two variables
plot(x2,y) #positive linear tendency
plot(x3,y) #negative linear tendency

L=lm(y~x1+x2+x3)
summary(L) #large R^2: 0.9...
# DF: 96, n-rank of X matrix (3 independent variables -> rank of 4)
L$rank
plot(L)

sr=rstandard(L)
ks.test(sr, 'pnorm') #Gaussianity of the noise.

#F(isher) statistic is associated to the test:
#H0 => beta1 = beta2 = ... = betaP = 0
#H1 => one at least is different from 0
# The F-test of overall significance indicates whether your 
# linear regression model provides a better fit to the data than a 
# model that contains no independent variables. 

n=100
p=10
p0=5
sigma=1
beta0=c(rep(5,p0), rep(0,p-p0))
x=sapply(1:p,FUN=function(x){rnorm(n,0,1)})
y=x%*%beta0+rnorm(n,0,1)
plot(y,x%*%beta0)
bols = solve((t(x)%*%x))%*%t(x)%*%y
#install.packages("glmnet")
library(glmnet)
fitr=glmnet(x,y,alpha=0) #ridge
fitl=glmnet(x,y,alpha=1) #lasso
coef(fitr)
coef(fitl)
