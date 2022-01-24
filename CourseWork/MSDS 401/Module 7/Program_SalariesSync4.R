# Demonstration R Code for PREDICT 401 Sync Session #4

setwd("C:/Users/Syamala.srinivasan/Google Drive/NorthWestern/LectureMaterialSummer2018MSDS401/RProjects")

#-------------------------consumer data ----------------------------------------------

mydata <- read.csv("ConsumerData.csv",head=TRUE, sep = ",", stringsAsFactors = TRUE)


mydata$RegionLab <- ifelse(mydata$Region  == 1,"NE",
                           ifelse(mydata$Region  == 2,"MW",
                                  ifelse(mydata$Region  == 3,"S",
                                         "W")))

mydata$LocationLab <- ifelse(mydata$Location  == 1,"Metro", "Outside")
newdata <- mydata[complete.cases(mydata), ]
newdata$Region <- NULL
newdata$Location <- NULL
str(newdata)


income <- newdata$AnnualHouseholdIncome
m1 <- mean(income)
std1 <- sd(income)
var1 <- var(income)

hist(newdata$AnnualHouseholdIncome, freq = FALSE, col = "darkblue", xlab = "AnnualHouseholdIncome", 
     main = "Distribution of AnnualHouseholdIncome")
curve(dnorm(x, mean = m1, sd = std1), col = "orange", lwd = 2, add = TRUE)
 
#------------------------------  Chapter 8 CI ----------------------------
# t-test to test the mean

?t.test
t.test(income, mu=60000)

qt(0.025,df=199)
qt(0.975,df=199)

t.test(income, alternative = "less", mu=60000)
qt(.05,df=199)

#pt(2.84,df=22)
#pchisq(36.72,df=7)

## ---------------------- Chap 9 Hypothesis testing -------------------

library(TeachingDemos)

#z.test(income, alternative = "less", mu = 60000, sd=15000, conf.level = 0.95)

## assumes population SD = $2,000 in order to generate the power curve

s <- seq(40000,65000,500)

plot(s, dnorm(s,55550, 2000), type="l", col='blue', lwd=2, main = "Blue NH and Red AH")
lines(s, dnorm(s,47000, 2000), col="red", lwd=2)
abline(v = 55550, col="blue", lwd=2)
abline(v = 47000, col="red", lwd=2)

plot(s, dnorm(s,55550, 2000), type="l", col='blue', lwd=2, main = "Blue NH and Red AH")
lines(s, dnorm(s,55000, 2000), col="red", lwd=2)
abline(v = 55500, col="blue", lwd=2)
abline(v = 55000, col="red", lwd=2)


altmean <- c(47000, 49000, 51000, 53000, 55000)
altmean.data <- data.frame(altmean)
altmean.data$beta <- 0

## note mean is $55,552 - NH: mean = $55,552, sigms = $2,000 xcrit lower tail value
xcrit <- qnorm(0.05, mean = mean(income), sd = 2000, lower.tail = TRUE, log.p = FALSE)
altmean.data$beta[5] <- pnorm(xcrit, mean=55000, sd=2000, lower.tail = FALSE, log.p = FALSE) ## type 2 error upper tail
altmean.data$beta[4] <- pnorm(xcrit, mean=53000, sd=2000, lower.tail = FALSE, log.p = FALSE)
altmean.data$beta[3] <- pnorm(xcrit, mean=51000, sd=2000, lower.tail = FALSE, log.p = FALSE)
altmean.data$beta[2] <- pnorm(xcrit, mean=49000, sd=2000, lower.tail = FALSE, log.p = FALSE)
altmean.data$beta[1] <- pnorm(xcrit, mean=47000, sd=2000, lower.tail = FALSE, log.p = FALSE)

altmean.data$power <- 1 - altmean.data$beta

plot(altmean.data$altmean,altmean.data$power,type="l", lwd=2, col="green",  main = "Power Curve")

plot(altmean.data$altmean,altmean.data$beta,type="l", lwd=2, col="green",  main = "Operating Characteristic Curve")




#-----------------------------------------------------------------------
# Chi-square test to test variance

