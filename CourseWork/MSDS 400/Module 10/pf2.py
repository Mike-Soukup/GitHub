import matplotlib.pyplot
from matplotlib.pyplot import *
import numpy
import pandas as pd
import seaborn as sns
def least_squares_m(x,y):
    n = len(x)
    xy = []
    for i in range(len(x)):
        xy = xy + [x[i]*y[i]]
    x_sq = []
    for i in range(len(x)):
        x_sq = x_sq + [x[i]**2]
    sum_xy = sum(xy)
    sum_x = sum(x)
    sum_y = sum(y)
    sum_x_sq = sum(x_sq)
    m = ((n*sum_xy)-(sum_x*sum_y))/((n*sum_x_sq)-(sum_x**2))
    return m
def least_squares_b(x,y,m):
    sum_y = sum(y)
    sum_x = sum(x)
    n = len(x)
    b = (sum_y - (m*sum_x))/n
    return b

x = list(range(1,11,1)) #Input list of independent values
y = [0.3,1.0,1.3,2.3,3.1,3.3,3.3,4.6,4.8,5.3] #Input list of dependent values
y_ls = []
m = least_squares_m(x,y)
b = least_squares_b(x,y,m)
for i in range(len(x)):
    y_ls = y_ls + [m*x[i]+b]

X = numpy.asarray(x)
Y = numpy.asarray(y)
d = {'X':x, 'Y':y}
df = pd.DataFrame(d)
sns.pairplot(df)
show()
r = df.corr()
r_legend = r.iloc[[0],[1]]
print(df.corr())
figure()
scatter(x,y)
plot(x,y_ls,'r-',label = r_legend)
xlabel('x')
ylabel('y')
legend()
show()