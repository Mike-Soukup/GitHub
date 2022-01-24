import numpy
from numpy import arange, cos
import matplotlib.pyplot
from matplotlib.pyplot import *

#Create a function to calculate the derivative at a specific point listed
def f(x):
    '''Input a function and output the values of the function at x'''
    f = 38.06*(1.016**x)#Enter function here
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
xmax = 50
t = numpy.linspace(0,50,500)
p_t = f(t)
p_10 = f(10)
print('The population in 2010 is {} million people'.format(p_10))
#Next, plot the slope tangent line at t = 10
m = derivative(10,f)
b = calc_b(p_10,10,m)
y = []
for i in t:
    y = y + [m*i + b]
figure()
plot(t,p_t,'b-',label='p(t)')
plot(t,y,'k-',label = 'tangent with m = {}'.format(round(m,5)))
scatter(10,p_10,s=40,c='r')
xlabel('Years')
ylabel('Millions')
legend()
show()