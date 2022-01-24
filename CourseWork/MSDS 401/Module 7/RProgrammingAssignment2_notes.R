################################################################################
#Problem 1
x <- seq(from = 0, to = 10, by = 1)
y <- dbinom(x, size = 100, prob = 0.05)
y1 <- dpois(x, lambda = 5)
plot(x,y,type = 'b', lty = 1, col = "blue", ylab = "Probability",
     xlab = "Outcome")
lines(x,y1, type = 'b', lty = 2, col = "red")
legend("topleft", legend = c("Binomial","Poisson"), col = c("blue", "red"), lty = 1:2,
       cex = 0.8)
y[1]
y1[1]