require(EnvStats)
varTest(income,alternative="greater",conf.level = 0.95,sigma.squared = 100000000)##sigma=$10,000

require(EnvStats)
varTest(income,alternative="less",conf.level = 0.95,sigma.squared = 100000000)


#-----------------------------------------------------------------------------------------
require(moments)  # This package brings in skewness() and kurtosis().
require(asbio)  # This package does a Wilcox winsorization and returns the revised vector.

# salaries.csv data are salary differences between two comparable positions. 

salaries <- read.csv("salaries.csv",sep=" ",stringsAsFactors = TRUE)
str(salaries)

diff <- salaries[,1]  # Define the vector for analysis.
summary(diff)

hist(diff, col = "orange", main = "Histogram of Salary Differences", xlab = "Difference")
skewness(diff)
kurtosis(diff)

par(mfrow = c(1,2))
qqnorm(diff, col = "orange", pch = 16, main = "Differences Q-Q Plot")
qqline(diff, col = "blue")
boxplot(diff, col = "orange", main = "Differences Boxplot")
par(mfrow = c(1,1))

mu <- mean(diff)
sigma <- sd(diff)

#---------------------------------------------------------------
t.test(diff)

qt(.025,df=59)
#---------------------------------------------------------

#x <- seq(-1,10,by = 0.1)
#hist(diff, col = "orange", main = "Histogram of Salary Differences", xlab = "Difference", 
#     prob = T, ylim = c(0,0.4))
#curve(dnorm(x,mu,sigma), add = T, col = "blue", lwd = 2)
#abline(v = mu, col = "blue", lwd = 2)
#legend("topright", legend= c("mean = 4.21", "standard deviation = 1.73"))
#------------------------------------------------------------------------------------
#-------  t test with 20% trimmed mean ---------------------------------------------
library(MASS)
library(gld)
library(mvtnorm)
library(lattice)
library(ggplot2)
library(PairedData)
library(asbio)

yuen.t.test(diff, tr = 0.2, alternative = c("two.sided"), mu = 0)

#--------------------------------------------------------------------------------------------
# What follows is bootstrap resampling from the simple random sample.
#------------------------------------------------------------------------------------------

N <- 10^4  # This is the number of resamples drawn.

# Define vectors for storage purposes.
my.tr.mean <-numeric(N)
my.mean <- numeric(N)
my.tval <- numeric(N)
my.tr.tval <- numeric(N)

# mean values for later calculations
mu <- mean(diff)
tmu <- mean(diff, trim = 0.2) ## 20% on both ends
tmu

diff2 <- sort(diff, decreasing = FALSE)
diffsub <- diff2[13:48]
mean(diffsub)

# needed for computing standard deviations
n <- length(diff)
h <- 0.6*sqrt(n)

## winsorization means outliers are 'trimmed'
??win


#x <- c(0.001,0.002, 1, 2, 2.2, 2.4, 4, 5, 6, 7, 15, 17)
#x
#win(x) ## default is 20% on each end

sort(diff)
win <- as.data.frame(win(diff))
win
sort(win$`win(diff)`)


for (i in 1:N)
{
  x <- sample(diff, n, replace = TRUE)
  my.mean[i] <- mean(x)
  my.tval[i] <- (mean(x)-mu)/(sd(x)/sqrt(n))    # untrimmed mean t value
  my.tr.mean[i] <- mean(x, trim = 0.2)
  std <- sd(win(x))
  my.tr.tval[i] <- (mean(x, trim = 0.2)-tmu)/(std/h)  # trimmed mean t value
}

Simuldata <- data.frame(my.mean, my.tval, my.tr.mean, my.tr.tval)

# Comparison of trimmed and untrimmed variability.

par( mfrow = c(2,2))
cells <- seq(from = 3.0,to = 5.5, by = 0.1)
hist(my.mean, breaks = cells, main = "Bootstrap distribution of untrimmed mean values", col = "blue")
abline(v= quantile(my.mean, probs = 0.025),col = "green", lty = 2, lwd = 2)
abline(v= quantile(my.mean, probs = 0.975),col = "green", lty = 2, lwd = 2)

