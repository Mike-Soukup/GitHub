import matplotlib.pyplot
from matplotlib.pyplot import *
import numpy
import math
from Numerical_Integration import integrate_trap

mu = 23
a = 1/mu

def f(x):
    return (a*math.exp(-a*x))
xmin = 0
xmax = 75
step = 0.1
x = numpy.arange(xmin,xmax+step,step)
y = []
for i in x:
    y = y + [f(i)]
figure()
plot(x,y,'r-')
show()

for i in x:
    b = 100*integrate_trap(xmin,i,500)
    print('Minutes = {:<.2f} Percent of Predators that found prey {:<.3f}%'.format(i,b))