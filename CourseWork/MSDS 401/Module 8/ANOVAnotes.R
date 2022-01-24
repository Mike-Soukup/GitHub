plant1 <- c(29,27,30,27,28)
plant2 <- c(32,33,31,34,30)
plant3 <- c(25,24,24,25,26)
df <- data.frame(cbind(plant1, plant2, plant3))
dfc <- ncol(df)-1
N <- ncol(df)*nrow(df)
dfe <- N - ncol(df)

SSC <- function(df){
  i <- nrow(df)
  j <- ncol(df)
  N <- ncol(df)*nrow(df)
  s <- sum(apply(df,2,sum))
  C.m <- apply(df,2,mean)
  m <- s/N
  ssc <- c()
  for (k in 1:j){
    n <- length(df[,k])
    ssc <- append(ssc,n*((C.m[k]-m)^2))
  }
  SSC <- sum(ssc)
  return(SSC)
}

SSE <- function(df){
  N <- ncol(df)*nrow(df)
  s <- sum(apply(df,2,sum))
  C.m <- apply(df,2,mean)
  m <- s/N
  sse <- c()
  for (j in 1:ncol(df)){
    for (i in 1:nrow(df)){
      sse <- append(sse,(df[i,j] - C.m[j])^2)
    }
  }
  return(sum(sse))
}

SST <- function(df){
  N <- ncol(df)*nrow(df)
  s <- sum(apply(df,2,sum))
  C.m <- apply(df,2,mean)
  m <- s/N
  sst <- c()
  for (j in 1:ncol(df)){
    for (i in 1:nrow(df)){
      sst <- append(sst, (df[i,j] - m)^2)
    }
  }
  return(sum(sst))
}

ANVA1 <- function(df){
  N <- ncol(df)*nrow(df)
  s <- sum(apply(df,2,sum))
  C.m <- apply(df,2,mean)
  m <- s/N
  ssc <- SSC(df)
  sse <- SSE(df)
  sst <- SST(df)
  dfc <- ncol(df)-1
  dfe <- N - ncol(df)
  msc <- ssc/dfc
  mse <- sse/dfe
  f <- msc/mse
  df <- c(dfc, dfe, N-1)
  mat <- matrix(nrow = 3, ncol = 4)
  mat[,1] <- df
  ss <- c(ssc, sse, sst)
  mat[,2] <- ss
  mat[1,3] <- msc
  mat[2,3] <- mse
  mat[1,4] <- f
  colnames(mat) <- c("df","SS","MS","F")
  rownames(mat) <- c("Treatment","Error","Total")
  print(mat)
}

ssc <- SSC(df)
sse <- SSE(df)
sst <- SST(df)

ANVA1(df)
qf(0.99,df1=2, df2 = 12)

c1 <- c(2.46,2.41,2.43,2.47,2.46)
c2 <- c(2.38, 2.34, 2.31, 2.40, 2.32)
c3 <- c(2.51, 2.48, 2.46, 2.49, 2.50)
c4 <- c(2.49, 2.47, 2.48, 2.46, 2.44)
c5 <- c(2.56, 2.57, 2.53, 2.55, 2.55)

df1 <- data.frame(cbind(c1, c2, c3, c4, c5))
df1

ANVA1(df1)
a <- apply(df1,2,mean)
mat <- matrix(nrow = length(a), ncol = length(a))
for(i in 1:length(a)){
  for(j in 1:length(a)){
    mat[i,j] <- abs(a[i]-a[j])
  }
}
mat
mat > 0.0588

#problem 11.3
miami <- c(3.47,3.43,3.44,3.46,3.46,3.44)
phili <- c(3.40,3.41,3.41,3.45,3.40,3.43)
minn <- c(3.38,3.42,3.43,3.40,3.39,3.42)
sa <- c(3.32,3.35,3.36,3.30,3.39,3.39)
oak <- c(3.50,3.44,3.45,3.45,3.48,3.49)

df <- cbind(miami, phili, minn, sa, oak)
treat.means <- apply(df,2,mean)
block.means <- apply(df,1,mean)

