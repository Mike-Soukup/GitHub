################################################################################
#Problem #1
x <- seq(from = -5, 5, length = 1000)
yn <- dt(x, df = 50)
yn.1 <- dt(x, df = 5)

plot(x,yn,type = 'l', col = 'blue')
lines(x, yn.1, col = 'red', lty = 2)

#Answer is True; See Text page 307 for written description, along with examples
#on pages 308 & 302 for the graphically representation of the image.
################################################################################
#Problem 2
qnorm(0.95, mean = 0, sd = 1)
crit.val.test <- c(2.052, 1.645, 2.576, 2.33)
p.val <- round(pnorm(crit.val.test, lower.tail = FALSE), digits = 4)
tab.2 <- cbind(crit.val.test, p.val)
tab.2
#Answer is 1.645
################################################################################
#Problem 3
#Option 1; prop.test
prop.test(x = 32, n = 62, conf.level = 0.95, correct = FALSE)
#Option 2; follow formula and create your own 95% CI
p.hat <- 32/62
q.hat <- 1-p.hat
n <- 62
z.val <- qnorm(1-0.025, mean = 0, sd = 1, lower.tail = TRUE)
er.marg <- z.val*sqrt((p.hat*q.hat)/n)
l.val <- p.hat - er.marg
u.val <- p.hat + er.marg
cat(sprintf('%.3f',l.val), "< p <", sprintf('%.3f', u.val))

#Answer is 0.392 < p < 0.641
################################################################################
#Problem 4
E <- 0.011
alpha <- 0.02
p <- 0.5
z <- qnorm(0.99, mean = 0, sd = 1, lower.tail = TRUE)
n <- ((z*p/E)^2)
paste0("The sample size required is ", round(n, digits = 0))

#The answer is 11182
################################################################################
#Problem 5

#Explore option A

x <- seq(from = -4, to = 4, length = 1000)
y <- dnorm(x)
plot(x,y, type = 'l', col = 'blue')

#Exploring option B
x <- seq(from = -5, to = 5, length = 1000)
y <- rt(n = 100000, df = 50)
y1 <- rnorm(n = 100000, mean = 0, sd = 1)
par(mfrow = c(2,3))
hist(y, col = 'blue', main = 't-dist')
boxplot(y, col = 'blue', main = 't-dist')
qqnorm(y, col = 'black')
qqline(y, col = 'red')
hist(y1, col = 'red', main = 'normal')
boxplot(y1, col = 'red', main = 'normal')
qqnorm(y1, col = 'black')
qqline(y1, col = 'red')
par(mfrow = c(1,1))


#Answer is B, A symmetric, heavy-tailed distribution cannot be detected using a
#boxplot and QQ chart, these types of distributions can be detected with these
#tools
################################################################################
#Problem 6

z.val <- qnorm(0.975)
sig <- 500
E <- 110
n <- (z.val*sig/E)^2
n
#Answer is 80
################################################################################
#Problem 7
n <- 20
m <- 13.8
s <- 3.9
point <- s^2

chi.lower <- qchisq(0.975, df = n-1)
chi.lower
chi.upper <- qchisq(0.025, df = n-1)
chi.upper

low.bound <- ((n-1)*s^2)/chi.lower
up.bound <- ((n-1)*s^2)/chi.upper

cat(sprintf('%.2f',low.bound)," < var < ",sprintf('%.2f', up.bound))

#Answer is (8.80 , 32.45)
################################################################################
#Problem 8
x.bar <- (67.3 + 65.7)/2
z.val.99 <- qnorm(0.995)
nn.up <- 67.3
n <- 144
s <- ((nn.up - x.bar)*sqrt(n))/z.val.99
s
z.val.95 <- qnorm(0.975)
marg.err <- (z.val.95)*(s/sqrt(n))
low.bound <- x.bar - marg.err
up.bound <- x.bar + marg.err
cat(sprintf("%.1f",low.bound),"< mu <",sprintf("%.1f",up.bound))

#Answer 65.9 < mu < 67.1
################################################################################
#Problem 9
#See Wikipedia of sampling distribution for numbers 5 and 9

#Answer is D, None of the above
################################################################################
#Problem 10
alpha.over2 <- pnorm(-1.63)
alpha.over2
p.val <- 2*alpha.over2
p.val

#Answer p-value = 0.1031; fail to reject the null hypothesis
################################################################################
