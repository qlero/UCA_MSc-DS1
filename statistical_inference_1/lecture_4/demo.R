library(ellipse)

set.seed(1247)
X1=runif(100,-4,4)
Y1=2*X1-3+rnorm(100,0,2)

X2=runif(100,-4,4)
Y2=2*X2-3+rnorm(100,0,2)

ymin=min(Y1,Y2)
ymax=max(Y1,Y2)

plot(X1,Y1,xlim=c(-4,4),ylim=c(ymin,ymax),xlab='',ylab='')
par(new=TRUE)
plot(X2,Y2,xlim=c(-4,4),ylim=c(ymin,ymax),xlab='',ylab='',col='blue')

L1=lm(Y1~X1)
L1
L2=lm(Y2~X2)
abline(L1,col='red')
abline(L2,col='green')


resume1=summary(L1)
coef=coef(resume1)
IC=confint(L1,level=0.95)
IC

plot(ellipse(L1,level=0.95),type="l", xlab=paste("beta",0,sep=""),ylab=paste("beta",1,sep=""),xlim=c(-3.8,-2.5),ylim=c(1.5,2.2))
points(coef(L1)[1], coef(L1)[1],pch=3)
lines(c(IC[1,1],IC[1,1],IC[1,2],IC[1,2],IC[1,1]),c(IC[2,1],IC[2,2],IC[2,2],IC[2,1],IC[2,1]),lty=2)

X1b=X1
X1 <- seq(min(X1),max(X1),len=100)
grille <- data.frame(X1)
ICdte <- predict(L1,new=grille,interval="confidence",level=0.95)
ICpre <- predict(L1,new=grille,interval="prediction",level=0.95)
plot(Y1~X1b,pch='+')
matlines(X1,cbind(ICdte,ICpre[,-1]),lty=c(1,2,2,3,3),col=c('blue','red','red','green','green'))
legend("topleft",lty=2:3,c("E(Y)","Y"),col=c('red','green'))

summary(L1)

X3=runif(100,-4,4)
Y3=2*X3-3+rexp(100,2)
L3=lm(Y3~X3)

plot(X3,Y3,xlim=c(-4,4),ylim=c(ymin,ymax),xlab='',ylab='')
abline(L3)

par(mfrow=c(1,2))
hist(L1$residuals,freq=FALSE)
hist(L3$residuals,freq=FALSE)

r1=rstudent(L1)
r3=rstudent(L3)

ks.test(r1,"pt",98) "pnrom to test if it is gaussian"
ks.test(r3,"pt",98)

#Example
t=rnorm(1000,2,4) #mean 2, variance 16
ks.test(t, "pnorm", 2, 4) # test if gaussian with mean 2 and var 16
ks.test(t, "pnorm") # test if standard gaussian
hist(t, freq=FALSE)
m=mean(t)
s2=var(t)
ks.test(t, 'pnorm', m, sqrt(s2)) #punif pbnorm ppoisson etc.

shapiro.test(t)

plot(L1)