import numpy
from numpy import arange, cos
import matplotlib.pyplot
from matplotlib.pyplot import *
import math

#Create a function to calculate the derivative at a specific point listed
def f(x):
    '''Input a function and output the values of the function at x'''
    f = (x**2) + 6*x -7#Enter function here
    return f

def derivative(x,function):
    '''Approximate the slope/derivative of a function at x'''
    h = 0.000000001
    m = (function(x+h)-function(x))/h
    return m
def calc_b(y,x,m):
    '''Calculat b given a point y + x and a slope m'''
    return y - m*x

#First Plot the function
xmin = 0
xmax = 10
t = numpy.linspace(0,xmax,500)
deriv_location = 4
p_t = f(t)
p_der = f(deriv_location)
#Next, plot the slope tangent line at x = deriv_location
m = derivative(deriv_location,f)
b = calc_b(p_der,deriv_location,m)
y = []
for i in t:
    y = y + [m*i + b]
figure()
plot(t,p_t,'b-',label='f(x)')
plot(t,y,'k-',label = 'tangent with m = {}'.format(round(m,5)))
scatter(deriv_location,p_der,s=40,c='r')
xlabel('X')
ylabel('Y')
legend()
show()