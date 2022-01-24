################################################################################
#Question 1
q1 <- c(80, 121, 132, 145, 151, 119, 133, 134, 200, 195, 90, 121, 132, 123, 145,
        151, 119, 133, 134, 151, 168)

boxplot(q1, range = 3)

qnts <- c(0,0.25,0.50,0.75,1)
quantile(q1, probs = qnts, type = 2)
q3 <- 151
q1 <- 121
IQR <- q3 - q1

q3 + (3*IQR)

#The answer to this question should be: False. 200 is not an extreme outlier
################################################################################
#Question 2

#The answer is Nominal
################################################################################
#Question 3

q3 <- c(41,37,27,41,18,48,41,50,54,37,25)

rnge <- max(q3) - min(q3)
rnge
rnge1 <- range(q3)[2] - range(q3)[1]
rnge1
range(q3)

as.numeric(q3)
sort(q3)
#mode is 41, range is 36
as.factor(q3)
table(q3) #Mode is 41
#The answer here should be B. Mode is 41 and range is 36
################################################################################
#Question 4

q4 <- c(19,18,26,9,15,23,10,5,15,17,8,22,12)
round(sd(q4),digits = 1)

sd1 <- sqrt(sum(((q4 - mean(q4))^2))/(length(q4) - 1))
sd1

round(sd1, digits = 1)
#Answer to Question #4 is 6.3
################################################################################
#Question 5

q5 <- c(3.8, 1.8, 2.4, 3.7, 4.1, 3.9, 1.2, 3.6, 4.2, 3.4, 3.7, 2.2, 1.6, 4.2, 
        3.5, 2.6, 0.4, 3.7, 2.0, 3.6)
round(median(q5), digits = 2)

sort(q5)

length(q5)

(q5[10]+q5[11])/2

#The median of these values rounded to 2 digits is 3.55 in.
################################################################################
#Question 6

q6 <- c(3.8, 1.8, 2.4, 3.7, 4.1, 3.9, 1.2, 3.6, 4.2, 3.4, 3.7, 2.2, 1.6, 4.2, 
        3.5, 2.6, 0.4, 3.7, 2.0, 3.6)

round(var(q6), digits = 3)

vr1 <- sum((q6 - mean(q6))^2)/(length(q6) - 1)
round(vr1, digits = 3)

#Variance of this data set is 1.247
################################################################################
#Question 7

mheight <- 67.1
sdheight <- 3.5

mheight - (2*sdheight)
mheight + (2*sdheight)
#The answer is the percentage is at least 75%
################################################################################
#Question 8

q8 <- c(69, 68, 64, 61, 65, 64, 71, 67, 62, 63, 61, 64, 75, 67, 60, 59, 64, 69,
        65, 72)
round(mean(q8, trim = 0.2), digits = 2)

round(0.2*length(q8))

q8_s <- sort(q8)
round(mean(q8_s[5:16]), digits = 2)
#The answer to this question is 65.17
################################################################################
# Question 9

center <- seq(from = 54.5, to = 94.5, by = 10)
f <- c(5,7,9,10,9)
class <- c("50-59","60-69","70-79","80-89","90-99")

df <- data.frame(class, f, center)
fi_Mi <- f*center
df<-data.frame(class, f, center, fi_Mi)
df

x <- sum(fi_Mi)/sum(f)
x
fi_Mi_x <- f*((center - x)^2)
df <- data.frame(class, f, center, fi_Mi, fi_Mi_x)
df

vr_frq <- sum(fi_Mi_x)/(sum(f)-1)
sd_frq <- round(sqrt(vr_frq), digits = 1)
sd_frq

#The standard deviation here is 13.4
################################################################################
# Question 10

rest_a <- c(120,	67,	89	,97	,124,	68,	72,	96)
rest_b <- c(115,	126	,49	,56	,98,	76,	78	,95)
#For Restaurant A
max(rest_a) - min(rest_a)
var(rest_a)
sd(rest_a)

#For Restaurant B
max(rest_b) - min(rest_b)
var(rest_b)
sd(rest_b)

#There is more variation in the times for restaurant B as indicated by results 
################################################################################
