library(stats) 
#https://stat.ethz.ch/R-manual/R-devel/library/stats/html/00Index.html

A <- rexp(5000,4)
hist(A) # wrong
x=seq(0,10,0.01)
plot(x,dexp(x,4),type='l')
hist(A,freq=F)

#q quantile
#d density
#r random observations