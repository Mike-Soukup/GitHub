import numpy
from numpy import *
import matplotlib.pyplot
from matplotlib.pyplot import *
import math
import matplotlib.pyplot as plt
from numpy import poly1d, linspace
p = poly1d([3,-4,-12,0,2])
g = p.deriv(m=1)
q = p.deriv(m=2)
print('\nRoots of First Derivative')
print(g.roots)
print('\nRoots of Second Derivative')
print(q.roots)
cg1, cg2, cg3 = g.roots
cq1, cq2 = q.roots

x = linspace(-2,3,1001)
y = p(x)
y_g = g(x)
y_q = q(x)
y_0 = 0*x

print('\n First Derivative Critical Value 1: x = {}, f(x) = {}'.format(cg1,p(cg1)))
print('\n First Derivative Critical Value 2: x = {}, f(x) = {}'.format(cg2,p(cg2)))
print('\n First Derivative Critical Value 3: x = {}, f(x) = {}'.format(cg3,p(cg3)))

print('\n Second Derivative Critical Value 1: x = {}, f(x) = {}'.format(cq1,p(cq1)))
print('\n Second Derivative Critical Value 2: x = {}, f(x) = {}'.format(cq2,p(cq2)))

print('\n',p)
plt.figure()
plt.plot(x, y, color = 'b', label='y=p(x)')
plt.plot(x, y_g, color = 'r', label = "y=p'(x)")
plt.plot(x, y_q, color = 'g', label = "y=p''(x)")
plt.legend(loc = 'best')

plt.plot(x,y_0, color = 'k')
plt.xlabel('x-axis')
plt.ylabel('y-axis')
plt.title('Plot showing function, first, and second derivative')
plt.show()