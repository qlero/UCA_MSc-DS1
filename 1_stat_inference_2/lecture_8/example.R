data <- mtcars

y <- as.matrix(data[,1])
X <- as.matrix(data[,-1]) #to account for the intercept
dim(y)
dim(X)

res <- lm(mpg~., data = data)
res$coefficients

beta_ols <- as.matrix(res$coefficients)

#######

X <- cbind( 1, as.matrix(data[,-1])) #to account for the intercept
beta_hat <- solve(t(X) %*% X) %*% t(X) %*% y # %*% matmul