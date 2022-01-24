import numpy
from numpy import *
import matplotlib.pyplot
from matplotlib.pyplot import *
import math

def extrema(a,b,c):
    '''For three input values a, b, c, this function will tell you if b is an extrema point, max or min.
    Will output Boolean True or False.'''
    x = max(a,b,c) 
    z = min(a,b,c) 
    epsilon = 0.0000001 
    result = False
    if abs(b-x) < epsilon:
        result = True
    if abs(b-z) < epsilon:
        result = True
    return result

def f(x):
    y = (7*x)*(math.exp(-x/15))  ######################
    return y

xa = 0           ############################################################################################
xb = 30      ############################################################################################

n = 1000
delta = (xb-xa)/n
x = np.arange(xa, xb + delta, delta)
y = []
for i in x:
    y = y + [f(i)]

value = [False] 
value = value*len(x)

L = len(x)
value[0] = True
value[L-1] = True

for x_index in range(L-2):
    first_x = x[x_index]
    second_x = x[x_index + 1]
    third_x = x[x_index + 2]  
    a = f(first_x)
    b = f(second_x)
    c = f(third_x)
    is_second_x_extrema = extrema(a,b,c)
    value[x_index + 1] = is_second_x_extrema 

max_value = max(y) 
min_value = min(y) 

error = 0.0000001
figure()
for k in range(L):
    if value[k] is True:
        scatter(x[k],y[k], s = 60, c = 'y')
        print('x value : {} y value: {}'.format(x[k],round(y[k],4)))
        if abs(max_value - y[k]) < error:
            scatter(x[k],y[k],s=60,c='r')
            print('Absolue Max: {} @ {}'.format(round(y[k],4),x[k]))
        if abs(min_value - y[k]) < error:
            scatter(x[k],y[k],s=60,c='b')
            print('Absolute Min: {} @ {}'.format(round(y[k],4),x[k]))
plot(x,y,c='k')
xlabel('x-axis')
ylabel('y-axis')
title('Plot showing absolute and relative extrema')
show()