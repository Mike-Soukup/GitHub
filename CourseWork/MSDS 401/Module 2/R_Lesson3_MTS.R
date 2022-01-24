#First need to load in mileage, shoppers, pontus, and geyser data
mileage <- read.csv('/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Lessons in R_Complete/Lessons in R_Data Files/mileage.csv',
                    sep = ",")
shoppers <- read.csv('/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Lessons in R_Complete/Lessons in R_Data Files/shoppers.csv',
                     sep = ",")
pontus <- read.csv('/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Lessons in R_Complete/Lessons in R_Data Files/pontus.csv',
                   sep = ",")
geyser <- read.csv('/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Lessons in R_Complete/Lessons in R_Data Files/geyser.csv',
                   sep = ",")

str(mileage)

ex_1a <- aggregate(mileage$MPG, by = list(mileage$WT), mean)
colnames(ex_1a) <- c("WT","MPG")
ex_1b <- aggregate(mileage$MPG, by = list(mileage$WT), sd)
colnames(ex_1b) <- c("WT","MPG")
round(ex_1a, digits = 2)
round(ex_1b, digits = 2)

mpg_class <- aggregate(MPG ~ CLASS, mileage, mean)
mpg_class
r_agg <- round(mpg_class$MPG, digits = 2)
mpg_class[,2] <- r_agg
mpg_class

mpg_class$SD <- round(aggregate(MPG ~ CLASS, mileage, sd)[,2], digits = 2)
mpg_class

hp_class <- aggregate(HP ~ CLASS, mileage, mean)
hp_class
hp_class$SD <- aggregate(HP ~ CLASS, mileage, sd)[,2]
hp_class

str(shoppers)
mean(shoppers$Spending)
median(shoppers$Spending, type = 2)
range(shoppers$Spending)
max(shoppers$Spending) - min(shoppers$Spending)
sd(shoppers$Spending)
var(shoppers$Spending)
summary(shoppers$Spending)
qnts <- c(0,0.1,0.25,0.5,0.75) 
quantile(shoppers$Spending, probs = qnts)
hist(shoppers$Spending)

range1 <- function(x){
  max(x, na.rm = TRUE) - min(x, na.rm = TRUE)
}

sum_stats <- function(x){
  stats <- data.frame(rbind(mean(x, na.rm = TRUE),
          median(x, na.rm = TRUE, type = 2),
          range1(x),
          sd(x, na.rm = TRUE),
          var(x, na.rm = TRUE),
          quantile(x, probs = c(0.25), na.rm = TRUE),
          quantile(x, probs = c(0.75), na.rm = TRUE),
          quantile(x, probs = c(0.10), na.rm = TRUE)),
  row.names = c("Mean","Median","Range","SD","Variance",
                "Q1","Q3","P10"))
  colnames(stats) <- "Value"
  return(stats)
}

sum_stats(shoppers$Spending)

str(pontus)
potus_age <- pontus$Age
sum_stats(potus_age)
potus_ht <- pontus$Ht
ht <- sum_stats(potus_ht)
potus_OppHt <- pontus$HtOpp
#sum_stats(potus_OppHt)
ht$opp_ht<- sum_stats(potus_OppHt)

colnames(ht) <- c("Potus","opp")
ht

apply(pontus[,c("Ht","HtOpp")],2,sum_stats)

p_v_o_dff <- pontus[,c("Ht")] - pontus[,c("HtOpp")]
p_v_o_dff

hist(p_v_o_dff)
boxplot(p_v_o_dff)

summary(geyser$WEEK1)
summary(geyser$WEEK2)
par(mfrow = c(2,1))
hist(geyser$WEEK1)
hist(geyser$WEEK2)
par(mfrow = c(1,1))
boxplot(geyser$WEEK1, geyser$WEEK2, names = c("Week 1", "Week 2"))

apply(geyser,2,summary)

par(mfrow = c(2,2))
hist(geyser$WEEK1)
hist(geyser$WEEK2)
boxplot(geyser$WEEK1)
boxplot(geyser$WEEK2)
par(mfrow = c(1,1))