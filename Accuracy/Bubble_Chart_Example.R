################################################################################
#Demo Bubble Plot
library(ggplot2)
library(dplyr)
library(ggpubr)

x <- numeric(0)
for (i in c(1:5)){
  x <- c(x,rep.int(i,8))
}
y <- rep(1:8,5)
f <- round(runif(40, min = 0, max = 25), digits = 0)
#o <- round(runif(100, min = 0, max = 1), digits = 0)

data <- data.frame(cbind(x,y,f))
colnames(data) <- c("X","Y","Frequency")

################################################################################
#CAD Bag Drawing
#img <- png::readPNG('/Users/mikeysoukup/Desktop/Python/Accuracy/Bags_Board_Drawing.png')
#Wisconsin Bag Board
img <- png::readPNG('/Users/mikeysoukup/Desktop/Python/Accuracy/W_bag_board.png')
ggplot(data, aes(x = X, y = Y, size = Frequency, color = Frequency)) +
  background_image(img) +
  geom_point( alpha = 0.5) +
  scale_color_gradient(low = "black", high = "red") +
  scale_size(range = c(0,75)) + 
  theme(legend.position = "none", panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.title = element_blank(),
        axis.ticks = element_blank(), axis.text = element_blank()) + 
  coord_fixed()
 
################################################################################
#Here is the same graphic without the image for development work
library(ggplot2)
library(dplyr)
library(ggpubr)

x <- numeric(0)
for (i in c(1:5)){
  x <- c(x,rep.int(i,8))
}
y <- rep(1:8,5)
f <- round(runif(40, min = 0, max = 25), digits = 0)
#o <- round(runif(100, min = 0, max = 1), digits = 0)

data <- data.frame(cbind(x,y,f))
colnames(data) <- c("X","Y","Frequency")

ggplot(data, aes(x = X, y = Y, size = Frequency, color = Frequency)) +
  geom_point( alpha = 0.5) +
  scale_color_gradient(low = "black", high = "red") +
  scale_size(range = c(0,75)) + 
  theme(legend.position = "none", panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.title = element_blank(),
        axis.ticks = element_blank(), axis.text = element_blank()) + 
  coord_fixed()
################################################################################
library(ggplot2)
library(dplyr)
library(ggpubr)

#Create grid labels
x <- numeric(0)
for (i in c(1:5)){
  x <- c(x,rep.int(i,8))
}
y <- rep(1:8,5)

land.x <- round(runif(100, min = 1, max = 5))
land.y <- round(runif(100, min = 1, max = 8))
rand.out <- round(runif(100, min = 0, max =1))
toss.id <- seq(from = 1, to = 100, by =1)
num.throws <- max(toss.id)

#Simulated data from excel
df.test <- data.frame(cbind(toss.id, land.x, land.y, rand.out))
names(df.test)[2] <- "X"
names(df.test)[3] <- "Y"
names(df.test)[4] <- "Outcome"

#Try this the brute force method
land.mat <- matrix(data = 0, nrow = 8, ncol = 5)
rownames(land.mat) <- c("1","2","3","4","5","6","7","8")
colnames(land.mat) <- c("1","2","3","4","5")
out.mat <- matrix(data = 0, nrow = 8, ncol = 5)
rownames(out.mat) <- c("1","2","3","4","5","6","7","8")
colnames(out.mat) <- c("1","2","3","4","5")

