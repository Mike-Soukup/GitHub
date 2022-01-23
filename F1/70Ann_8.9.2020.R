library(ggplot2)
df <- read.csv("/Users/mikesoukup/Desktop/Python/F1/2020 Spanish GP.csv")
colnames(df) <- c("Lap",seq(from = 1, to = 20, by = 1))

df1 <- df[,2:21]
drivers <- as.numeric(unique(df1[1,]))

position_tracker <- function(df,driver){
  position <- numeric(0)
  for (i in 1:nrow(df)){
    position <- append(position,which(df[i,] == driver))
  }
  position.1 <- numeric(length = nrow(df))
  position.1[1:length(position)] <- position
  return(position.1)
}

reorder <- function(D){
  nD <- numeric(length(D))
  for (i in 1:length(D)){
    if (D[i] == 1){nD[i] <- 20}
    if (D[i] == 2){nD[i] <- 19}
    if (D[i] == 3){nD[i] <- 18}
    if (D[i] == 4){nD[i] <- 17}
    if (D[i] == 5){nD[i] <- 16}
    if (D[i] == 6){nD[i] <- 15}
    if (D[i] == 7){nD[i] <- 14}
    if (D[i] == 8){nD[i] <- 13}
    if (D[i] == 9){nD[i] <- 12}
    if (D[i] == 10){nD[i] <- 11}
    if (D[i] == 11){nD[i] <- 10}
    if (D[i] == 12){nD[i] <- 9}
    if (D[i] == 13){nD[i] <- 8}
    if (D[i] == 14){nD[i] <- 7}
    if (D[i] == 15){nD[i] <- 6}
    if (D[i] == 16){nD[i] <- 5}
    if (D[i] == 17){nD[i] <- 4}
    if (D[i] == 18){nD[i] <- 3}
    if (D[i] == 19){nD[i] <- 2}
    if (D[i] == 20){nD[i] <- 1}
  }
  return(nD)
}
################################################################################
#Format data
LH <- position_tracker(df1,44)
LH.M <- reorder(LH)
VB <- position_tracker(df1,77)
VB.M <- reorder(VB)
MV <- position_tracker(df1,33)
MV.RB <- reorder(MV)
CL <- position_tracker(df1,16)
CL.F <- reorder(CL)
LN <- position_tracker(df1,4)
LN.Mc <- reorder(LN)
LS <- position_tracker(df1,18)
LS.RP <- reorder(LS)
CS <- position_tracker(df1,55)
CS.Mc <- reorder(CS)
DR <- position_tracker(df1,3)
DR.R <- reorder(DR)
EO <- position_tracker(df1,31)
EO.R <- reorder(EO)
SV <- position_tracker(df1, 5)
SV.F <- reorder(SV)
PG <- position_tracker(df1,10)
PG.AT <- reorder(PG)
AA <- position_tracker(df1,23)
AA.RB <- reorder(AA)
SP <- position_tracker(df1,11)
SP.RP <- reorder(SP)
KM <- position_tracker(df1,20)
KM.H <- reorder(KM)
AG <- position_tracker(df1,99)
AG.AR <- reorder(AG)
KR <- position_tracker(df1,7)
KR.AR <- reorder(KR)
RG <- position_tracker(df1,8)
RG.H <- reorder(RG)
NL <- position_tracker(df1,6)
NL.W <- reorder(NL)
DK <- position_tracker(df1,26)
DK.AT <- reorder(DK)
GR <- position_tracker(df1,63)
GR.W <- reorder(GR)

################################################################################
#Put data into dataframe

df.race <- data.frame(df$Lap)
df.race$LH.M <- LH.M
df.race$VB.M <- VB.M
df.race$MV.RB <- MV.RB
df.race$CL.F <- CL.F
df.race$LN.Mc <- LN.Mc
df.race$LS.RP <- LS.RP
df.race$CS.Mc <- CS.Mc
df.race$DR.R <- DR.R
df.race$EO.R <- EO.R
df.race$SV.F <- SV.F
df.race$PG.AT <- PG.AT
df.race$AA.RB <- AA.RB
df.race$SP.RP <- SP.RP
df.race$KM.H <- KM.H
df.race$AG.AR <- AG.AR
df.race$KR.AR <- KR.AR
df.race$RG.H <- RG.H
df.race$NL.W <- NL.W
df.race$DK.AT <- DK.AT
df.race$GR.W <- GR.W
df.race$X <- c(1:nrow(df))

################################################################################
#Create graphic

x <- c(1:nrow(df))
mom <- c(df$Lap[1],seq(from =1, to = nrow(df)-1, by = 1))
y <- c(0:20)
ylab <- c("Ret",20:1)
################################################################################
#Fill colors
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
#Outline colors
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
################################################################################
#Driver label

