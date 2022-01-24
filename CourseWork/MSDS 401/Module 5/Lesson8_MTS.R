n <- 100
var <- 1
stnd <- sqrt(var)
x.bar <- 50
set.seed(123)
x <- rnorm(100, mean  = 50, sd = 1)
mean(x)
z.val <- qnorm(.975)
ans.1 <- c(signif(x.bar - (z.val*stnd/sqrt(n)),digits = 5), signif(x.bar + (z.val*stnd/sqrt(n)),digits = 5))
ans.1

#Ex 2
sd <- 100
vr <- sd^2
E <- 4
z.val <- qnorm(.975)

n <- ((z.val^2)*(sd^2))/(E^2)
cat("Sample size is",round(n,digits = 0))

#Ex 3
n <- 1600
p.hat <- 0.6
q.hat <- 0.4
z.val <- qnorm(.975)
mar.of.error <- z.val*sqrt((p.hat*q.hat)/n)
c(signif(p.hat - mar.of.error,digits = 8), signif(p.hat + mar.of.error, digits = 8))

#Ex 3 further
#Use a built in R function to test a proportion
prop.test(x = 1600*0.6, n = 1600, alternative = "two.sided", conf.level = 0.95)
prop_test_object <- prop.test(x = 1600*0.6, n = 1600, alternative = "two.sided", conf.level = 0.95)
print(str(prop_test_object))
str(as.numeric(prop_test_object$conf.int))

#Ex 4
p.hat <- 0.85
q.hat <- 0.15
E <- 0.01
z.val <- qnorm(.975)
n <- ((z.val**2)*(p.hat)*q.hat)/(E**2)
n
p <- 0.85
z_score <- qnorm(0.025, mean = 0, sd = 1, lower.tail = FALSE) 
sample_size <- (z_score**2)*p*(1-p)/(0.01)**2 
round(sample_size)
z_score

sample_size <- (z.val^2)*(.25)/(E^2)

sample_size
#Hot Dogs Analysis
rm(list = ls())
library(ggplot2)
hd <- read.csv("/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Module 5/hot_dogs.csv",sep = ",")
str(hd)

hd$Type <- factor(hd$Type)
str(hd)
summary(hd$Type)

#Subset the data
Beef.Calories <- hd$Calories[which(hd$Type == 'Beef')]
Meat.Calories <- hd$Calories[which(hd$Type == 'Meat')]
Poultry.Calories <- hd$Calories[which(hd$Type == 'Poultry')]

#Construct Boxplots
par(mfrow = c(1,3))
boxplot(Beef.Calories, col = 'red',main = 'Boxplot of Beef Calorie Hotdogs')
boxplot(Meat.Calories, col = 'brown', main = 'Boxplot of Meat Calorie Hotdogs', add = TRUE)
boxplot(Poultry.Calories, col = 'pink', main = 'Boxplot of Poultry Calorie Hotdogs', add = TRUE)
par(mfrow = c(1,1))

ggplot(data = hd, aes(x = Type, y = Calories, fill = Type)) +
  geom_boxplot()+
  labs(title = "Boxplot of Calories vs. Hot Dog Type")

confidence_t <- function(data, level){
  x.bar <- mean(data)
  s <- sd(data)
  n <- length(data)
  df <- n - 1
  t.val <- qt(1-(level/2), df = df)
  ans <- c(x.bar - t.val*(s/sqrt(n)),x.bar + t.val*(s/sqrt(n)))
  return(ans)
}
beef.ci <- confidence_t(Beef.Calories, level = 0.05)
meat.ci <- confidence_t(Meat.Calories, level = 0.05)
poultry.ci <- confidence_t(Poultry.Calories, level = 0.05)

cat("Beef Calories Mean 95% Confidence Interval", beef.ci)
cat("Meat Calories Mean 95% Confidence Interval", meat.ci)
cat("Poultry Calories Mean 95% Confidence Interval", poultry.ci)

#Alternative Approach
with(hd, boxplot(Calories ~ Type, main = "Caloires, by hotdog type", ylab = "Calories",
                 col = c("red", "brown", "pink")))
beef <- subset(hd, subset = (Type == "Beef"))
meat <- subset(hd, subset = (Type == "Meat"))
poultry <- subset(hd, subset = (Type == "Poultry"))
str(Beef.Calories)
str(beef)
with(beef, t.test(Calories)$conf.int)
with(meat, t.test(Calories)$conf.int)
with(poultry, t.test(Calories)$conf.int)

# 99% cone-sided lower confidence intervals
confidence_lower <- function(data, level){
  x.bar <- mean(data)
  s <- sd(data)
  n <- length(data)
  df <- n - 1
  t.val <- qt(1-level, df = df)
  ans <- c(x.bar - t.val*(s/sqrt(n)))
  return(ans)
}

beef.99lower <- confidence_lower(Beef.Calories, level = 0.01)
meat.99lower <- confidence_lower(Meat.Calories, level = 0.01)
poultry.99lower <- confidence_lower(Poultry.Calories, level = 0.01)

cat("Beef Calories Mean 99% Lower Confidence Interval", beef.99lower)
cat("Meat Calories Mean 99% Lower Confidence Interval", meat.99lower)
cat("Poultry Calories Mean 99% Lower Confidence Interval", poultry.99lower)

with(beef, t.test(Calories, alternative = c("greater"), conf.level = 0.99)$conf.int)
with(meat, t.test(Calories, alternative = c("greater"), conf.level = 0.99)$conf.int)
with(poultry, t.test(Calories, alternative = c("greater"), conf.level = 0.99)$conf.int)

#Part 2
chi_sq_confidence <- function(data, level){
  n <- length(data)
  df <- n - 1
  stnd <- sd(data)
  up.chi <- qchisq(1-(level/2), df = df, lower.tail = TRUE)
  low.chi <- qchisq(level/2, df = df, lower.tail = TRUE)
  ans <- c((df*(stnd^2))/up.chi,(df*(stnd^2))/low.chi)
  return(ans)
}
beef.ci.var <- chi_sq_confidence(Beef.Calories, level = 0.05)
meat.ci.var <- chi_sq_confidence(Meat.Calories, level = 0.05)
poultry.ci.var <- chi_sq_confidence(Poultry.Calories, level = 0.05)
