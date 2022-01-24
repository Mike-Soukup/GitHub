#Load in the packages necessary to connect to PostgresDB
library(RPostgres)
library(DBI)
library(ggplot2)
library(grid)
library(glue)


#Define the database specific information
db <- 'Accuracy'
host_db <- 'localhost'
db_port <- 5432
db_user <- 'postgres'
db_password <- 'iamgreat'

#establish connection to database
con <- dbConnect(RPostgres::Postgres(), dbname = db, host=host_db, port=db_port,
                 user=db_user, password=db_password)  

#check if connection is established
###dbListTables(con)

#SQL Query
df <- dbGetQuery(con, 'SELECT * 
                       FROM public.daily_bags_toss
                       WHERE id = 1
                       ORDER BY "Date" ASC' )

#Isolate Data
made <- df$Made
date <- df$Date
x.ax <- seq(from = 1, to = length(df$Made), by = 1)

#Linear Correlation
r <- cor(made,x.ax)
r.2 <- r^2

df2 <- data.frame(df$Made, x.ax)

#Linear Regression Model
linMod <- lm(made ~ x.ax)
print(linMod)
m <- round(unname(linMod$coefficients[2]), digits = 3)
b <- round(unname(linMod$coefficients[1]), digits = 1)
string <- "Y = {m}x + {b}"

#Plot Data with linear regression 

my_annotate = grobTree(textGrob(glue(string), x = 0.1, y = 0.95, hjust = 0,
              gp = gpar(col = 'black', fontsize = 12, fontface = "italic")))

ggplot(df, aes(x = x.ax, y = Made)) +
  geom_point(size = 2, shape = 16, col = 'black') +
  geom_smooth(method= 'lm', se = TRUE) + 
  labs(title = 'Made Bags Over Time',
       x = "Number of Throwing Sessions",
       y = 'Bags Made Per Session')+
  theme(plot.title = element_text(hjust = 0.5, size = 15))+
  annotation_custom(my_annotate)

#Scatter Plot
ggplot(data = df2, aes(x = x.ax, y = df.Made)) +
  geom_point() +
  labs(x = 'Session Number', y = "Bags Made per 100")

#Scatter Plot, plateau
df2 <- data.frame(df$Made, x.ax)
s <- 53
e <- 72
df2 <- df2[s:e,]
ggplot(df2, aes(x = x.ax, y = df.Made)) +
  geom_point(size = 2, shape = 16, col = 'black') +
  geom_smooth(method = 'lm', se = FALSE) +
  labs(x = "Days",y = "Made Bags",title = "Bags Made per Session | Last 19 Days") +
  theme(plot.title = (element_text(hjust = 0.5)))

lMod <- lm(df.Made ~ x.ax, data = df2)
summary(lMod)

#Since Last Post
ggplot(data = df2, aes(x = x.ax, y = df.Made)) +
  geom_point() +
  labs(x = 'Session Number', y = "Bags Made per 100", title = "Update 9/2/2020") +
  geom_vline(xintercept = 37, linetype = "dashed", color = "red", size = 0.7) +
  geom_rect(data = df2, aes(xmin = 37, xmax = 51),
            ymin = 0, ymax = 60, size = 0.5, alpha = 0.005,fill = "blue") +
  geom_rect(data = df2, aes(xmin = 51, xmax = 65), 
            ymin = 0, ymax = 60, size = 0.5, alpha = 0.005, fill = "green") +
  geom_rect(data = df2, aes(xmin = 65, xmax = 72), 
            ymin = 0, ymax = 60, size = 0.5, alpha = 0.005, fill = "red") +
  annotate("text", x = (51+37)/2, y = 21, label = "Plateau") +
  annotate("text", x = (65+51)/2, y = 21, label = "Wrist-Flick") +
  annotate("text", x = (72+65)/2, y = 21, label = "Stress") +
  geom_point(x = 52, y = 29, size = 4, color = "red", shape = 8) +
  theme(plot.title = element_text(hjust = 0.5, size = 20))


#Plot Date with Good Day and Bad Day linear bound limits
string1 <- "Y_upper = 0.82x + 23.9"
string2<- "Y_lower = 0.68x + 5.9"

my_annotate1 = grobTree(textGrob(string1, x = 0.5, y = 0.9, hjust = 0,
                  gp = gpar(col = 'black', fontsize = 10, fontface = "bold")))
my_annotate2 = grobTree(textGrob(string2, x = 0.1, y = 0.15, hjust = 0,
                  gp = gpar(col = 'black', fontsize = 10, fontface = "bold")))

ggplot(df, aes(x = x.ax, y = Made)) +
  geom_point(size = 2, shape = 16, col = 'black') +
  labs(title = 'Accuracy Improvement Boundaries',
       x = "Number of Throwing Sessions",
       y = 'Bags Made Per Session') +
  theme(plot.title = element_text(hjust = 0.5, size = 15))+
  geom_abline(slope = 0.82, intercept = 23.9, color = 'red',linetype = "dashed") + 
  geom_abline(slope = 0.68, intercept = 5.9, color = 'red',linetype = "dashed")+
  ylim(0,max(made)*1.10) + 
  annotation_custom(my_annotate1) + 
  annotation_custom(my_annotate2)

#Binomial Experiment
par(mfrow = c(1,1))
par(mar = c(5.1, 4.1, 4.1, 2.1))
#p <- mean(df$Made)/100
p <- .336
#Let's look probability of values from 0 to 100 based on this probability value
x <- seq(from = 0, to = 100, by = 1)
y <- dbinom(x,size = 100, prob = p)
plot(x,y,type = 'h', main = "Probability Distribution for Number of Bags Made out of 100",
     xlab = "Number Made", ylab = "Probability")


y1 <- pbinom(x,size = 100, prob = p)
plot(x,y1,type = 'l', lty = 1, col = "blue", main = "Cummulative Probability Density Function For Bags Made Per Session",
     xlab = "Bags Made", ylab = "Cum Prob")
#p50 <- x[which(abs(y1 - 0.5)<0.01)]
abline(h = 0.5, lty = 2, col = 'red')
abline(v = 50, lty = 2, col = "red")

par(mfrow = c(1,2))
y2 <- rbinom(length(df$Made[53:72]), 100, prob = 0.44)
hist(y2, col = "firebrick", main = "Random Binomial Distribution",
     xlab = "Number of Bags Made", ylab = "Probability")
hist(df$Made[53:72], col = "deepskyblue2", main = "Mike Soukup Results",
     xlab = "Number of Bags Made", ylab = "Frequency")
#axis(1, at = seq(from = 25, to = 50, by = 5), labels = seq(from = 25, to = 50, by = 5))
par(mfrow = c(1,1))

y3 <- rbinom(10000, 8, prob = p)
hist(y3, col = "darkolivegreen4", prob = TRUE, main = "Set of 8 Likely Outcomes",
     xlab = "# Bags / Set of 8", ylab = "Probability", xlim = c(0,8), xaxt = 'n')
axis(1, at = c(0.25,seq(0.75,7.75,by=1)), labels = c(0,1,2,3,4,5,6,7,8))

#text(x = x,y = y3)

df1 <- dbGetQuery(con, 'SELECT *
                        FROM public.bag_toss_each
                        WHERE id = 1
                        ORDER BY "Date" ASC,
                        "Toss_id" ASC;')
par(mfrow = c(1,1))
date.select <- "2020-09-16"
tit <- "Series Record for {date.select}"
one.day <- df1[which(df1$Date == date.select),]

plot(one.day$Toss_id, one.day$Outcome, type = 'b', pch = 16, col = "dodgerblue3",
     ylim = c(0,1.1), xlab = "Toss Id", ylab = "Outcome",xaxt = "n", yaxt = "n")
axis(1, at = c(seq(from = 0, to = 96, by = 8), 100), 
     labels = c(seq(from = 0, to = 96, by = 8), 100))
axis(2, at = 0:1, labels = c("Missed", "Made"))
title(glue(tit))
abline(v = c(seq(from = 0, to = 96, by = 8), 100), col = "darkgrey",
       lty = 2)
abline(h = c(0,1),col = "darkgrey", lty = 2)

num.per.set <- c()

for (i in df$Date){
  sub.set <- df1[which(df1$Toss_id != seq(from=97, to=100, by=1) & df1$Date == i),]
  for (j in 0:11){
    sub.set.1 <- sub.set[which(sub.set$Toss_id >= (j*8 + 1) & sub.set$Toss_id < (j*8 + 9)),]
    num.per.set <- append(num.per.set, sum(sub.set.1$Outcome))
  }
}

#Get rid of first 20 rounds of data to reflect recent capability
num.per.set.mod <- num.per.set[240:length(num.per.set)-12]
Actual_Data <- num.per.set.mod

p <- 0.38

par("mar")
par(mar = c(1,1,1,1))
par(mfrow = c(2,1))
par(mar = c(4,4,3,2))
hist(Actual_Data, col = "dodgerblue3", main = "Actually Makes per Set",
     xlab = "", ylab = "Frequency", xlim = c(0,8), xaxt = 'n')
axis(1, at = c(0.25,seq(0.75,7.75,by=1)), labels = c(0,1,2,3,4,5,6,7,8))

Binomial_Prediction <- rbinom(length(num.per.set.mod), 8, prob = p)
hist(Binomial_Prediction, col = "darkolivegreen4", main = "Probabalistic Outcomes; P = 0.38",
     xlab = "# Bags / Set of 8", ylab = "Frequency", xlim = c(0,8), xaxt = 'n')
axis(1, at = c(0.25,seq(0.75,7.75,by=1)), labels = c(0,1,2,3,4,5,6,7,8))

table(Actual_Data)
table(Binomial_Prediction)

round(table(Binomial_Prediction)/length(Binomial_Prediction),digits = 3)*100
round(table(Actual_Data)/length(Actual_Data), digits = 3)*100

p <- 0.5

par(mfrow = c(1,1))
x <- seq(from = 0, to = 8 , by =1)
y4 <- pbinom(x,8, prob = p)
plot(x,y4, type = "b", xlab = "Number of bags per set",
     ylab = "Cumulative Percentage of Rounds")
abline(h = 0.5, lty = 2, col = "red")

p <- 0.38

par(mfrow = c(1,1))

#What is expected if average makes is 50%
par(mar = c(4,4,3,2))
par(mfrow = c(2,1))

Fifty_Percent <- rbinom(1000, 8, prob = .50)
hist(Fifty_Percent, col = "gold", main = "Set of 8 Likely Outcomes P = 50%", prob = TRUE,
     xlab = "", ylab = "Probability", xlim = c(0,8), xaxt = 'n')
axis(1, at = c(0.25,seq(0.75,7.75,by=1)), labels = c(0,1,2,3,4,5,6,7,8))

ThirtyEight_Percent <- rbinom(1000, 8, prob = p)
hist(ThirtyEight_Percent, col = "darkolivegreen4", main = "Set of 8 Likely Outcomes P = 38.0%",
     xlab = "# Bags / Set of 8", ylab = "Probability", xlim = c(0,8), xaxt = 'n')
axis(1, at = c(0.25,seq(0.75,7.75,by=1)), labels = c(0,1,2,3,4,5,6,7,8))

round(table(ThirtyEight_Percent)/length(ThirtyEight_Percent),digits = 3)*100
round(table(Fifty_Percent)/length(Fifty_Percent),digits = 3)*100


par(mfrow = c(1,1))

#Look at performance on last 4 bags of a round

last.four <- c()

for (i in df$Date){
  sub.set <- df1[which(df1$Toss_id == seq(from=97, to=100, by=1) & df1$Date == i),]
    last.four <- append(last.four, sum(sub.set$Outcome))
}
hist(last.four, xlab = "Number of Last Four Bags Made", ylab = "Percentage",
     main = "Histogram of Last Four Scores", freq = FALSE)
table(last.four)
table(last.four)/length(last.four)