SSC_b <- function(df){
  C.m <- apply(df,2,mean)
  m <- mean(df)
  n <- nrow(df)
  ssc_b <- c()
  for (j in (1:ncol(df))){
    ssc_b <- append(ssc_b, (C.m[j]-m)^2)
  }
  return(n*sum(ssc_b))
}
SSR_b <- function(df){
  C <- ncol(df)
  B.m <- apply(df,1,mean)
  m <- mean(df)
  ssr_b <- c()
  for (i in (1:nrow(df))){
    ssr_b <- append(ssr_b,(B.m[i]-m)^2)
  }
  return(C*sum(ssr_b))
}
SSE_b <- function(df){
  C.m <- apply(df,2,mean)
  B.m <- apply(df,1,mean)
  m <- mean(df)
  sse_b <- c()
  for (i in 1:nrow(df)){
    for (j in 1:ncol(df)){
      sse_b <- append(sse_b,(df[i,j] - C.m[j] - B.m[i] + m)^2)
    }
  }
  return(sum(sse_b))
}
RandBlockDesg <- function(df){
  C <- ncol(df)
  n <- nrow(df)
  N <- C*n
  dfc <- C - 1
  dfr <- n - 1
  dfe <- dfc*dfr
  dft <- c(dfc, dfr, dfe, N-1)
  ssc_b <- SSC_b(df)
  ssr_b <- SSR_b(df)
  sse_b <- SSE_b(df)
  sst_b <- SST(df)
  ss <- c(ssc_b, ssr_b, sse_b, sst_b)
  MSC <- ssc_b/dfc
  MSR <- ssr_b/dfr
  MSE <- sse_b/dfe
  ms <- c(MSC, MSR, MSE)
  F.tret <- MSC/MSE
  F.block <- MSR/MSE
  f <- c(F.tret, F.block)
  mat <- matrix(nrow = 4, ncol = 4)
  mat[,1]<- ss
  mat[,2]<- dft
  mat[1:3,3] <- ms
  mat[1:2,4] <- f
  rownames(mat) <- c("Treatment","Block","Error","Total")
  colnames(mat) <- c("SS","Df","MS","F")
  return(mat)
}

SSC_b(df)
SSR_b(df)
SSE_b(df)

RandBlockDesg(df)
ANVA1(df)

library(ggplot2)

beds <- c(23,29,29,35,42,46,50,54,64,66,76,78)
fte <- c(69,95,102,118,126,125,138,178,156,184,176,225)
df <- data.frame(cbind(beds,fte))


Reg.r <- function(df){
  colnames(df) <- c("x","y")
  df$x_2 <- df$x^2
  df$y_2 <- df$y^2
  df$xy <- df$x*df$y
  n <- nrow(df)
  s.x <- sum(df$x)
  s.y <- sum(df$y)
  s.x2 <- sum(df$x_2)
  s.y2 <- sum(df$y_2)
  s.xy <- sum(df$xy)
  r <- (s.xy - ((s.x*s.y)/n))/sqrt((s.x2-((s.x^2)/n))*(s.y2-((s.y^2)/n)))
  return(r)
}  

RegAnal <- function(df){
  colnames(df) <- c("x","y")
  df$x_2 <- df$x^2
  df$y_2 <- df$y^2
  df$xy <- df$x*df$y
  n <- nrow(df)
  s.x <- sum(df$x)
  s.y <- sum(df$y)
  s.x2 <- sum(df$x_2)
  s.y2 <- sum(df$y_2)
  s.xy <- sum(df$xy)
  r <- Reg.r(df)
  b1 <- (s.xy-((s.x*s.y)/n))/(s.x2-((s.x^2)/n))
  b0 <- (s.y/n)-(b1)*(s.x/n)
  mat <- matrix(ncol = 3, nrow = 1)
  out <- c(r, b0, b1)
  mat[1,] <- out
  colnames(mat) <- c("r","b0","b1")
  plot(x = df$x, y = df$y)
  return(mat)
}
  
RegAnal(df)

one <- c(3,2,4,3,2,3)
two <- c(5,6,7,6,7)
three <- c(4,2,2,2,3)
four <- c(1,2,2,1,1,2)
N <- 22
x.bar <- sum(one,two,three,four)/N
mns <- c(mean(one),mean(two),mean(three),mean(four))
lngs <- c(length(one), length(two), length(three), length(four))
ssc <- c()
for (i in 1:4){
  n <- lngs[i]
  x.j <- mns[i]
  ssc <- append(ssc, n*((x.j - x.bar)^2))
}
SSC <- sum(ssc)
MSC <- SSC/(length(mns)-1)
L <- list(one, two, three, four)

sse <- c()
for (j in 1:length(L)){
  for (i in 1:length(L[[j]])){
    sse <- append(sse, (L[[j]][i] - mns[j])^2)
  }
}
SSE <- sum(sse)
MSE <- SSE/18

F.test <- MSC/MSE
  
  
one <- c(11,9,10,12,11,8,10)
two <- c(24,25,25,26,24)
three <- c(27,30,29,28,31,29)
L <- list(one, two, three)
n.1 <- length(one)
n.2 <- length(two)
n.3 <- length(three)
q <- 4.83
MSE <- 1.58
q*sqrt((MSE/2)*((1/n.1)+(1/n.2)))
q*sqrt((MSE/2)*((1/n.1)+(1/n.3)))  
q*sqrt((MSE/2)*((1/n.2)+(1/n.3)))