for (i in 1:nrow(df.test)){
  if (df.test[i,]$X == 1){
    if (df.test[i,]$Y == 1){
      land.mat[1,1] <- land.mat[1,1] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[1,1] <- out.mat[1,1] + 1
      }
    }
    if (df.test[i,]$Y == 2){
      land.mat[2,1] <- land.mat[2,1] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[2,1] <- out.mat[2,1] + 1
      }
    }
    if (df.test[i,]$Y == 3){
      land.mat[3,1] <- land.mat[3,1] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[3,1] <- out.mat[3,1] + 1
      }
    }
    if (df.test[i,]$Y == 4){
      land.mat[4,1] <- land.mat[4,1] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[4,1] <- out.mat[4,1] + 1
      }
    }
    if (df.test[i,]$Y == 5){
      land.mat[5,1] <- land.mat[5,1] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[5,1] <- out.mat[5,1] + 1
      }
    }
    if (df.test[i,]$Y == 6){
      land.mat[6,1] <- land.mat[6,1] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[6,1] <- out.mat[6,1] + 1
      }
    }
    if (df.test[i,]$Y == 7){
      land.mat[7,1] <- land.mat[7,1] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[7,1] <- out.mat[7,1] + 1
      }
    }
    if (df.test[i,]$Y == 8){
      land.mat[8,1] <- land.mat[8,1] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[8,1] <- out.mat[8,1] + 1
      }
    }
  }
  if (df.test[i,]$X == 2){
    if (df.test[i,]$Y == 1){
      land.mat[1,2] <- land.mat[1,2] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[1,2] <- out.mat[1,2] + 1
      }
    }
    if (df.test[i,]$Y == 2){
      land.mat[2,2] <- land.mat[2,2] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[2,2] <- out.mat[2,2] + 1
      }
    }
    if (df.test[i,]$Y == 3){
      land.mat[3,2] <- land.mat[3,2] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[3,2] <- out.mat[3,2] + 1
      }
    }
    if (df.test[i,]$Y == 4){
      land.mat[4,2] <- land.mat[4,2] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[4,2] <- out.mat[4,2] + 1
      }
    }
    if (df.test[i,]$Y == 5){
      land.mat[5,2] <- land.mat[5,2] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[5,2] <- out.mat[5,2] + 1
      }
    }
    if (df.test[i,]$Y == 6){
      land.mat[6,2] <- land.mat[6,2] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[6,2] <- out.mat[6,2] + 1
      }
    }
    if (df.test[i,]$Y == 7){
      land.mat[7,2] <- land.mat[7,2] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[7,2] <- out.mat[7,2] + 1
      }
    }
    if (df.test[i,]$Y == 8){
      land.mat[8,2] <- land.mat[8,2] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[8,2] <- out.mat[8,2] + 1
      }
    }
  }
  if (df.test[i,]$X == 3){
    if (df.test[i,]$Y == 1){
      land.mat[1,3] <- land.mat[1,3] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[1,3] <- out.mat[1,3] + 1
      }
    }
    if (df.test[i,]$Y == 2){
      land.mat[2,3] <- land.mat[2,3] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[2,3] <- out.mat[2,3] + 1
      }
    }
    if (df.test[i,]$Y == 3){
      land.mat[3,3] <- land.mat[3,3] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[3,3] <- out.mat[3,3] + 1
      }
    }
    if (df.test[i,]$Y == 4){
      land.mat[4,3] <- land.mat[4,3] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[4,3] <- out.mat[4,3] + 1
      }
    }
    if (df.test[i,]$Y == 5){
      land.mat[5,3] <- land.mat[5,3] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[5,3] <- out.mat[5,3] + 1
      }
    }
    if (df.test[i,]$Y == 6){
      land.mat[6,3] <- land.mat[6,3] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[6,3] <- out.mat[6,3] + 1
      }
    }
    if (df.test[i,]$Y == 7){
      land.mat[7,3] <- land.mat[7,3] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[7,3] <- out.mat[7,3] + 1
      }
    }
    if (df.test[i,]$Y == 8){
      land.mat[8,3] <- land.mat[8,3] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[8,3] <- out.mat[8,3] + 1
      }
    }
  }
  if (df.test[i,]$X == 4){
    if (df.test[i,]$Y == 1){
      land.mat[1,4] <- land.mat[1,4] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[1,4] <- out.mat[1,4] + 1
      }
    }
    if (df.test[i,]$Y == 2){
      land.mat[2,4] <- land.mat[2,4] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[2,4] <- out.mat[2,4] + 1
      }
    }
    if (df.test[i,]$Y == 3){
      land.mat[3,4] <- land.mat[3,4] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[3,4] <- out.mat[3,4] + 1
      }
    }
    if (df.test[i,]$Y == 4){
      land.mat[4,4] <- land.mat[4,4] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[4,4] <- out.mat[4,4] + 1
      }
    }
    if (df.test[i,]$Y == 5){
      land.mat[5,4] <- land.mat[5,4] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[5,4] <- out.mat[5,4] + 1
      }
    }
    if (df.test[i,]$Y == 6){
      land.mat[6,4] <- land.mat[6,4] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[6,4] <- out.mat[6,4] + 1
      }
    }
    if (df.test[i,]$Y == 7){
      land.mat[7,4] <- land.mat[7,4] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[7,4] <- out.mat[7,4] + 1
      }
    }
    if (df.test[i,]$Y == 8){
      land.mat[8,4] <- land.mat[8,4] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[8,4] <- out.mat[8,4] + 1
      }
    }
  }
  if (df.test[i,]$X == 5){
    if (df.test[i,]$Y == 1){
      land.mat[1,5] <- land.mat[1,5] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[1,5] <- out.mat[1,5] + 1
      }
    }
    if (df.test[i,]$Y == 2){
      land.mat[2,5] <- land.mat[2,5] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[2,5] <- out.mat[2,5] + 1
      }
    }
    if (df.test[i,]$Y == 3){
      land.mat[3,5] <- land.mat[3,5] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[3,5] <- out.mat[3,5] + 1
      }
    }
    if (df.test[i,]$Y == 4){
      land.mat[4,5] <- land.mat[4,5] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[4,5] <- out.mat[4,5] + 1
      }
    }
    if (df.test[i,]$Y == 5){
      land.mat[5,5] <- land.mat[5,5] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[5,5] <- out.mat[5,5] + 1
      }
    }
    if (df.test[i,]$Y == 6){
      land.mat[6,5] <- land.mat[6,5] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[6,5] <- out.mat[6,5] + 1
      }
    }
    if (df.test[i,]$Y == 7){
      land.mat[7,5] <- land.mat[7,5] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[7,5] <- out.mat[7,5] + 1
      }
    }
    if (df.test[i,]$Y == 8){
      land.mat[8,5] <- land.mat[8,5] + 1
      if (df.test[i,]$Outcome == 1){
        out.mat[8,5] <- out.mat[8,5] + 1
      }
    }
  }
}

