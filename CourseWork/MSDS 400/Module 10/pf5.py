from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize
#Solution Via Linear Programming with Pulp
# declare your variables
y1 = LpVariable("y1", 0, None) # y1>=0
y2 = LpVariable("y2", 0, None) # y2>=0

# defines the problem
prob = LpProblem("problem", LpMinimize)

# defines the constraints
prob += 20*y1 + 18*y2 >= 400
prob += 50*y1 + 30*y2 >= 750
prob += 110*y1 + 44*y2 >= 1500

# defines the objective function to maximize
prob += 10000*y1 + 8500*y2

# solve the problem
status = prob.solve()
LpStatus[status]

#Calculate value of objective function

OF = 10000*value(y1) + 8500*value(y2)

# print the results
print("Pulp solutions for y1 , y2: ")
print(value(y1))
print(value(y2))
print('Objective function has a value of {}'.format(OF))

#Solution via graphing
import numpy 
from numpy import *
import matplotlib.pyplot
from matplotlib.pyplot import *
xmin = 0
xmax = 15
x = linspace(xmin,xmax,100)
y1 = []
y2 = []
y3 = []
for i in x:
    y1 = y1 + [((-20/18)*i)+(400/18)]
    y2 = y2 + [((-50/30)*i)+25]
    y3 = y3 + [((-110/44)*i)+(1500/44)]
z = 200000
y_of = []
for i in x:
    y_of = y_of + [((-10000/8500)*i)+(z/8500)]
plot(x,y1,'r-',label='y1')
plot(x,y2,'b-',label='y2')
plot(x,y3,'g-',label='y3')
plot(x,y_of,'k--',label='OF = {}'.format(z))
legend()
xlabel('Number of P1 Planes')
ylabel('Number of P2 Planes')
vlines(0,0,max(y3))
hlines(0,0,max(x))
show()