one <- c(5,8,7,8,6)
two <- c(11,9,9,10,11)
three <- c(12,11,13,14,14)
four <- c(21,18,20,21,23)
df <- data.frame(one,two,three,four)

SSC_b <- function(df){
  C.m <- apply(df,2,mean)
  N <- nrow(df)*ncol(df)
  m <- sum(apply(df,2,sum))/N
  n <- nrow(df)
  ssc_b <- c()
  for (j in (1:ncol(df))){
    ssc_b <- append(ssc_b, (C.m[j]-m)^2)
  }
  return(n*sum(ssc_b))
}
SSR_b <- function(df){
  C <- ncol(df)
  B.m <- apply(df,1,mean)
  N <- nrow(df)*ncol(df)
  m <- sum(apply(df,2,sum))/N
  ssr_b <- c()
  for (i in (1:nrow(df))){
    ssr_b <- append(ssr_b,(B.m[i]-m)^2)
  }
  return(C*sum(ssr_b))
}
SSE_b <- function(df){
  C.m <- apply(df,2,mean)
  B.m <- apply(df,1,mean)
  N <- nrow(df)*ncol(df)
  m <- sum(apply(df,2,sum))/N
  sse_b <- c()
  for (i in 1:nrow(df)){
    for (j in 1:ncol(df)){
      sse_b <- append(sse_b,(df[i,j] - C.m[j] - B.m[i] + m)^2)
    }
  }
  return(sum(sse_b))
}
RandBlockDesg <- function(df){
  C <- ncol(df)
  n <- nrow(df)
  N <- C*n
  dfc <- C - 1
  dfr <- n - 1
  dfe <- dfc*dfr
  dft <- c(dfc, dfr, dfe, N-1)
  ssc_b <- SSC_b(df)
  ssr_b <- SSR_b(df)
  sse_b <- SSE_b(df)
  sst_b <- SST(df)
  ss <- c(ssc_b, ssr_b, sse_b, sst_b)
  MSC <- ssc_b/dfc
  MSR <- ssr_b/dfr
  MSE <- sse_b/dfe
  ms <- c(MSC, MSR, MSE)
  F.tret <- MSC/MSE
  F.block <- MSR/MSE
  f <- c(F.tret, F.block)
  mat <- matrix(nrow = 4, ncol = 4)
  mat[,1]<- ss
  mat[,2]<- dft
  mat[1:3,3] <- ms
  mat[1:2,4] <- f
  rownames(mat) <- c("Treatment","Block","Error","Total")
  colnames(mat) <- c("SS","Df","MS","F")
  return(mat)
}



one <- c(2,3,2,4,3)
two <- c(4,4,5,6,5)
three <- c(8,9,7,6,9)

df <- data.frame(one,two,three)
ssc.b <- SSC_b(df)
ssc.b
ssr.b <- SSR_b(df)
ssr.b
sse.b <- SSE_b(df)
sse.b

RandBlockDesg(df)

Reg.r <- function(df){
  colnames(df) <- c("x","y")
  df$x_2 <- df$x^2
  df$y_2 <- df$y^2
  df$xy <- df$x*df$y
  n <- nrow(df)
  s.x <- sum(df$x)
  s.y <- sum(df$y)
  s.x2 <- sum(df$x_2)
  s.y2 <- sum(df$y_2)
  s.xy <- sum(df$xy)
  r <- (s.xy - ((s.x*s.y)/n))/sqrt((s.x2-((s.x^2)/n))*(s.y2-((s.y^2)/n)))
  return(r)
}  

RegAnal <- function(df){
  colnames(df) <- c("x","y")
  df$x_2 <- df$x^2
  df$y_2 <- df$y^2
  df$xy <- df$x*df$y
  n <- nrow(df)
  s.x <- sum(df$x)
  s.y <- sum(df$y)
  s.x2 <- sum(df$x_2)
  s.y2 <- sum(df$y_2)
  s.xy <- sum(df$xy)
  r <- Reg.r(df)
  b1 <- (s.xy-((s.x*s.y)/n))/(s.x2-((s.x^2)/n))
  b0 <- (s.y/n)-(b1)*(s.x/n)
  mat <- matrix(ncol = 3, nrow = 1)
  out <- c(r, b0, b1)
  mat[1,] <- out
  colnames(mat) <- c("r","b0","b1")
  plot(x = df$x, y = df$y)
  return(mat)
}

x <- c(19,20,26,31,34,45,45,51)
y <- c(78,100,125,120,119,130,145,143)
df <- data.frame(x,y)
RegAnal(df)

x <- c(-10,-6,1,4,15)
y <- c(-26,-44,-36,-39,-43)
df <- data.frame(x,y)
RegAnal(df)