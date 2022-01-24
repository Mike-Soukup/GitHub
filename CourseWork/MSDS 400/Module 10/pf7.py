from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize
#Solution Via Linear Programming with Pulp
# declare your variables
y1 = LpVariable("y1", 0, None) # y1>=0
y2 = LpVariable("y2", 0, None) # y2>=0
y3 = LpVariable("y3", 0, None) # y3>=0

# defines the problem
prob = LpProblem("problem", LpMinimize)

# defines the constraints
prob += y1 + y2 + y3 >= 3000
prob += 0.75*y1 - 0.25*y2 - 0.25*y3 >= 0
prob += y2 - (2/3)*y3 >= 0

# defines the objective function to maximize
prob += 11*y1 + 14*y2 + 6*y3

# solve the problem
status = prob.solve()
LpStatus[status]

#Calculate value of objective function

OF = 11*value(y1) + 14*value(y2) + 6*value(y3)

# print the results
print("Pulp solutions for y1 , y2, y3: ")
print(value(y1))
print(value(y2))
print(value(y3))
print('Objective function has a value of {}'.format(OF))