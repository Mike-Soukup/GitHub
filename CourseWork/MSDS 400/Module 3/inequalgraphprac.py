import numpy
import matplotlib.pyplot as plt

x = numpy.linspace(-10,10,100)
y1 = ((-1/4)*x)+3
y2 = (1/2)*x
y3 = ((1/2)*x)+3
z_20 = ((-1/10)*x)+(20/10)
z_50 = ((-1/10)*x)+(50/10)
z_75 = ((-1/10)*x)+(75/10)
plt.plot(x,y1,'b-',x,y2,'r-',x,y3,'g-',x,z_20,'y--',x,z_50,'y--',x,z_75,'y--')
plt.plot([-10,10],[0,0],'k-',linewidth = 1)
plt.plot([0,0],[-10,10],'k-',linewidth = 1)
plt.plot([6,6],[-10,10],'k--')
plt.grid()
plt.legend(['y = -1/4x + 3','y = 1/2x','y = 1/2x + 3'],loc = 'best')
plt.show()