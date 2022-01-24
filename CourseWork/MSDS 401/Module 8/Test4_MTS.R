#Test #4 Work
################################################################################
#Problem 1

#From Course Hero: The problem statement is the intro to another problem..

#True
################################################################################
#Problem 2
n1 <- 100
x1 <- 39
n2 <- 100
x2 <- 49
zc <- qnorm(.95, mean = 0, sd = 1)
p1 <- x1/n1
p2 <- x2/n2
p.bar <- (x1+x2)/(n1+n2)
q.bar <- 1-p.bar
z.test <- (p2 - p1)/sqrt((p.bar*q.bar)*((1/n1)+(1/n2)))

x <- matrix(c(39,61,49,51),nrow = 2, ncol = 2, byrow = TRUE)

prop.test(x,alternative = c("two.sided"), conf.level = 0.90,
          correct = FALSE)
p.val <- 2*(pnorm(-1.425, mean = 0, sd = 1))
cat("z-value:", z.test, "\np-value:",p.val,
    "\nconclusion: Statistically not signficant")

#Answer is B
################################################################################
#Problem 3
X.n <- 35
X.m <- 19.4
X.s <- 1.4
s1.2 <- X.s^2

Y.n <- 40
Y.m <- 15.1
Y.s <- 1.3
s2.2 <- Y.s^2
#variances are unknown, so we must use the t.test

df <- X.n + Y.n - 2

t.val <- qt(0.975, df = df)

point.diff <- X.m - Y.m

root.1 <- sqrt(((s1.2*(X.n - 1)) + s2.2*(Y.n - 1))/(X.n + Y.n - 2))
root.2 <- sqrt((1/X.n)+(1/Y.n))
lower <- point.diff - (t.val)*(root.1)*(root.2)
upper <- point.diff + (t.val)*(root.1)*(root.2)

cat(round(lower, digits = 1),"< mu.x - mu.y <",round(upper, digits = 1))
################################################################################
#Problem 4
d.m <- 3.0
d.s <- 2.114
n <- 15
df <- n - 1
d.bar <- 3.0
d.sd <- 2.114
t.val <- qt(0.975, df = 14)
lower <- d.bar - (t.val*(d.sd/sqrt(n)))
upper <- d.bar + (t.val*(d.sd/sqrt(n)))
cat(lower,"< mu.d <",upper)

################################################################################
#Problem 5

#One-Way ANOVA assumptions
# 1. Observations are drawn from normally distributed populations
# 2. Observations represent random samples from the populations
# 3. Variances of the populations are equal

#False; This statement says that the populations have UNEQUAL variances

################################################################################
#Problem 6
qf(0.95, 3, 16)

cat("Critical F-value is",qf(0.95, 3, 16))

#Remember that the F distribution is a ratio of variances. As a result,
#It is one sided
################################################################################
#Problem 7
n1 <- 13
s1 <- 2.0
s1.2 <- s1^2
df1 <- n1 - 1
n2 <- 16
s2 <- 1.1
s2.2 <- s2^2
df2 <- n2 - 1

F.test <- s1.2/s2.2
print(F.test)

p.val <- pf(F.test, df1 = df1, df2 = df2, lower.tail = FALSE)

0.05 <= p.val & p.val < 0.1
0.025 <= p.val & p.val < 0.05
0.01 <= p.val & p.val < 0.025
0.005 <= p.val & p.val < 0.01

#Answer is 0.01 <= p-value < 0.025
################################################################################
#Problem 8

M <- matrix(nrow = 3, ncol = 4)
header <- c("df","SS","MS-SS/df","F-statistic")
rows <- c("Treatment","Error","Total")
colnames(M) <- header
rownames(M) <- rows
df <- c(5,26,31)
SS <- c(22.2, 104.0, 126.2)
M[,1] <- df
M[,2] <- SS
MS <- c(4.44, 4)
M[1:2,3] <- MS
M[1,4] <- 1.11
M

#Answer is A; print matrix above to confirm
################################################################################
#Problem 9
Reg.r <- function(df){
  colnames(df) <- c("x","y")
  df$x_2 <- df$x^2
  df$y_2 <- df$y^2
  df$xy <- df$x*df$y
  n <- nrow(df)
  s.x <- sum(df$x)
  s.y <- sum(df$y)
  s.x2 <- sum(df$x_2)
  s.y2 <- sum(df$y_2)
  s.xy <- sum(df$xy)
  r <- (s.xy - ((s.x*s.y)/n))/sqrt((s.x2-((s.x^2)/n))*(s.y2-((s.y^2)/n)))
  return(r)
}  

RegAnal <- function(df){
  colnames(df) <- c("x","y")
  df$x_2 <- df$x^2
  df$y_2 <- df$y^2
  df$xy <- df$x*df$y
  n <- nrow(df)
  s.x <- sum(df$x)
  s.y <- sum(df$y)
  s.x2 <- sum(df$x_2)
  s.y2 <- sum(df$y_2)
  s.xy <- sum(df$xy)
  r <- Reg.r(df)
  b1 <- (s.xy-((s.x*s.y)/n))/(s.x2-((s.x^2)/n))
  b0 <- (s.y/n)-(b1)*(s.x/n)
  mat <- matrix(ncol = 3, nrow = 1)
  out <- c(r, b0, b1)
  mat[1,] <- out
  colnames(mat) <- c("r","b0","b1")
  plot(x = df$x, y = df$y)
  return(mat)
}

x <- c(2,5,8,10,12)
y <- c(7,11,13,20,24)
df <- data.frame(x,y)

A <- RegAnal(df)

cat("yhat = ",round(A[2],digits = 2),"+",
    round(A[3], digits = 2),"x")


#yhat = 2.59 + 1.68x
################################################################################
#Problem 10

#False, r-squared would be -0.8443^2 = 0.7128, not just the absolute value of r
################################################################################
