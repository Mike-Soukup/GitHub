#R Lesson 9
df <- read.csv('/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Module 6/hot_dogs.csv',
               stringsAsFactors = TRUE)
#Problem 1
library(ggplot2)
#first plot boxplot of type of calories by type of hot dog
ggplot(df, aes(x = Type, y = Calories, fill = Type)) + 
  geom_boxplot()

boxplot(df$Calories ~ df$Type, data = df, xlab = "Type", ylab = "Calories",
        col = c('red','blue','pink'),
        main = 'Calories vs. Type of Hot Dog')

cal.means <- aggregate(df$Calories, by = list(df$Type), FUN = mean)
names(cal.means)[1] <- "Type"
names(cal.means)[2] <- "MeanCal"

beef.cal <- df$Calories[df$Type == "Beef"]
meat.cal <- df$Calories[df$Type == 'Meat']
poultry.cal <- df$Calories[df$Type == 'Poultry']

t.test(beef.cal, alternative = c("less"), mu = 140, conf.level = 0.95)
t.test(meat.cal, alternative = c("less"), mu = 140, conf.level = 0.95)
t.test(poultry.cal, alternative = c("less"), mu = 140, conf.level = 0.95)
#The poultry hot dog has average calories less than 140

#Problem 2
ggplot(df, aes(x = Type, y = Sodium, fill = Type)) + 
  geom_boxplot() + 
  geom_hline(yintercept = 425, linetype = "dashed", color = "red")

beef.na <- df$Sodium[df$Type == 'Beef']
meat.na <- df$Sodium[df$Type == 'Meat']
poultry.na <- df$Sodium[df$Type == 'Poultry']

t.test(beef.na, alternative = c("two.sided"), mu = 425, conf.level = 0.95)
t.test(meat.na, alternative = c("two.sided"), mu = 425, conf.level = 0.95)
t.test(poultry.na, alternative = c("two.sided"), mu = 425, conf.level = 0.95)

#Problem 3
x <- seq(from = 0, to = 50, length = 1000)
n <- length(beef.na)
df <- n-1
y <- dchisq(x, df = df)
plot(x,y,type = "l", lty = 1, col = 'blue')
abline(h = 0, lty = 1, col = 'black')
abline(v = 0, lty = 1, col = 'black')

#Find critical statistic value
crit.val <- qchisq(0.95, df = df)

beef.na.var <- var(beef.na)

test.stat <- ((n-1)*beef.na.var)/6000
test.stat

x <- seq(from = 0, to = 50, length = 1000)
n <- length(beef.na)
df <- n-1
y <- dchisq(x, df = df)
plot(x,y,type = "l", lty = 1, col = 'blue')
abline(h = 0, lty = 1, col = 'black')
abline(v = 0, lty = 1, col = 'black')
abline(v = crit.val, lty = 2, col = 'black')
abline(v = test.stat, lty = 2, col ='red')

#Problem 4
n <- 100
df <- n - 1
samp.mean <- 50
samp.sd <- 2
t.a <- (samp.mean - 56)/((samp.sd)/sqrt(n))
2*pt(t.a, df = df)
t.b <- (samp.mean - 40)/((samp.sd)/sqrt(n))
2*pt(t.b, df= df, lower.tail = FALSE)

#Problem 5
prop.test(x = 43, n = 100, p = 0.5, alternative = c("less"),
          conf.level = 0.95)
prop.test(x = 64, n = 100, p = 0.5, alternative = c("greater"),
          conf.level = 0.95)

#Problem 6
df1 <- read.csv("/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Module 6/salaries.csv",
                sep = ",", stringsAsFactors = TRUE)

n <- length(df1$AGE)

prop.test(x = 49, n = 60, p = 0.5, alternative = "less",
          conf.level = 0.95)

#Strong evidence to support the null hypothesis that atleast 50% of CEOs are 45 years old or older


prop.test(x = 17, n = 60, p = 0.05, alternative = "less",
          conf.level = 0.95)

