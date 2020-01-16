
## simulate some data
k = 50
n = 1000000
mu_0 <- rep(5,k)
sigma_sq <- rinvgamma(1,1)
X <- cbind(1, mvrnorm(n, mu_0, diag(sqrt(sigma_sq), nrow = k, ncol = k)))
p = ncol(X)
beta_0 <- mvrnorm(1, rep(0,p), diag(1, nrow = p, ncol = p))
beta_0
y <- X %*% beta_0 + rnorm(n)

library(microbenchmark)
microbenchmark(
  0.5 * t(y - X %*% beta_0) %*% (y - X %*% beta_0),
  0.5 * sum((y - X %*% beta_0)^2)
)

all.equal(
  c(0.5 * t(y - X %*% beta_0) %*% (y - X%*%beta_0)),
  0.5 * sum((y - X %*% beta_0)^2)
)

## we learn which code is faster but they return the same output 
## -- we prefer the faster version