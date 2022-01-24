# Exercise 1
p <- 1/6
n <- 4
q <- (1-p)

#first let's look at the binionmial distribution of success here:
x <- c(0:4)
y <- dbinom(x,n,p)
plot(x,y, type = 'h', main = "Binomial Distribution Horse Races")
hist(x, freq = y, main = "Binomial Distribution Horse Races")
#part i
p.i <- dbinom(4,n,p)
p.i
sprintf("%.4f",p.i)
#part ii
p.ii <- dbinom(4,n,q)
p.ii
sprintf("%.4f",p.ii)
#part iii
p.iii <- dbinom(1,n,p)
p.iii
sprintf("%.4f",p.iii)
#part iv
p.iv <- 1 - dbinom(0,n,p)
p.iv
sprintf("%.4f",p.iv)
#Exercise 2
p <- 0.5
n <- 20
x <- c(0:20)
y <- dbinom(x,n,p)
par(mfrow = c(2,1))
plot(x,y,type='h',main = 'Tea Bag and Cream')
points(x,y)
plot(x,pbinom(x,n,p),type = 'h', main = 'CDF')
points(x,pbinom(x,n,p))
par(mfrow = c(1,1))
p.2.i <- 1 - pbinom(15,n,p)
sprintf("%.4f",p.2.i)
#Exercise 2 part ii
target_p_value <- 0.05
current_p_value <- 1.00
n <- 0 # number of cups
while (current_p_value > target_p_value) {
  n <- n + 2
  current_p_value <- pbinom(q = n-1, size = n, prob = 0.5, lower.tail = FALSE)
  cat("\n Number of Consecutive Cups Correctly Identified:", n, "p_value: ",
      sprintf("%.4f",current_p_value))
}
cat("\n\nLady Tasting Tea Solution: ", n, "Consecutive Cups Correctly Labeled",
    "\n p-value: ", sprintf("%.4f", current_p_value),"<= 0.05 critical value")

#Exercise 3
x <- c(0:20)
y <- dpois(x,lambda = 4.6)
plot(x,y,type = 'h', main = 'Probability of n Serious Accidents per Night')
axis(at = x)
points(x,y,pch = 16, cex = 1)

#Create table of outputs
for (i in 1:21){
  cat("\n X-value: ",x[i],"Poission Distribution Value: ",sprintf("%.4f",y[i]),
      "Cummulative Value: ",sprintf("%.4f",ppois(x[i], lambda = 4.6)))
}
#Exercise 4
#Binomial
p <- 0.001
n <- 100
x <- c(0:4)
y <- dbinom(x,n,p)
for (i in 1:5){
  cat("\n X- value: ",x[i], "Binomial Probability: ",sprintf("%.6f",y[i]))
}

lambda <- n*p
z <- dpois(x,lambda = lambda)

for (i in 1:5){
  cat("\n X- value: ",x[i], "Poission Probability: ",sprintf("%.6f",z[i]))
}
par(mfrow = c(2,1))
plot(x,y,type = 'h', main = ' Binomial Probability of a random defect')
points(x,y,pch = 16, cex = 1)
plot(x,z,type = 'h', main ='Poission Probability of a random defect')
points(x,z,pch = 16, cex = 1)
par(mfrow = c(1,1))