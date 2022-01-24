#First read in libraries
library(ggplot2)
library(dplyr)
library(ggpubr)
library(RPostgres)
library(DBI)
library(grid)
library(glue)
library(png)
library(gridExtra)

#Define the database specific information
db <- 'Accuracy'
host_db <- 'localhost'
db_port <- 5432
db_user <- 'postgres'
db_password <- 'iamgreat'

#establish connection to database
con <- dbConnect(RPostgres::Postgres(), dbname = db, host=host_db, port=db_port,
                 user=db_user, password=db_password)  

#Read in data from PostgreSQL
df <- dbGetQuery(con, 'SELECT * 
                       FROM public.heatmapdata
                       WHERE id = 1
                       ORDER BY "date" ASC')

#df <- df[df$date == '2020-09-08',]
#df <- df[df$side_of_board == 'left',]

#Set up empty matrices
land.mat <- matrix(data = 0, nrow = 8, ncol = 5)
rownames(land.mat) <- c("1","2","3","4","5","6","7","8")
colnames(land.mat) <- c("1","2","3","4","5")
out.mat <- matrix(data = 0, nrow = 8, ncol = 5)
rownames(out.mat) <- c("1","2","3","4","5","6","7","8")
colnames(out.mat) <- c("1","2","3","4","5")

#Fill in matrices from recorded data
for (i in 1:nrow(df)){
  if (df[i,]$h_landzone == 1){
    if (df[i,]$v_landzone == 1){
      land.mat[1,1] <- land.mat[1,1] + 1
      if (df[i,]$outcome == 1){
        out.mat[1,1] <- out.mat[1,1] + 1
      }
    }
    if (df[i,]$v_landzone == 2){
      land.mat[2,1] <- land.mat[2,1] + 1
      if (df[i,]$outcome == 1){
        out.mat[2,1] <- out.mat[2,1] + 1
      }
    }
    if (df[i,]$v_landzone == 3){
      land.mat[3,1] <- land.mat[3,1] + 1
      if (df[i,]$outcome == 1){
        out.mat[3,1] <- out.mat[3,1] + 1
      }
    }
    if (df[i,]$v_landzone == 4){
      land.mat[4,1] <- land.mat[4,1] + 1
      if (df[i,]$outcome == 1){
        out.mat[4,1] <- out.mat[4,1] + 1
      }
    }
    if (df[i,]$v_landzone == 5){
      land.mat[5,1] <- land.mat[5,1] + 1
      if (df[i,]$outcome == 1){
        out.mat[5,1] <- out.mat[5,1] + 1
      }
    }
    if (df[i,]$v_landzone == 6){
      land.mat[6,1] <- land.mat[6,1] + 1
      if (df[i,]$outcome == 1){
        out.mat[6,1] <- out.mat[6,1] + 1
      }
    }
    if (df[i,]$v_landzone == 7){
      land.mat[7,1] <- land.mat[7,1] + 1
      if (df[i,]$outcome == 1){
        out.mat[7,1] <- out.mat[7,1] + 1
      }
    }
    if (df[i,]$v_landzone == 8){
      land.mat[8,1] <- land.mat[8,1] + 1
      if (df[i,]$outcome == 1){
        out.mat[8,1] <- out.mat[8,1] + 1
      }
    }
  }
  if (df[i,]$h_landzone == 2){
    if (df[i,]$v_landzone == 1){
      land.mat[1,2] <- land.mat[1,2] + 1
      if (df[i,]$outcome == 1){
        out.mat[1,2] <- out.mat[1,2] + 1
      }
    }
    if (df[i,]$v_landzone == 2){
      land.mat[2,2] <- land.mat[2,2] + 1
      if (df[i,]$outcome == 1){
        out.mat[2,2] <- out.mat[2,2] + 1
      }
    }
    if (df[i,]$v_landzone == 3){
      land.mat[3,2] <- land.mat[3,2] + 1
      if (df[i,]$outcome == 1){
        out.mat[3,2] <- out.mat[3,2] + 1
      }
    }
    if (df[i,]$v_landzone == 4){
      land.mat[4,2] <- land.mat[4,2] + 1
      if (df[i,]$outcome == 1){
        out.mat[4,2] <- out.mat[4,2] + 1
      }
    }
    if (df[i,]$v_landzone == 5){
      land.mat[5,2] <- land.mat[5,2] + 1
      if (df[i,]$outcome == 1){
        out.mat[5,2] <- out.mat[5,2] + 1
      }
    }
    if (df[i,]$v_landzone == 6){
      land.mat[6,2] <- land.mat[6,2] + 1
      if (df[i,]$outcome == 1){
        out.mat[6,2] <- out.mat[6,2] + 1
      }
    }
    if (df[i,]$v_landzone == 7){
      land.mat[7,2] <- land.mat[7,2] + 1
      if (df[i,]$outcome == 1){
        out.mat[7,2] <- out.mat[7,2] + 1
      }
    }
    if (df[i,]$v_landzone == 8){
      land.mat[8,2] <- land.mat[8,2] + 1
      if (df[i,]$outcome == 1){
        out.mat[8,2] <- out.mat[8,2] + 1
      }
    }
  }
  if (df[i,]$h_landzone == 3){
    if (df[i,]$v_landzone == 1){
      land.mat[1,3] <- land.mat[1,3] + 1
      if (df[i,]$outcome == 1){
        out.mat[1,3] <- out.mat[1,3] + 1
      }
    }
    if (df[i,]$v_landzone == 2){
      land.mat[2,3] <- land.mat[2,3] + 1
      if (df[i,]$outcome == 1){
        out.mat[2,3] <- out.mat[2,3] + 1
      }
    }
    if (df[i,]$v_landzone == 3){
      land.mat[3,3] <- land.mat[3,3] + 1
      if (df[i,]$outcome == 1){
        out.mat[3,3] <- out.mat[3,3] + 1
      }
    }
    if (df[i,]$v_landzone == 4){
      land.mat[4,3] <- land.mat[4,3] + 1
      if (df[i,]$outcome == 1){
        out.mat[4,3] <- out.mat[4,3] + 1
      }
    }
    if (df[i,]$v_landzone == 5){
      land.mat[5,3] <- land.mat[5,3] + 1
      if (df[i,]$outcome == 1){
        out.mat[5,3] <- out.mat[5,3] + 1
      }
    }
    if (df[i,]$v_landzone == 6){
      land.mat[6,3] <- land.mat[6,3] + 1
      if (df[i,]$outcome == 1){
        out.mat[6,3] <- out.mat[6,3] + 1
      }
    }
    if (df[i,]$v_landzone == 7){
      land.mat[7,3] <- land.mat[7,3] + 1
      if (df[i,]$outcome == 1){
        out.mat[7,3] <- out.mat[7,3] + 1
      }
    }
    if (df[i,]$v_landzone == 8){
      land.mat[8,3] <- land.mat[8,3] + 1
      if (df[i,]$outcome == 1){
        out.mat[8,3] <- out.mat[8,3] + 1
      }
    }
  }
  if (df[i,]$h_landzone == 4){
    if (df[i,]$v_landzone == 1){
      land.mat[1,4] <- land.mat[1,4] + 1
      if (df[i,]$outcome == 1){
        out.mat[1,4] <- out.mat[1,4] + 1
      }
    }
    if (df[i,]$v_landzone == 2){
      land.mat[2,4] <- land.mat[2,4] + 1
      if (df[i,]$outcome == 1){
        out.mat[2,4] <- out.mat[2,4] + 1
      }
    }
    if (df[i,]$v_landzone == 3){
      land.mat[3,4] <- land.mat[3,4] + 1
      if (df[i,]$outcome == 1){
        out.mat[3,4] <- out.mat[3,4] + 1
      }
    }
    if (df[i,]$v_landzone == 4){
      land.mat[4,4] <- land.mat[4,4] + 1
      if (df[i,]$outcome == 1){
        out.mat[4,4] <- out.mat[4,4] + 1
      }
    }
    if (df[i,]$v_landzone == 5){
      land.mat[5,4] <- land.mat[5,4] + 1
      if (df[i,]$outcome == 1){
        out.mat[5,4] <- out.mat[5,4] + 1
      }
    }
    if (df[i,]$v_landzone == 6){
      land.mat[6,4] <- land.mat[6,4] + 1
      if (df[i,]$outcome == 1){
        out.mat[6,4] <- out.mat[6,4] + 1
      }
    }
    if (df[i,]$v_landzone == 7){
      land.mat[7,4] <- land.mat[7,4] + 1
      if (df[i,]$outcome == 1){
        out.mat[7,4] <- out.mat[7,4] + 1
      }
    }
    if (df[i,]$v_landzone == 8){
      land.mat[8,4] <- land.mat[8,4] + 1
      if (df[i,]$outcome == 1){
        out.mat[8,4] <- out.mat[8,4] + 1
      }
    }
  }
  if (df[i,]$h_landzone == 5){
    if (df[i,]$v_landzone == 1){
      land.mat[1,5] <- land.mat[1,5] + 1
      if (df[i,]$outcome == 1){
        out.mat[1,5] <- out.mat[1,5] + 1
      }
    }
    if (df[i,]$v_landzone == 2){
      land.mat[2,5] <- land.mat[2,5] + 1
      if (df[i,]$outcome == 1){
        out.mat[2,5] <- out.mat[2,5] + 1
      }
    }
    if (df[i,]$v_landzone == 3){
      land.mat[3,5] <- land.mat[3,5] + 1
      if (df[i,]$outcome == 1){
        out.mat[3,5] <- out.mat[3,5] + 1
      }
    }
    if (df[i,]$v_landzone == 4){
      land.mat[4,5] <- land.mat[4,5] + 1
      if (df[i,]$outcome == 1){
        out.mat[4,5] <- out.mat[4,5] + 1
      }
    }
    if (df[i,]$v_landzone == 5){
      land.mat[5,5] <- land.mat[5,5] + 1
      if (df[i,]$outcome == 1){
        out.mat[5,5] <- out.mat[5,5] + 1
      }
    }
    if (df[i,]$v_landzone == 6){
      land.mat[6,5] <- land.mat[6,5] + 1
      if (df[i,]$outcome == 1){
        out.mat[6,5] <- out.mat[6,5] + 1
      }
    }
    if (df[i,]$v_landzone == 7){
      land.mat[7,5] <- land.mat[7,5] + 1
      if (df[i,]$outcome == 1){
        out.mat[7,5] <- out.mat[7,5] + 1
      }
    }
    if (df[i,]$v_landzone == 8){
      land.mat[8,5] <- land.mat[8,5] + 1
      if (df[i,]$outcome == 1){
        out.mat[8,5] <- out.mat[8,5] + 1
      }
    }
  }
}

#Get totals made and totals landed from each matrix
throws.landed <- sum(land.mat)
throws.made <- sum(out.mat)

#Convert the matrix data into a data frame
land.df <- as.data.frame(as.table(land.mat))
names(land.df)[1] <- "Y"
names(land.df)[2] <- "X"
names(land.df)[3] <- "LandFreq"
out.df <- as.data.frame(as.table(out.mat))
names(out.df)[1] <- "Y"
names(out.df)[2] <- "X"
names(out.df)[3] <- "MakeFreq"

#Freq = Counts; Prop = Proportions

#Convert Landed Frequencies to Landed Proportions
land.df$LandProp <- round(100*(land.df$LandFreq/throws.landed), digits = 2)

#Put Make Counts into the land.df dataframe
land.df$MakeFreq <- out.df$MakeFreq

#TotMakeProp = Proportion of made throw at that location over the total made
land.df$TotMakeProp <- round(100*(land.df$MakeFreq/throws.made), digits = 2)

#RelMakeProp = What percentage of bags made that landed at that location
land.df$RelMakeProp <- round(100*(land.df$MakeFreq/land.df$LandFreq), digits = 2)

#Get rid of NaN in the data frame and replace with 0
land.df[is.na(land.df)] <- 0

#Now plot the data | Bubble Chart, size =  LandProp and Color = Relative Make Prop

ggplot(land.df, aes(x = X, y = Y, size = LandProp, color = RelMakeProp)) +
  geom_point( alpha = 0.5) +
  scale_color_gradient(low = "dodgerblue", high = "firebrick") +
  scale_size(range = c(0,60)) + 
  theme(legend.position = "none", panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.title = element_blank(),
        axis.ticks = element_blank(), axis.text = element_blank()) + 
  coord_fixed()

#Now plot the data | with geom_bin2d() | Plot Landing Proportion

  ggplot(land.df, aes(x = X, y = Y, fill = LandProp)) +
  geom_bin2d(alpha = 0.8) +
  scale_fill_gradient(low = "white", high = "firebrick") +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

#Now plot the data | with geom_bin2d() | Plot Relative Make Proportion

  ggplot(land.df, aes(x = X, y = Y, fill = RelMakeProp)) +
  geom_bin2d(alpha = 0.8) +
  scale_fill_gradient(low = "white", high = "firebrick") +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

#Now plot the data | with geom_bin2d() | Plot Total Make Proportion

ggplot(land.df, aes(x = X, y = Y, fill = TotMakeProp)) +
  geom_bin2d(alpha = 0.8) +
  scale_fill_gradient(low = "dodgerblue", high = "firebrick") +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())


