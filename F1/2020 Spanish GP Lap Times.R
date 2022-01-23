library(ggplot2)
library(lubridate)
df <- read.csv("/Users/mikeysoukup/Desktop/Python/F1/2020 Spanish GP Lap Times.csv")
df$Max.Verstappen <- ms(df$Max.Verstappen)
df$Lewis.Hamilton <- ms(df$Lewis.Hamilton)
df$Alex.Albon <- ms(df$Alex.Albon)
df$Valtteri.Bottas <- ms(df$Valtteri.Bottas)
df$Sebastian.Vettel <- ms(df$Sebastian.Vettel)

df$MV.s <- (df$Max.Verstappen@minute*60)+df$Max.Verstappen@.Data
df$LH.s <- (df$Lewis.Hamilton@minute*60)+df$Lewis.Hamilton@.Data
df$AA.s <- (df$Alex.Albon@minute*60)+df$Alex.Albon@.Data
df$SV.s <- (df$Sebastian.Vettel@minute*60)+df$Sebastian.Vettel@.Data
df$VB.s <- (df$Valtteri.Bottas@minute*60)+df$Valtteri.Bottas@.Data

MV <- c(round(min(df$MV.s), digits = 3), round(mean(df$MV.s), digits = 3),
        round(sd(df$MV.s), digits = 4), round(max(df$MV.s), digits = 3))
LH <- c(round(min(df$LH.s), digits = 3), round(mean(df$LH.s), digits = 3),
        round(sd(df$LH.s), digits = 4), round(max(df$LH.s), digits = 3))
VB <- c(round(min(df$VB.s), digits = 3), round(mean(df$VB.s), digits = 3),
        round(sd(df$VB.s), digits = 4), round(max(df$VB.s), digits = 3))
AA <- c(round(min(na.omit(df$AA.s)), digits = 3), 
        round(mean(na.omit(df$AA.s)), digits = 3), 
        round(sd(na.omit(df$AA.s)), digits = 4), 
        round(max(na.omit(df$AA.s)), digits = 3))
SV <- c(round(min(na.omit(df$SV.s)), digits = 3),
        round(mean(na.omit(df$SV.s)), digits = 3), 
        round(sd(na.omit(df$SV.s)), digits = 4), 
        round(max(na.omit(df$SV.s)), digits = 3))

M <- matrix(nrow = 5, ncol = 4)
colnames(M) <- c("Fastest Lap", "Average Lap","St. Dev","Longest Lap")
rownames(M) <- c("Lewis Hamilton","Max Verstappen","Valtteri Bottas","Sebastina Vettel",
                 "Alex Albon")
M[1,] <- LH
M[2,] <- MV
M[3,] <- VB
M[4,] <- SV
M[5,] <- AA
M
################################################################################
outlines <- c("M1" = "black", 
              "M2" = "gray", 
              "RP1" = "plum1",
              "RP2" = "plum1",
              "RB1" = 'navy',
              "RB2" = "firebrick",
              "F1" = "red",
              "Mc1" = "blue",
              "Mc2" = "orange",
              "R1" = "black",
              "R2" = "yellow",
              "F2" = "red",
              "AT1" = "navy",
              "AR1" = "firebrick",
              "AR2" = "firebrick",
              "H1" = "gray",
              "H2" = "dimgray",
              "AT2" = "gray",
              "W1" = "deepskyblue",
              "W2" = "deepskyblue")
fills <- c("M1" = "cyan1",
           "M2" = "cyan1", 
           "RP1" = "plum1",
           "RP2" = "white",
           "RB1" = "goldenrod1",
           "RB2" = "navy",
           "F1" = "red",
           "Mc1" = "orange",
           "Mc2" = "blue",
           "R1" = "yellow",
           "R2" = "black",
           "F2" = "yellow",
           "AT1" = "white",
           "AR1" = "olivedrab3",
           "AR2" = "white",
           "H1" = "red",
           "H2" = "red",
           "AT2" = "navy",
           "W1" = "white",
           "W2" = "black")
################################################################################



plot(x = df$Lap, y = df$Max.Verstappen, type = "p", col = "blue", pch = 16,
     xlab = "Lap", ylab = "Lap Time [=] sec", ylim = c(79, 105), cex = 0.5,
     main = "Lap Time Driver Breakdown | F1 2020 Spanish GP")
lines(x = df$Lap, y = df$Max.Verstappen, col = "blue")
points(x = df$Lap, y = df$Lewis.Hamilton, col = "cyan", pch = 16, cex = 0.5)
lines(x = df$Lap, y = df$Lewis.Hamilton, col = "cyan")
points(x = df$Lap, y = df$Valtteri.Bottas, col = "black", pch = 16, cex = 0.5)
lines(x = df$Lap, y = df$Valtteri.Bottas, col = "black")
points(x = df$Lap, y = df$Alex.Albon, col = "goldenrod", pch = 16, cex = 0.5)
lines(x = df$Lap, y = df$Alex.Albon, col = "goldenrod")
points(x = df$Lap, y = df$Sebastian.Vettel, col = "red", pch = 16, cex = 0.5)
lines(x = df$Lap, y = df$Sebastian.Vettel, col = "red")
legend("topleft", inset = 0.005 , legend = c("VER","HAM","BOT","ALB","VET"),
       col = c("blue","cyan","black","goldenrod","red"), lty = c(1,1,1), box.lty = 0)
grid(ny = length(seq(from = 79, to  = 105, by = 1)))



ggplot(data = df, aes(x = Lap)) +
  geom_line(aes(y = df$Max.Verstappen, color = "RB1")) +
  geom_point(aes(y = df$Max.Verstappen, fill = "RB1", color = "RB1")) +
  scale_fill_manual(guide = "legend",
                    name = "Driver",
                    values = fills) +
  scale_color_manual(name = "Driver",
                     values = outlines) +
  labs(x = "Lap", y = "Lap Time")

ggplot(data = df, aes(x = Lap)) +
  geom_line(aes(y = Max.Verstappen))

