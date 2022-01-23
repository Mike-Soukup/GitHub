library(ggplot2)
library(plotly)
df <- read.csv("/Users/mikesoukup/Desktop/Python/F1/2021 Bahrain GP Lap Chart.csv")
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
LS.AM <- reorder(LS)
CS <- position_tracker(df1,55)
CS.F <- reorder(CS)
DR <- position_tracker(df1,3)
DR.Mc <- reorder(DR)
EO <- position_tracker(df1,31)
EO.AP <- reorder(EO)
SV <- position_tracker(df1,5)
SV.AM <- reorder(SV)
PG <- position_tracker(df1,10)
PG.AT <- reorder(PG)
SP <- position_tracker(df1,11)
SP.RB <- reorder(SP)
AG <- position_tracker(df1,99)
AG.AR <- reorder(AG)
KR <- position_tracker(df1,7)
KR.AR <- reorder(KR)
NL <- position_tracker(df1,6)
NL.W <- reorder(NL)
GR <- position_tracker(df1,63)
GR.W <- reorder(GR)
YS <- position_tracker(df1,22)
YS.AT <- reorder(YS)
MS <- position_tracker(df1,47)
MS.H <- reorder(MS)
FA <- position_tracker(df1,14)
FA.AP <- reorder(FA)
NM <- position_tracker(df1,9)
NM.H <- reorder(NM)

################################################################################
#Put data into dataframe

