import numpy
from numpy import *
import matplotlib.pyplot
from matplotlib.pyplot import *
import math

#Need to define the function f(x)
def f(x):
    out = x**2
    return out

def gen(lim):
    '''Feed in the numerical/non-infinity limit. Then this function will show convergence.'''
    x_r_start = lim + 3
    x_l_start = lim - 3
    
    y_r = []
    y_l = []
    
    if lim > 0:
        x_r = arange(x_r_start,1.001*lim,-0.001)
        x_l = arange(x_l_start,0.999*lim,0.001)
        
        for i in range(len(x_r)):
            xx_r = x_r[i]
            y_r = y_r + [f(xx_r)]
        for i in range(len(x_l)):
            xx_l = x_l[i]
            y_l = y_l + [f(xx_l)]
    
    
        figure()
        xmax = max(x_r) + 0.5
        xmin = min(x_l) - 0.5
        ymax = max(y_r) + 0.5
        ymin = min(y_l) - 0.5
        #xlim(xmin,xmax)
        #ylim(ymin,ymax)
    
        plot(x_r,y_r,color = 'b')
        plot(x_l,y_l,color = 'r')
        #scatter(lim,f(lim),c = 'k',s = 40)
    
        title('Limit as f(x) approaches {}'.format(lim))
        xlabel('x-axis')
        ylabel('y-axis')
        show()
    
        print('{:^30}{:^30}'.format('From the Left','From the Right'))

        for i in arange(-10,0):
            r = x_r[i]
            l = x_l[i]
            f_r = f(r)
            f_l = f(l)
            print('x = {:<6} f(x) = {:^13} x = {:<6} f(x) = {:^13}'.format(round(l,4),round(f_l,5),round(r,4),round(f_r,5)))
        

    elif lim == 0:
        x_r = arange(x_r_start,1.001*lim,-0.001)
        x_l = arange(x_l_start,0.999*lim,0.001)
        
        for i in range(len(x_r)):
            xx_r = x_r[i]
            y_r = y_r + [f(xx_r)]
        for i in range(len(x_l)):
            xx_l = x_l[i]
            y_l = y_l + [f(xx_l)]


        figure()
        xmax = max(x_r) + 0.5
        xmin = min(x_l) - 0.5
        ymax = max(y_r) + 0.5
        ymin = min(y_l) - 0.5
        xlim(xmin,xmax)
        ylim(ymin,ymax)

        plot(x_r,y_r,color = 'b')
        plot(x_l,y_l,color = 'r')
        #scatter(lim,f(lim),c = 'k',s = 40)

        title('Limit as f(x) approaches {}'.format(lim))
        xlabel('x-axis')
        ylabel('y-axis')
        show()

        print('{:^30}{:^30}'.format('From the Left','From the Right'))

        for i in arange(-10,0):
            r = x_r[i]
            l = x_l[i]
            f_r = f(r)
            f_l = f(l)
            print('x = {:<6} f(x) = {:^13} x = {:<6} f(x) = {:^13}'.format(round(l,4),round(f_l,5),round(r,4),round(f_r,5)))
        

    else:
        x_r = arange(x_r_start,0.999*lim,-0.001)
        x_l = arange(x_l_start,1.001*lim,0.001)
        
        for i in range(len(x_r)):
            xx_r = x_r[i]
            y_r = y_r + [f(xx_r)]
        for i in range(len(x_l)):
            xx_l = x_l[i]
            y_l = y_l + [f(xx_l)]

        figure()
        xmax = max(x_r) + 0.5
        xmin = min(x_l) - 0.5
        ymax = max(y_r) + 0.5
        ymin = min(y_l) - 0.5
        xlim(xmin,xmax)
        ylim(ymin,ymax)

        plot(x_r,y_r,color = 'b')
        plot(x_l,y_l,color = 'r')
        #scatter(lim,f(lim),c = 'k',s = 40)

        title('Limit as f(x) approaches {}'.format(lim))
        xlabel('x-axis')
        ylabel('y-axis')
        show()

        print('{:^30}{:^30}'.format('From the Left','From the Right'))

        for i in arange(-10,0):
            r = x_r[i]
            l = x_l[i]
            f_r = f(r)
            f_l = f(l)
            print('x = {:<6} f(x) = {:^13} x = {:<6} f(x) = {:^13}'.format(round(l,4),round(f_l,5),round(r,4),round(f_r,5)))

gen(25)