cells <- seq(from = -6.0, to = 6, by = 0.5)
hist(my.tval, breaks = cells, main = "Bootstrap distribution of untrimmed t_statistic", col = "blue")
abline(v = quantile(my.tval, probs = 0.025), col = "green", lty = 2, lwd = 2)  
abline(v = quantile(my.tval, probs = 0.975), col = "green", lty = 2, lwd = 2)

cells <- seq(from = 3.0,to = 5.5, by = 0.1)
hist(my.tr.mean, breaks = cells, main = "Bootstrap distribution of trimmed mean values", col = "red")
abline(v= quantile(my.tr.mean, probs = 0.025),col = "green", lty = 2, lwd = 2)
abline(v= quantile(my.tr.mean, probs = 0.975),col = "green", lty = 2, lwd = 2)

cells <- seq(from = -6.0, to = 6, by = 0.5)
hist(my.tr.tval, breaks = cells, main = "Bootstrap distribution of trimmed t_statistic", col = "red")
abline(v = quantile(my.tr.tval, probs = 0.025), col = "green", lty = 2, lwd = 2)  
abline(v = quantile(my.tr.tval, probs = 0.975), col = "green", lty = 2, lwd = 2)
par( mfrow = c(1,1))


#----------------------------------------------------------------------
# Evaluate performance of percentile bootstrap on untrimmed means.
round(quantile(my.mean, prob = c(0.025,0.975)), digits = 3)

#----------------------------------------------------------------------
# Evaluate performance of bootstrap on untrimmed means - same as above
#Q1 <- quantile(my.tval, prob = c(0.025), names = FALSE)
#Q2 <- quantile(my.tval, prob = c(0.975), names = FALSE)
#round(mu - Q2*(sd(diff)/sqrt(n)), digits = 3)
#round(mu - Q1*(sd(diff)/sqrt(n)), digits = 3)
#--------------------------------------------------------------------------
t.test(diff)

#----------------------------------------------------------------------
# Percentile bootstrapping on trimmed mean confidence interval.
round(quantile(my.tr.mean, prob = c(0.025,0.975)), digits = 3)

yuen.t.test(diff, tr = 0.2, alternative = c("two.sided"), mu = 0)
#----------------------------------------------------------------------
# Determine a two-sided confidence interval using trimmed bootstrap t distribution.same as above.
#Q1 <- quantile(my.tr.tval, prob = c(0.025), names = FALSE)
#Q2 <- quantile(my.tr.tval, prob = c(0.975), names = FALSE)
#round(tmu - Q2*(std/h), digits = 3)
#round(tmu - Q1*(std/h), digits = 3)

#-----------------------------------------------------------------------
# Theoretical trimmed mean confidence interval.
n <- length(diff)
h <- 0.6*sqrt(n)
df <- n - (2*4) - 1  ## df = n - 2k -1 where k = num of observations trimmed =4 (2 on each side)
c <- qt(0.975, df, lower.tail = TRUE)
std <- sd(win(diff, lambda = 0.2))
E <- c*std/h
round(mean(diff, trim = 0.2)-E, digits = 3)
round(mean(diff, trim = 0.2)+E, digits = 3)

#----------------------------------------------------------------------
#-----------------------------------------------------------------------

# The distributions are comparable.  The difference in the confidence intervals which result
# is a result of the difference in the variability of the mean versus the untrimmed mean.
#((sd(diff)/sqrt(n))/(std/h))^2  # Approximate amount the sample size would need to increase.

#sigma <- (std/h)*sqrt(50)

#------------------------------------------------------------------------------------------


#------------------------- Chap 16 ----------------------------------
# Chi-square test to test independence for 2 categorical vaiables

library(MASS)
tbl = table(newdata$RegionLab) 
tbl 
chisq.test(tbl, p = c(1/4, 1/4, 1/4, 1/4))

tbl = table(newdata$RegionLab, newdata$LocationLab) 
tbl                 # the contingency table 
chisq.test(tbl)

#-----------------------------------------------------------------------------------