################################################################################
#Re-create same plots above with board background image
img <- png::readPNG('/Users/mikeysoukup/Desktop/Python/Accuracy/W_bag_board.png')

#Now plot the data | Bubble Chart, size =  LandProp and Color = Relative Make Prop

  ggplot(land.df, aes(x = X, y = Y, size = LandProp, color = RelMakeProp)) +
  background_image(img) +
  geom_point( alpha = 0.8) +
  scale_color_gradient(low = "dodgerblue", high = "firebrick") +
  scale_size(range = c(0,60)) + 
  theme(legend.position = "none", panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(), axis.title = element_blank(),
        axis.ticks = element_blank(), axis.text = element_blank()) + 
  coord_fixed()

#Now plot the data | with geom_bind2d() | Plot Landing Counts/Frequencies

ggplot(land.df, aes(x = X, y = Y, fill = LandFreq)) +
  background_image(img) +
  geom_bin2d(alpha = 0.8) +
  scale_fill_gradient(low = "white", high = "firebrick") +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

#Now plot the data | with geom_bin2d() | Plot Landing Proportion
#Where am I landing? What percentage of time and I landing here?

  ggplot(land.df, aes(x = X, y = Y, fill = LandProp)) +
  background_image(img) +
  geom_bin2d(alpha = 0.8) +
  scale_fill_gradient(low = "white", high = "firebrick") +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