dlab <- rev(c(as.character(drivers),""))

################################################################################
#Plot creation
ggplot(data = df.race, aes(x = X)) +
  geom_line(aes(y = LH.M, color = "M1")) +
  geom_point(aes(y = LH.M, fill = "M1", color = "M1"), shape = 21) +
  geom_line(aes(y = VB.M, color = "M2")) +
  geom_point(aes(y = VB.M, fill = "M2", color = "M2"), shape = 21) +
  geom_line(aes(y = SP.RP, color = "RP1")) +
  geom_point(aes(y = SP.RP, fill = "RP1", color = "RP1"), shape = 21) +
  geom_line(aes(y = LS.RP, color = "RP2")) +
  geom_point(aes(y = LS.RP, fill = "RP2", color = "RP2"), shape = 21) +
  geom_line(aes(y = MV.RB, color = "RB1")) +
  geom_point(aes(y = MV.RB, fill = "RB1", color = "RB1"), shape = 21) + 
  geom_line(aes(y = AA.RB, color = "RB2")) +
  geom_point(aes(y = AA.RB, fill = "RB2", color = "RB2"), shape = 21) +
  geom_line(aes(y = CL.F, color = "F1")) +
  geom_point(aes(y = CL.F, fill = "F1", color = "F1"), shape = 21) +
  geom_line(aes(y = LN.Mc, color = "Mc1")) +
  geom_point(aes(y = LN.Mc, fill = "Mc1", color = "Mc1"), shape = 21) +
  geom_line(aes(y = CS.Mc, color = "Mc2")) +
  geom_point(aes(y = CS.Mc, fill = "Mc2", color = "Mc2"), shape = 21) +
  geom_line(aes(y = DR.R, color = "R1")) +
  geom_point(aes(y = DR.R, fill = "R1", color = "R1"), shape = 21) +
  geom_line(aes(y = EO.R, color = "R2")) +
  geom_point(aes(y = EO.R, fill = "R2", color = "R2"), shape = 21) +
  geom_line(aes(y = SV.F, color = "F2")) +
  geom_point(aes(y = SV.F, fill = "F2", color = "F2"), shape = 21) +
  geom_line(aes(y = PG.AT, color = "AT1")) +
  geom_point(aes(y = PG.AT, fill = "AT1", color = "AT1"), shape = 21) +
  geom_line(aes(y = AG.AR, color = "AR1")) +
  geom_point(aes(y = AG.AR, fill = "AR1", color = "AR1"), shape = 21) +
  geom_line(aes(y = KR.AR, color = "AR2")) +
  geom_point(aes(y = KR.AR, fill = "AR2", color = "AR2"), shape = 21) +
  geom_line(aes(y = KM.H, color = "H1")) +
  geom_point(aes(y = KM.H, fill = "H1", color = "H1"), shape = 21) +
  geom_line(aes(y = RG.H, color = "H2")) +
  geom_point(aes(y = RG.H, fill = "H2", color = "H2"), shape = 21) +
  geom_line(aes(y = NL.W, color = "W2")) + 
  geom_point(aes(y = NL.W, fill = "W2", color = "W2"), shape = 21) +
  geom_line(aes(y = DK.AT, color = "AT2")) +
  geom_point(aes(y = DK.AT, fill = "AT2", color = "AT2"), shape = 21) +
  geom_line(aes(y = GR.W, color = "W1")) + 
  geom_point(aes(y = GR.W, fill = "W1", color = "W1"), shape = 21) +
  scale_x_continuous(name = "Lap", breaks = c(seq(1,nrow(df),1)),
                     labels = mom) +
  scale_y_continuous(name = "Driver", breaks = y, limits = c(0,20),
                     labels = dlab,
                     sec.axis = sec_axis(~ ., breaks = y, labels = ylab,
                                         name = "Position")) +
  scale_fill_manual(guide = "legend",
                    name = "Driver",
                    values = fills) +
  scale_color_manual(name = "Driver",
                     values = outlines) +
  guides(color = FALSE, fill = FALSE) +
  labs(title = "2020 F1 70th Anniversary", x = "Lap", y = "Position") +
  theme(axis.text.x = element_text(angle = 90),
        plot.title = element_text(hjust = 0.5)) 
################################################################################
#Read in pit stop summary for race
ps <- read.csv("/Users/mikeysoukup/Desktop/Python/F1/GB 70 Ann PitSummary.csv")

RB_ps <- ps[ps$Team == "Aston Martin Red Bull Racing",]



