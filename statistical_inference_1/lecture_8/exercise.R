# data import
setwd("~/Programming/UCA_MSc-DS1/statistical_inference_1/lecture_8")
A=load("A1.Rdata")
head(A)
plot(A1$X,A1$Y)

# coefficient of determination
r=cor(A1$X, A1$Y)
r^2

# linear model
L1=lm(Y~X, data=A1)
L1
summary(L1)# t-value = \frac{\hat{\beta}}{\hat{sigma^2}.\sqrt{(^{-1}X.X^{-1})}}

sr = rstandard(L1) #standardized residuals
hist(sr, freq=FALSE) #noise is Gaussian

#way to see if we can accept the "gaussianity" of the noise
plot(L1)

empq=sort(sr)
tq=qnorm(1:100/100)
qqplot(tq, empq)

A=load("A4.Rdata")
L4=lm(Y~X, data=A4)
plot(A4$X, A4$Y)
plot(L4)
sr4 = rstandard(L4)

ks.test(sr4, "pnorm") #gaussianity is rejected
# To test the gaussianity/normality of IID random variables
# Kolmogorov Smirnov test.

# Shapiro-Wilk Normality test
shapiro.test(sr4)

A=rnorm(20, 1, 2)
B=sort(A)
mA = min(A)
MA = max(A)
plot(c(mA-1, B), 
     c(0,1:20/20),
     type='s', 
     xlab='', 
     ylab='distribution function',
     xlim=c(mA-1, MA), 
     ylim=c(0,1)
     )
par(new=TRUE)
x=seq(mA-1,MA,0.01)
plot(x, 
     pnorm(x,1,2),
     type="l", 
     xlab="", 
     col="red",
     ylab='distribution function',
     xlim=c(mA-1, MA), 
     ylim=c(0,1)
)

ks.test(A, "pnorm")
m=mean(A)
v=var(A)
ks.test(A,"pnorm",m,sqrt(v)) #need to add the total definition
# of the distribution (or estimates)