#Now plot the data | with geom_bin2d() | Plot Total Make Frequency
#Where am I making the bags at? What locations are leading to made bags

ggplot(land.df, aes(x = X, y = Y, fill = MakeFreq)) +
  background_image(img) +
  geom_bin2d(alpha = 0.8) +
  scale_fill_gradient(low = "white", high = "firebrick") +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())


#Plot the data | with geom_bind2d() | Plot total Make Proportion
ggplot(land.df, aes(x = X, y = Y, fill = TotMakeProp)) +
  background_image(img) +
  geom_bin2d(alpha = 0.8) +
  scale_fill_gradient(low = "white", high = "firebrick") +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

#Now plot the data | with geom_bin2d() | Plot Relative Make Proportion

  ggplot(land.df, aes(x = X, y = Y, fill = RelMakeProp)) +
  background_image(img) +
  geom_bin2d(alpha = 0.8) +
  scale_fill_gradient(low = "white", high = "firebrick") +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

grid.arrange(a,b,ncol = 2, nrow = 1)


################################################################################
#Test
dd <- data.frame(x = 1:10, y = 1:10)
base <- ggplot(dd, aes(x,y)) +
  geom_blank() +
  theme_bw()
base + annotation_custom(grob = grid::roundrectGrob(),
                         xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf)

