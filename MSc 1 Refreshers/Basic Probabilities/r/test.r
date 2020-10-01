x = rexp(10000,4) # random exponential
hist(x,freq=FALSE,breaks=50)
m = mean(x)
1/m

M = c()
for (k in 1:50)
{
  X=rexp(10000,4)
  M = c(M,1/mean(X))
}
boxplot(M)

Z = rexp(50,2)
A = 3*Z + rnorm(50,0,1)
plot(Z, A)

L = lm(A~Z)
abline(L)
