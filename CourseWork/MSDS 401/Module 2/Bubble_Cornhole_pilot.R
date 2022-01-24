#Bubble Plot on Cornhole Board Example

#Load in necessary libraries
library(jpeg)
library(png)

#Load in image of cornhole board
wisc_board <- readPNG("/Users/mikeysoukup/Desktop/Python/Accuracy/Wisc_Board_Stand.png")
wisc_board

#Set up plot area with no plot
plot(x = c(1,2), y = c(1,4), type ='n', main = "",
     bty = "n", xaxt = 'n', yaxt = 'n', xlab = '', ylab ='')

#Get the plot information so the image will fill the plot box
lim <- par()
rasterImage(wisc_board,
            xleft = 1, xright = 2,
            ybottom = 1, ytop = 4)