base.test <- ggplot(land.df, aes(x = X, y = Y, fill = LandProp)) +
  geom_blank() +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

grb <- ggplotGrob(ggplot(land.df, aes(x = X, y = Y, fill = LandProp)) +
                    geom_bin2d(alpha = 0.8) +
                    scale_fill_gradient(low = "dodgerblue", high = "firebrick") +
                    coord_fixed() +
                    theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
                          panel.background = element_blank(), plot.background = element_blank(),
                          text = element_blank(), axis.ticks = element_blank(), 
                          legend.position = "none"))

base.test + annotation_custom(grob = grb,
                              xmin = -5.55, xmax = 11.5, ymin = 0.1, ymax = 8.825)

ggplot_build(base.test)$layout$panel_ranges[[1]]$y.range
ggplot_build(base.test)$layout$panel_ranges[[1]]$x.range

ggplot_build(base.test)$layout$panel_params$panel_scales_x
ggplot_build(base.test)$layout$panel_params$panel_scales_y

heat.base <- ggplot(land.df, aes(x = X, y = Y, fill = LandProp)) +
  geom_bin2d(alpha = 0.8) +
  scale_fill_gradient(low = "dodgerblue", high = "firebrick") +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

grb1 <- ggplotGrob(ggplot() +
                     background_image(img))

