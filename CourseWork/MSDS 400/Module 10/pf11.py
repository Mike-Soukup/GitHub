import numpy
from numpy import arange, cos
import matplotlib.pyplot
from matplotlib.pyplot import *
import math

#Create a function to calculate the derivative at a specific point listed
def f(x):
    '''Input a function and output the values of the function at x'''
    f = 30.09 - 5.93*math.log(x) #Enter function here
    return f

def derivative(x,function):
    '''Approximate the slope/derivative of a function at x'''
    h = 0.000000001
    m = (function(x+h)-function(x))/h
    return m
def calc_b(y,x,m):
    '''Calculat b given a point y + x and a slope m'''
    return y - m*x
tmin = 0.001
tmax = 55
t = numpy.linspace(tmin,tmax,500)
P_t = []
for i in t:
    P_t = P_t + [f(i)]
plot(t,P_t,'b-',label = 'P(t)')
xlabel('Years since 1965')
ylabel('Percent of persons 65+ with family income below poverty')
legend()
show()

t = 45
P_t = f(t)
print(P_t)
roc_P_t = derivative(t,f)
print(roc_P_t)