land.df <- as.data.frame(as.table(land.mat))
names(land.df)[1] <- "Y"
names(land.df)[2] <- "X"
names(land.df)[3] <- "LandFreq"
out.df <- as.data.frame(as.table(out.mat))
names(out.df)[1] <- "Y"
names(out.df)[2] <- "X"
names(out.df)[3] <- "MakeFreq"

throws.landed <- sum(land.mat)
throws.made <- sum(out.mat)

land.df$LandProp <- round(100*(land.df$LandFreq/throws.landed), digits = 2)
land.df$MakeFreq <- out.df$MakeFreq
land.df$TotMakeProp <- round(100*(land.df$MakeFreq/throws.made), digits = 2)
land.df$RelMakeProp <- round(100*(land.df$MakeFreq/land.df$LandFreq), digits = 2)
#Get rid of NaN in the data frame and replace with 0
land.df[is.na(land.df)] <- 0

#Now plot the data | Bubble Chart, size =  LandProp and Color = Relative Make Prop

ggplot(land.df, aes(x = X, y = Y, size = LandProp, color = RelMakeProp)) +
  geom_point( alpha = 0.5) +
  scale_color_gradient(low = "blue", high = "red") +
  scale_size(range = c(0,60)) + 
  theme(legend.position = "none", panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.title = element_blank(),
        axis.ticks = element_blank(), axis.text = element_blank()) + 
  coord_fixed()

#Now plot the data | with geom_bin2d() | Plot Land Proportion
img <- png::readPNG('/Users/mikeysoukup/Desktop/Python/Accuracy/W_bag_board.png')

ggplot(land.df, aes(x = X, y = Y, fill = RelMakeProp)) +
  background_image(img) +
  geom_bin2d(alpha = 0.8) +
  scale_fill_gradient(low = "dodgerblue", high = "firebrick") +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())
  
################################################################################
#Convert recorded data into a data frame based on land frequency
freq.table <- table(df.test$Y, df.test$X)
freq.df <- as.data.frame(freq.table)
names(freq.df)[1] <- "Y"
names(freq.df)[2] <- "X"
names(freq.df)[3] <- "LandFreq"
freq.df$LandProp <- round(freq.df$LandFreq/num.throws, digits = 3)
freq.table
freq.df

#Now need to count outcomes per X and Y land
out.df <- with(df.test, aggregate(Outcome, by  = list(X,Y), sum))
colnames(out.df) <- c("X","Y","Made")
out.df