heat.base + annotation_custom(grob = grb1)


#Test option 2

g <- rasterGrob(img, width = unit(1,"npc"), height = unit(1,"npc"),
                interpolate = FALSE)

plt <- ggplot(data = land.df) +
  annotation_custom(g, xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf) +
  geom_bin2d(aes(x = X, y = Y, fill = RelMakeProp), alpha = 0.8) +
  scale_fill_gradient(low = "dodgerblue", high = "firebrick") +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),
        panel.grid.minor = element_blank()) +
  scale_y_discrete(labels = as.character(1:8))


plt

#Test Option 3

ggplot(data = land.df, aes(x = X, y = Y, fill = RelMakeProp)) +
  annotation_custom(rasterGrob(img, width = unit(1,"npc"),
                               height = unit(1,"npc")),
                    -Inf,Inf,-Inf, Inf) +
  geom_bin2d() +
  scale_x_continuous(expand = c(0,0)) +
  scale_y_continuous(expand = c(0,0))


#Test Option 4

ggplot(land.df, aes(x = X, y = Y, fill = LandProp)) +
  background_image(img) +
  geom_bin2d(alpha = 0.8, binwidth = 0.5) +
  scale_fill_gradient(low = "dodgerblue", high = "firebrick") +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank()) +
  scale_x_continuous(expand = c(0,0)) +
  scale_y_continuous(expand = c(0,0))


#Test option 1
dd <- data.frame(x = 1:10, y = 1:10)
base <- ggplot(dd, aes(x,y)) +
  geom_blank() +
  theme_bw()
base + annotation_custom(grob = grid::roundrectGrob(),
                         xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf)

base.test <- ggplot(land.df, aes(x = X, y = Y, fill = LandProp)) +
  background_image(img) +
  geom_blank() +
  coord_fixed() +
  theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank())

grb <- ggplotGrob(ggplot(land.df, aes(x = X, y = Y, fill = LandProp)) +
                    geom_bin2d(alpha = 0.8) +
                    scale_fill_gradient(low = "dodgerblue", high = "firebrick") +
                    coord_fixed() +
                    theme(panel.grid.major = element_blank(),panel.grid.minor = element_blank(),
                          panel.background = element_blank(), plot.background = element_blank(),
                          text = element_blank(), axis.ticks = element_blank(), 
                          legend.position = "none"))

base.test + annotation_custom(grob = grb,
                              xmin = -4.85, xmax = 10.8, ymin = 0.1, ymax = 8.825)
