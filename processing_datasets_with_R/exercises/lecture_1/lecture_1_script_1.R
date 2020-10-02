### PROCESSING LARGE DATASETS WITH R - LECTURE 1 ###

# slide 9
val1 <- 2*2
val2 <- 0.15 * 19.71
val3 <- exp(-2)
print(val1, val2, val3)

# slide 10
?t.test # works only in the console?
?max    # test

# slide 11
install.packages("dslabs")
library(dslabs)

# slide 14
a <- 1
a
print(a)

#slide 15
log(8)
help("log")
?log
args(log)
function(x, base=exp(1))
  
# slide 16
a <- 1
b <- 1
c <- 1
#(-b + sqrt(b^2 - 4*a*c))/(2*a)
#(-b + sqrt(b^2 - 4*a*c))/(2*a)

# slide 18
a <- 1
class(a)
print(a)

# slide 19
data(murders)
class(murders)

# slide 21
str(murders)
head(murders)
names(murders)
murders$population

#slide 22
class(murders$population)
length(murders$population)
class(murders$states)
class(murders$region)
levels(murders$region)

z <- 3 == 2
z
class(z)

# slide 23
mylist = list(name="Charles",age=28,married=TRUE)
mylist
out = t.test(1:10, y = c(7:20))
out

mylist$name #test
mylist["Charles"]
mylist

# slides 24
mat <- matrix(1:12, 4, 3)
mat[2,3]
mat[2,]
mat[,3]
mat[,2:3]
as.data.frame(mat)
mat

# slide 27
codes <- c(380, 124, 818)
country <- c("Italy", "Canada", "Egypt")
codes <- c(Italy = 380, Canada = 124, Egypt = 818)
class(codes)
names(codes)

# slide 28, 29, 30
seq(1,10)
codes[2]
codes[c(1,3)]
codes[1:2]

# slide 31, 32
x <- c(1,"canada",3)
x # defaults to String//character type
class(x)

x <- 1:5
y <- as.character(x)
y
as.numeric(y)

# slide 35
system.file(package="dslabs")
filename <- "murders.csv"
dir <- system.file("extdata", package = "dslabs")
fullpath <- file.path(dir,filename)

dir <- system.file(package="dslabs")
list.files(path=dir)
file.copy(fullpath, "murders.csv")

# slide 36
install.packages("readr")
library(readr)
install.packages("readxl")
library(readxl)
read_lines("murders.csv", n_max=3)
dat <- read_csv(filename)
head(dat)

# slides 38 - 46 TO DO
x <- dat$population / 10^6
y <- dat$total
plot(x,y)

plot(x,y, xlim=c(0,40), ylim=c(0,1300))
plot(x,y, xlim=c(0,40), ylim=c(0,1300), pch=19)
plot(x,y, xlim=c(0,40), ylim=c(0,1300), pch=19, 
     xlab="population", ylab="total", main="murder")
legend("bottomright",legend='my points',col=1,pch=19)

plot(x, y, xlim=c(0, 40), ylim=c(0,1300), pch=19, xlab="population", 
     ylab="total", main="Murder")
legend("bottomright", legend = 'my points',col=1,pch=19)
abline(a=0,b=30,lty=2, lwd=2,col='red')

x <- with(dat, total / population * 100000) 
hist(x)

dat$state[which.max(x)]

dat$rate <- with(dat, total / population * 100000) 
boxplot(rate~region, data = dat)

x = runif(100,0,1)
par(mfrow=c(1,2)) 
hist(x,breaks=2) 
hist(x,breaks=100)

x = c(rnorm(100,2,1),rgamma(50,shape = 1)) 
hist(x,freq = FALSE) 
f = density(x) 
lines(f,lwd=2,col='red',lty=2)

x = c(rnorm(100,2,1),rgamma(50,shape = 1)) 
qqnorm(x)

pie(summary(dat$region))

x<-dat[,4:6]
pairs(x)

x<-dat[,4:6]
pairs(x, col=as.numeric(dat$region), pch=as.numeric(dat$region))

# slide 50
f <- function(){
  ## This is an empty function
}
class(f)
f()

f <- function(){
  cat("Hello, world!\n")
}
f()

f <- function(num) {
  for(i in seq_len(num)){
    cat("Hello, World!\n")
  }
}
f(3)

f <- function(num) {
  hello <- "Hello, World!\n"
  for(i in seq_len(num)){
    cat(hello)
  }
  chars <- nchar(hello) * num
  chars
}
f(3)

# slide 53
str(rnorm)
my_data <- rnorm(100,2,1)

# slide 54, 55
f <- function(a, b){
  a^2
}
f(2)

f <- function(a,b){
  print(a)
  print(b)
}
f(45)
