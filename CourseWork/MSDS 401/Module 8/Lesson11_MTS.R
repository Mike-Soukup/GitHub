tw <- read.csv("/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Module 8/tableware.csv")
################################################################################
#Problem 1
tw$TYPE <- factor(tw$TYPE)
str(tw)
type <- tw$TYPE
rate <- tw$RATE
df <- data.frame(type,rate)
#Examine the data
boxplot(rate ~ type)
#Test for equal variances within groups, assumption of One-Way ANOVA
bartlett.test(rate ~ type)
#Confirm results by looking at variances by type
aggregate(rate ~ type, data = df, FUN = var)

#Conduct One-Way ANOVA test
res <- aov(rate ~ type, data = df)
summary(res)

#P-value > 0.05, cannot reject the null hypothesis
#Now look at the confidence intervals of the differences

ag <- aggregate(rate ~ type, data = df, FUN = mean)

#
res <- aov(RATE ~ TYPE - 1, data = tw)
summary(res)
lm <- lm(RATE ~ TYPE - 1, data = tw)
summary(lm)
library(plyr)
RATEbyTYPE <- ddply(tw, "TYPE", summarize, RATE.mean = mean(RATE),
                    RATE.sd = sd(RATE), Length = NROW(RATE),
                    tfrac=qt(p=0.975, df = Length - 1),
                    Lower = RATE.mean - tfrac*RATE.sd/sqrt(Length),
                    Upper = RATE.mean + tfrac*RATE.sd/sqrt(Length))
RATEbyTYPE
library(ggplot2)
ggplot(RATEbyTYPE, aes(x = RATE.mean, y = TYPE)) + geom_point() +
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), height = .3) +
  ggtitle("Average Rate by TYPE")

#Repeat without - 1
res <- aov(RATE ~ TYPE, data = tw)
summary(res)
lm <- lm(RATE ~ TYPE, data = tw)
summary(lm)
RATEbyTYPE2 <- ddply(tw, "TYPE", summarize, RATE.mean = mean(RATE),
                     RATE.sd = sd(RATE), Length = NROW(RATE),
                     tfrac = qt(0.975, df = Length -1),
                     Lower = RATE.mean - tfrac*RATE.sd/sqrt(Length),
                     Upper = RATE.mean + tfrac*RATE.sd/sqrt(Length))
RATEbyTYPE2
ggplot(RATEbyTYPE2, aes(x = RATE.mean, y = TYPE)) + geom_point() +
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), height = .3) +
  ggtitle("Average Rate by TYPE")
################################################################################
#Problem 2
tw <- read.csv("/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Module 8/tableware.csv")
tw$TYPE <- factor(tw$TYPE)
res <- aov(PRICE ~ TYPE, data = tw)
summary(res)

library(plyr)

PRICEbyTYPE <- ddply(tw, "TYPE", summarize, PRICE.mean = mean(PRICE),
                     PRICE.sd = sd(PRICE), Length = NROW(PRICE),
                     tfrac = qt(0.975, df = Length -1),
                     Lower = PRICE.mean - tfrac*PRICE.sd/sqrt(Length),
                     Upper = PRICE.mean + tfrac*PRICE.sd/sqrt(Length))

PRICEbyTYPE

ggplot(data = PRICEbyTYPE, aes(x = PRICE.mean, y = TYPE)) + geom_point() +
  geom_errorbarh(aes(xmin = Lower, xmax = Upper), height = 0.3) + 
  ggtitle("Average PRICE by TYPE")
################################################################################
#Problem 3
hd <- read.csv("/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Module 8/hot_dogs.csv")
str(hd)
hd$Type <- factor(hd$Type)
str(hd)
par(mfrow = c(2,1))
boxplot(Calories ~ Type, data = hd, main ="hot_dogs.csv Calories vs. Type",
        col = c("red","brown","pink"), ylab = "Calories")
boxplot(Sodium ~ Type, data = hd, main = "hot_dogs.csv Sodium vs. Type",
        col = c("red","brown","pink", ylab = "Sodium"))
par(mfrow = c(1,1))

res.calories <- aov(Calories ~ Type, data = hd)
summary(res.calories)
res.sodium <- aov(Sodium ~ Type, data = hd)
summary(res.sodium)

#P-value for One Way ANOVA Calories ~ Type is less than 0.05, will need to look 
#at these means using Tukey's Honestly Significant Differences to see what types
#of meats are different

intervals <- TukeyHSD(res.calories, conf.level = 0.95)
intervals
plot(intervals)