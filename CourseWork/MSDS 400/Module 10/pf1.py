import matplotlib.pyplot
from matplotlib.pyplot import *
import numpy
x = numpy.linspace(0,5000,1000)
C = x + 7386
R = 4*x
P = R-C

figure()
plot(x,C,'r-',label = 'Cost')
plot(x,R,'g-', label = 'Revenue')
plot(x,P,'k--',label = 'Profit')
vlines(0,min(P)-5,max(R)+5,colors = 'k')
hlines(0,0,5000)
legend()
xlabel('Number of Handles per Week')
ylabel('$')
show()