df.race <- data.frame(df$Lap)
df.race$LH.M <- LH.M
df.race$VB.M <- VB.M
df.race$MV.RB <- MV.RB
df.race$CL.F <- CL.F
df.race$LN.Mc <- LN.Mc
df.race$LS.AM <- LS.AM
df.race$CS.F <- CS.F
df.race$DR.Mc <- DR.Mc
df.race$EO.AP <- EO.AP
df.race$SV.AM <- SV.AM
df.race$PG.AT <- PG.AT
df.race$SP.RB <- SP.RB
df.race$AG.AR <- AG.AR
df.race$KR.AR <- KR.AR
df.race$NL.W <- NL.W
df.race$GR.W <- GR.W
df.race$YS.AT <- YS.AT
df.race$MS.H <- MS.H
df.race$FA.AP <- FA.AP
df.race$NM.H <- NM.H
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
           "AM1" = "chartreuse4",
           "AM2" = "plum1",
           "RB1" = "goldenrod1",
           "RB2" = "navy",
           "F1" = "red",
           "Mc1" = "orange",
           "Mc2" = "blue",
           "AP1" = "blue",
           "AP2" = "red",
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
              "AM1" = "chartreuse4",
              "AM2" = "chartreuse4",
              "RB1" = 'navy',
              "RB2" = "firebrick",
              "F1" = "red",
              "Mc1" = "blue",
              "Mc2" = "orange",
              "AP1" = "white",
              "AP2" = "blue",
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
a <- ggplot(data = df.race, aes(x = X)) +
  geom_line(aes(y = LH.M, color = "M1", group = 1, 
                text = "Lewis Hamilton")) +
  geom_point(aes(y = LH.M, fill = "M1", color = "M1", group = 1,
                 text = "Lewis Hamilton"), shape = 21) +
  geom_line(aes(y = VB.M, color = "M2", group = 1,
                text = "Valtteri Bottas")) +
  geom_point(aes(y = VB.M, fill = "M2", color = "M2", group = 1,
                 text = "Valtteri Bottas"), shape = 21) +
  geom_line(aes(y = SP.RB, color = "RB2", group = 1, 
                text = "Sergio Perez")) +
  geom_point(aes(y = SP.RB, fill = "RB2", color = "RB2", group = 1,
                 text = "Sergio Perez"), shape = 21) +
  geom_line(aes(y = LS.AM, color = "AM1", group = 1,
                text = "Lance Stroll")) +
  geom_point(aes(y = LS.AM, fill = "AM1", color = "AM1", group = 1,
                 text = "Lance Stroll"), shape = 21) +
  geom_line(aes(y = MV.RB, color = "RB1", group = 1,
                text = "Max Verstappen")) +
  geom_point(aes(y = MV.RB, fill = "RB1", color = "RB1", group = 1,
                 text = "Max Verstappen"), shape = 21) + 
  geom_line(aes(y = CL.F, color = "F1", group = 1,
                text = "Charles Leclerc")) +
  geom_point(aes(y = CL.F, fill = "F1", color = "F1", group = 1,
                 text = "Charles Leclerc"), shape = 21) +
  geom_line(aes(y = LN.Mc, color = "Mc1", group = 1, 
                text = "Lando Norris")) +
  geom_point(aes(y = LN.Mc, fill = "Mc1", color = "Mc1", group = 1,
                 text = "Lando Norris"), shape = 21) +
  geom_line(aes(y = CS.F, color = "F2", group = 1,
                text = "Carlos Sainz")) +
  geom_point(aes(y = CS.F, fill = "F2", color = "F2", group = 1,
                 text = "Carlos Sainz"), shape = 21) +
  geom_line(aes(y = DR.Mc, color = "Mc2", group = 1,
                text = "Daniel Ricciardo")) +
  geom_point(aes(y = DR.Mc, fill = "Mc2", color = "Mc2", group = 1,
                 text = "Daniel Ricciardo"), shape = 21) +
  geom_line(aes(y = EO.AP, color = "AP2", group = 1,
                text = "Esteban Ocon")) +
  geom_point(aes(y = EO.AP, fill = "AP2", color = "AP2", group = 1,
                 text = "Esteban Ocon"), shape = 21) +
  geom_line(aes(y = SV.AM, color = "AM2", group = 1,
                text = "Sebastian Vettel")) +
  geom_point(aes(y = SV.AM, fill = "AM2", color = "AM2", group = 1,
                 text = "Sebastian Vettel"), shape = 21) +
  geom_line(aes(y = PG.AT, color = "AT1", group = 1,
                text = "Pierre Gasly")) +
  geom_point(aes(y = PG.AT, fill = "AT1", color = "AT1", group = 1,
                 text = "Pierre Gasly"), shape = 21) +
  geom_line(aes(y = AG.AR, color = "AR1", group = 1,
                text = "Antonio Giovinazzi")) +
  geom_point(aes(y = AG.AR, fill = "AR1", color = "AR1", group = 1,
                 text = "Antonio Giovinazzi"), shape = 21) +
  geom_line(aes(y = KR.AR, color = "AR2", group = 1,
                text = "Kimi Raikkonen")) +
  geom_point(aes(y = KR.AR, fill = "AR2", color = "AR2", group = 1,
                 text = "Kimi Raikkonen"), shape = 21) +
  geom_line(aes(y = NL.W, color = "W2", group = 1,
                text = "Nicholas Latifi")) + 
  geom_point(aes(y = NL.W, fill = "W2", color = "W2", group = 1,
                 text = "Nicholas Latifi"), shape = 21) +
  geom_line(aes(y = GR.W, color = "W1", group = 1, 
                text = "George Russell")) + 
  geom_point(aes(y = GR.W, fill = "W1", color = "W1", group = 1,
                 text = "George Russell"), shape = 21) +
  geom_line(aes(y = YS.AT, color = "AT2", group = 1,
                text = "Yuki Tsunoda")) + 
  geom_point(aes(y = YS.AT, fill = "AT2", color = "AT2", group = 1,
                 text = "Yuki Tsunoda"), shape = 21) +
  geom_line(aes(y = MS.H, color = "H1", group = 1,
                text = "Mick Schumacher")) + 
  geom_point(aes(y = MS.H, fill = "H1", color = "H1",group = 1,
                 text = "Mick Schumacher"), shape = 21) +
  geom_line(aes(y = FA.AP, color = "AP1", group = 1,
                text = "Fernando Alonso")) + 
  geom_point(aes(y = FA.AP, fill = "AP1", color = "AP1", group = 1,
                 text = "Fernando Alonso"), shape = 21) +
  geom_line(aes(y = NM.H, color = "H2", group = 1,
                text = "Nikita Mazepin")) + 
  geom_point(aes(y = NM.H, fill = "H2", color = "H2", group = 1,
                 text = "Nikita Mazepin"), shape = 21) +
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
  labs(title = "2021 Bahrain Grand Prix", x = "Lap", y = "Position") +
  theme(axis.text.x = element_text(angle = 90),
        plot.title = element_text(hjust = 0.5),
        legend.position = 'none') 

b <- ggplotly(a, tooltip = "text")
################################################################################

#Load into Plotly Chart Studio
Sys.setenv("plotly_username"="mtsoukup9")
Sys.setenv("plotly_api_key"="rrCFIpa44993bsoCvt5U")
api_create(b, filename = "2021-Bahrain-GP-Lapchart")