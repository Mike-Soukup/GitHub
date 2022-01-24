import matplotlib.pyplot
from matplotlib.pyplot import *
import numpy
from numpy import *
import math
def f(x):
    return (41 + (2.18*x) - (0.732*x**2))

#Create Graph Window
xmin = 0
xmax = 9
ymin = -1500
ymax = 1500

#Set up Graph
figure()
x = arange(xmin,xmax+0.5,0.5)
y = []
for i in x:
    a = f(i)
    y = y +[a]
plot(x,y,'b')

title('Graph of Function')
grid()
hlines(0,xmin,xmax,color = 'k')
vlines(0,min(y),max(y),color = 'k')
show()
