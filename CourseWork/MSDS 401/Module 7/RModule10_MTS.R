################################################################################
#Excercise 1

#Attempt with prop.test
n <- 100
nd <- 0.85
c <- 0.65
alpha <- 0.95

#Calculate Out

#Create Confidence Interval
p0.hat <- 0.85
p1.hat <- 0.65
q0.hat <- 1-p0.hat
q1.hat <- 1- p1.hat
n <- 100
delta <- p0.hat - p1.hat
z <- qnorm(0.95)
sd <- sqrt(((p0.hat*q0.hat)/n)+((p1.hat*q1.hat)/n))

ci <- delta - z*sd

cat("p_0 - p_1 > ", round(ci,digits = 4))

z.c <- qnorm(0.95)
z.c

p.bar <- ((n*p0.hat + n*p1.hat)/(2*n))
q.bar <- 1-p.bar

z.test <- (p0.hat - p1.hat)/sqrt((p.bar*q.bar)*((1/n)+(1/n)))
z.test

new.drug <- c(p0.hat*n, q0.hat*n)
control <- c(p1.hat*n, q1.hat*n)

x <- as.matrix(rbind(new.drug,control))

prop.test(x, alternative = c("greater"), conf.level = 0.95, correct = FALSE)

pnorm(z.test, lower.tail = FALSE)
################################################################################
#Excercise 2
rm(list = ls())
#Start with Prop Test
p1.attempts <- 267
p1.hr <- 85
p1.rat <- p1.hr / p1.attempts
q1.rat <- 1-p1.rat
p2.attempts <- 248
p2.hr <- 89
p2.rat <- p2.hr / p2.attempts
q2.rat <- 1-p2.rat

player_1 <- c(p1.hr, p1.attempts - p1.hr)
player_2 <- c(p2.hr, p2.attempts - p2.hr)

x <- as.matrix(rbind(player_1, player_2), dimnames = list(c("Player 1","Player 2"),
                                                          c("HR","Not HR")))
x

prop.test(x = x, alternative = c("two.sided"), conf.level = 0.95, correct = FALSE)

#Next, calculate the CI and Hypothesis test 

p.bar <- (p1.hr + p2.hr)/(p1.attempts + p2.attempts)
q.bar <- 1-p.bar

z.test <- (p1.rat - p2.rat)/sqrt((p.bar*q.bar)*((1/p1.attempts)+(1/p2.attempts)))
z.test

point <- p1.rat - p2.rat
z <- qnorm(0.975)

s <- sqrt(((p1.rat*q1.rat)/p1.attempts)+((p2.rat*q2.rat)/p2.attempts))

l.bound <- point - z*s
u.bound <- point + z*s

cat(l.bound, "< p_1 - p_2 <",u.bound)
################################################################################
#Excercise 3

#Calculate it out first
home <- read.csv("/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Module 7/home_prices.csv")

NE <- home[home$NBR == "YES",]
nonNE <- home[home$NBR == "NO",]

NE.mean <- mean(NE$PRICE)
NE.sd <- sd(NE$PRICE)
NE.n <- length(NE$PRICE)
NE.var <- var(NE$PRICE)

nonNE.mean <- mean(nonNE$PRICE)
nonNE.sd <- sd(nonNE$PRICE)
nonNE.n <- length(nonNE$PRICE)
nonNE.var <- var(nonNE$PRICE)

part1 <- ((NE.var/NE.n)+(nonNE.var/nonNE.n))^2
part2 <- (((NE.var/NE.n)^2)/(NE.n - 1)) + ((nonNE.var/nonNE.n)^2)/(nonNE.n - 1)
df <- part1/part2

t <- (NE.mean - nonNE.mean)/sqrt((NE.var/NE.n) + (nonNE.var/nonNE.n))
t

#Do the t.test function approach


t.test(NE$PRICE, nonNE$PRICE, alternative = c("two.sided"), mu = 0, paired = FALSE,
       var.equal = FALSE, conf.level = 0.95)

CORNER <- home[home$CORNER == "YES",]
nCORNER <- home[home$CORNER == "NO",]

t.test(CORNER$PRICE, nCORNER$PRICE, alternative = c("two.sided"), mu = 0, paired = FALSE,
       var.equal = FALSE, conf.level = 0.95)
################################################################################
#Excercise 4
NM <- read.csv("/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Module 7/nsalary.csv")
str(NM)

Rural <- NM[NM$RURAL == "YES",]
NRural <- NM[NM$RURAL == "NO",]

#Rural
r.mean <- mean(Rural$NSAL)
r.var <- var(Rural$NSAL)
r.n <- length(Rural$NSAL)

#Non-Rural
nr.mean <- mean(NRural$NSAL)
nr.var <- var(NRural$NSAL)
nr.n <- length(Rural$NSAL)

part1 <- ((r.var/r.n) + (nr.var/nr.n))^2
part2 <- (((r.var/r.n)^2)/(r.n - 1)) + (((nr.var/nr.n)^2)/(nr.n - 1))
df <- part1 / part2
df

tc <- qt(0.975, df = 62)
tc

t <- (r.mean - nr.mean)/sqrt((r.var/r.n) + (nr.var/nr.n))
t

t.test(Rural$NSAL, NRural$NSAL, alternative = c("two.sided"),
       mu = 0, paired = FALSE, var.equal = FALSE, conf.level = 0.95)
################################################################################
#Exercise #5


tires <- read.csv("/Users/mikeysoukup/Desktop/NU MSDS/MSDS 401/Module 7/tires.csv")
tires

tires$d <- tires$WGT-tires$GRO

n <- length(tires$d)

d.bar <- sum(tires$d)/n

tires$d2 <- tires$d^2

s.d <- sqrt((sum(tires$d2) - ((sum(tires$d)^2)/n))/(n-1))

s.d1 <- sqrt((sum((tires$d - d.bar)^2))/(n-1))

d.bar
s.d
s.d1

t <- qt(0.975,df=15)

l.bound <- d.bar - (t*(s.d/sqrt(n)))
u.bound <- d.bar + (t*(s.d/sqrt(n)))

cat(l.bound,"< D <",u.bound)

t.t <- d.bar/(s.d/sqrt(n))
t.t

p <- 2*pt(t.t, df = 15, lower.tail = FALSE)
p
#I think you can do this with t.test as a paired attribute

t.test(tires$WGT, tires$GRO, alternative = c("two.sided"),
       mu = 0, paired = TRUE, conf.level = 0.95)

