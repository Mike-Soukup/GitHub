import Numerical_Integration
from Numerical_Integration import integrate_trap, integrate_midpoint
import matplotlib.pyplot
from matplotlib.pyplot import *
import numpy
from numpy import *
import math
from Limit_as_x_infinity import gen_inf
def f(x):
    return (66*math.log(x+1))/(x+1)

#Create Graph Window
xmin = 0
xmax = 120
ymin = 0
ymax = 100
step = 0.01

#Set up Graph
figure()
x = arange(xmin,xmax+step,step)
y = []
for i in x:
    a = f(i)
    y = y +[a]
plot(x,y,'b')
title('Graph of Function')
hlines(0,xmin,xmax,color = 'k')
show()

first_day = integrate_trap(0,24,1000)
print('The total number of barrels the ship will leak on the first day is {}'.format(first_day))
second_day = integrate_trap(24,48,1000)
print('The total number of barrels the ship will leak on the second day is {}'.format(second_day))
gen_inf()