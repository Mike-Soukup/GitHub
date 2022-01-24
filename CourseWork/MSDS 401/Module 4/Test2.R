#Test #2 Work
################################################################################
#Problem 1
lambda <- 2
#P(X > 4 | Poisson w/ lambda = 2)
#First let's show the probability plot
par(mfrow = c(1,1))
x <- seq(from = 0, to = 10, by = 1)
y <- dpois(x, lambda = lambda)
plot(x,y,col = 'blue', type = 'h', ylab = "probability", xlab = 'value',
     main = 'Poisson Distribution with Lambda = 2')
abline(v = 4.5, col = 'red', lty = 2)
#Option 1
ans.1a <- 1 - sum(dpois(seq(from = 0, to = 4, by = 1), lambda = lambda))
cat("P(X > 4 | Poisson w/ lambda = 2) = ",sprintf("%.4f",ans.1a))
#Option 2
ans.1b <- 1 - ppois(4, lambda = lambda)
cat("P(X > 4 | Poisson w/ lambda = 2) = ",sprintf("%.4f",ans.1b))
#Option 3 - Look up in Poisson Table
ans.1c <- 0.0361 + 0.0120 + 0.0034 + 0.0009 + 0.0002
cat("P(X > 4 | Poisson w/ lambda = 2) = ",sprintf("%.4f",ans.1c))

#The answer is 0.0527
################################################################################
#Problem 2
disease <- matrix(c(0.942,0.058,0.041,0.939), ncol = 2, byrow = TRUE)
colnames(disease) <- c("D'", "D")
rownames(disease) <- c("Pop with Disease", "Pop Test +")
disease <- as.table(disease)
disease

#re-do to validate

#Ans is 0.585
################################################################################
#Problem 3
x <- c(0,1,2,3)
y <- c(0.749,0.225,0.024,0.002)
plot(x,y,type = 'h')

#Expected Value
ex.val <- sum(x*y)
cat("The expected value is: ",sprintf("%.2f",ex.val))

ex.var <- sum(((x - ex.val)^2)*y)

cat("The variance is: ",sprintf("%.2f",ex.var))

#The answer is mean = 0.28 and variance = 0.26
################################################################################
#Problem 4
data.4 <- c(1.3,2.2,2.7,3.1,3.3,3.7)
round(quantile(data.4, probs = 0.33, type = 7), digits = 2)

#Answer is 2.53
quantile(data.4)
################################################################################
#Problem 5
mn <- 8.4
s.d <- 1.8
n <- 36
mn.x <- mn
s.d.x <- s.d / sqrt(n)

x.5 <- seq(from = 6, to = 10, length = 1000)
y.5 <- dnorm(x.5, mean = mn.x, sd = s.d.x)
plot(x.5, y.5, col = 'black', type = 'l')
abline(v = 8.7, col = 'red', lty = 2)
abline(v= 8.4, col = 'blue', lty = 5)


ans.5 <- 1 - pnorm(8.7, mean = mn.x, sd = s.d.x)
cat("Answer is:",sprintf("%.3f",ans.5))
#Answer is 0.159
################################################################################
#Problem 6
#Figure out what our answer should be close to:

n <- 76
p <- 0.7
q <- 0.3

ans.6.app <- dbinom(x = 50, size = 76, prob = 0.7)

mn.6 <- n*p
s.d.6 <- sqrt(n*p*q)

x.6 <- seq(from = 41, to = 65, length = 10000)
y.6 <- dnorm(x.6,mean = mn.6, sd = s.d.6)
plot(x.6,y.6, type = 'l', lty = 1, lwd = 1, col = 'blue')
abline(v = 49.5, col = 'red', lty = 5)
abline(v = 50.5, col = 'red', lty = 5)

ans.6 <- pnorm(50.5, mean = mn.6, sd = s.d.6) - pnorm(49.5, mean = mn.6, sd = s.d.6)
cat("Actual probability is:", sprintf("%.4f",ans.6.app))
cat("Answer is: ",sprintf("%.4f",ans.6))

#Answer is 0.0724

mn.6 + 3*s.d.6
mn.6 - 3*s.d.6
################################################################################
#Problem 7
#answer is the area to the left of 47.5
################################################################################
#Problem 8
mn.8 <- 1050
s.d.8 <- 225

x.8 <- seq(from = 300, to = 1800, length = 10000)
y.8 <- pnorm(x.8, mean = mn.8, sd = s.d.8)
plot(x.8, y.8, col = 'blue', type = 'l')
abline(h=0.45, col = 'red', type = 'l', lty = 4)
p.45 <- x.8[which(abs(y.8 - 0.45) < 0.0001)]
abline(v = p.45, col = 'red', lty = 3)
cat("The answer is:",sprintf("%.1f",p.45))

chk <- pnorm(1021.7, mean = mn.8, sd = s.d.8)
cat("Check Cum Prob:",sprintf("%.4f",chk))

#Answer is 1021.7
################################################################################
#Problem 9
#option A
#Treat as a binominal problem

#Probability a drink is selected as the favorite
p.9 <- 1/3
#Number of random options
n <- 5
#Look at the binomial distribution for this function
x <- seq(from = 0, to = 5, by = 1)
y <- dbinom(x, size = n, prob = p.9)
plot(x,y, type = 'h')

ans.9a <- 3*(dbinom(5,size = n, prob = p.9))
cat("First attempt gives:",sprintf("%.5f",ans.9a))

#Total number of choices
tot.choices <- 3^5
ans.9b <- 3/tot.choices
cat("Second attempt gives:",sprintf("%.5f",ans.9b))

#Answer is 0.01235
################################################################################
#Problem 10
x.10 <- 0
m <- 10
n <- 40
k <- 3
ans.10 <- dhyper(x.10, m = m, n = n, k = k)
cat("First ans:",sprintf("%.4f", ans.10))

ans.10b <- (dim(combn(10,0))[2]*dim(combn(40,3))[2])/dim(combn(50,3))[2]
cat("Second ans:",sprintf("%.4f", ans.10b))


#Answer is 0.5041

x <- seq(from = 0, to = 3, by = 1)
y <- dhyper(x, m = m, n = n, k = 3)
plot(x,y,type = 'h')

zscore <- function(x,m,s){
  return((x-m)/s)
}