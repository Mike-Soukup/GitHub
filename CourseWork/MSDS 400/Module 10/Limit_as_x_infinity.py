import numpy
from numpy import *
import matplotlib.pyplot
from matplotlib.pyplot import *
import math

#Need to define f(x)
def f(x):
    out = 40*math.exp(-0.4*x)
    return out

def gen_inf():
    '''Feed in the infinity limit. Then this function will show approximate the limit.'''
    test = input('Positive or Negative Infinity (enter + or -) : ')
    
    if test == '+':
        y_l = []
        x_1 = list(range(1,11,1))
        x_2 = list(range(10,110,10))
        x_3 = list(range(100,1100,100))
        x_4 = list(range(1000,11000,1000))
        x_5 = list(range(10000,110000,10000))
        x_l = x_1 + x_2 + x_3 + x_4 + x_5
        
        for i in x_l:
            y_l = y_l + [f(i)]
        
        figure()
        xmin = min(x_l)-0.5
        xmax = max(x_l)+0.5
        xlim = (xmin,xmax)
        plot(x_l,y_l)
        
        title('Limit of f(x) as x goes to infinity')
        xlabel('x-axis')
        ylabel('y-axis')
        print('{}'.format('x and f(x) values as x -> infinity'))
        show()
        
        for i in range(0,11):
            print('x = {:<5} f(x) = {:<20}'.format(x_l[i],round(f(x_l[i]),3)))
        for i in range(-10,0):
            print('x = {:<5} f(x) = {:<20}'.format(x_l[i],round(f(x_l[i]),3)))
    else:
        y_r = []
        x_1 = list(range(0,-11,-1))
        x_2 = list(range(-10,-110,-10))
        x_3 = list(range(-100,-1100,-100))
        x_4 = list(range(-1000,-11000,-1000))
        x_5 = list(range(-10000,-110000,-10000))
        x_r = x_1 + x_2 + x_3 + x_4 + x_5
        
        for i in x_r:
            y_r = y_r + [f(i)]
        figure()
        plot(x_r,y_r)
        title('Limit of f(x) as x goes to negative infinity')
        xlabel('x-axis')
        ylabel('y-axis')
        print('{}'.format('x and f(x) values as x -> negative inifity:'))
        show()
        
        for i in range(0,11):
            print('x = {:<5} f(x) = {:<20}'.format(x_r[i],round(f(x_r[i]),3)))
        for i in range(-10,0):
            print('x = {:<5} f(x) = {:<20}'.format(x_r[i],round(f(x_r[i]),3)))

gen_inf()