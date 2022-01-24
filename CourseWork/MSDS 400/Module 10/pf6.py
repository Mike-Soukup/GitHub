from pulp import LpVariable, LpProblem, LpMaximize, LpStatus, value, LpMinimize
#Solution Via Linear Programming with Pulp
# declare your variables
x1 = LpVariable("x1", 0, None) # x1>=0
x2 = LpVariable("x2", 0, None) # x2>=0
x3 = LpVariable("x3", 0, None) # x3>=0

# defines the problem
prob = LpProblem("problem", LpMaximize)

# defines the constraints
prob += x1 + x2 + x3 <= 36
prob += x3 <= 4
prob += -x1 + x2 -x3 <= 0

# defines the objective function to maximize
prob += 200*x1 + 600*x2 + 260*x3

# solve the problem
status = prob.solve()
LpStatus[status]

#Calculate value of objective function

OF = 200*value(x1) + 600*value(x2) + 260*value(x3)

# print the results
print("Pulp solutions for x1 , x2, x3: ")
print(value(x1))
print(value(x2))
print(value(x3))
print('Objective function has a value of {}'.format(OF))