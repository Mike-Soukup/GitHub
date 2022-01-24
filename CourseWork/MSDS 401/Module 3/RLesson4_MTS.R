#Start by reading in the shoppers data
shoppers <- read.csv('/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Module 3/shoppers.csv')

#Assume fifty shoppers exit the store individually in random order.

#If one shopper is picked at random, what is the probability of picking a shopper
#who spent $40 or more and the probability of a shopper who picked less than $10

shoppers.sort <- sort(shoppers$Spending,decreasing = FALSE)
N <- length(shoppers.sort)
forty.and.over <- shoppers.sort[shoppers.sort >= 40]
forty.and.over
p.forty.and.over <- length(forty.and.over)/N
p.forty.and.over
less.than.ten <- shoppers.sort[shoppers.sort < 10]
p.less.than.ten <- length(less.than.ten)/N
p.less.than.ten

#Alternative option
table(shoppers$Spending >= 40)
sum(shoppers$Spending >= 40)/nrow(shoppers)

table(shoppers$Spending < 10)
sum(shoppers$Spending < 10)/nrow(shoppers)

#Part B
dem <- dim(combn(50,2))[2]

nm <- sum(shoppers$Spending >= 40)*sum(shoppers$Spending < 10)
nm/dem

#Part C
table(shoppers$Spending >= 10 & shoppers$Spending <= 40)
nm_c <- dim(combn(37,2))[2]
nm_c/dem

#OR
(37/50)*(36/49)

#Part D
dem_d <- dim(combn(50,4))[2]
num_d <- sum(shoppers$Spending < 10)*sum(shoppers$Spending >= 40)*dim(combn(37,2))[2]
num_d/dem_d

#Part E
dem_E <- sum(shoppers$Spending > 30)
num_E <- sum(shoppers$Spending > 40)
num_E/dem_E
#Or
shoppers_more_than_30 <- subset(shoppers, subset = Spending > 30)
sum((shoppers_more_than_30$Spending > 40) == TRUE)/nrow(shoppers_more_than_30)

#Number 2
days <- seq(from = 1, to = 365, by = 1)
index <- sample(days,22,replace = TRUE)
index.tab <- table(index)
index.tab
sum(index.tab)


count_dups <- 0
for (i in 1:100){
  t.sample <- sample(1:365,22,replace = TRUE)
  if (length(t.sample) != length(unique(t.sample)))
      count_dups <- count_dups + 1
}
count_dups/100

#Problem 2 b
set.seed(1234)
count.over.11 <- 0
for (j in 1:10000){
  b2 <- runif(20)
  for (i in 1:20){
    if (b2[i] <= 0.6) {
      b2[i] <- 1 }
    else {
      b2[i] <- 0
    }
  }
  if (sum(b2) >= 11){
    count.over.11 <- count.over.11 + 1
  }
}
count.over.11/10000


