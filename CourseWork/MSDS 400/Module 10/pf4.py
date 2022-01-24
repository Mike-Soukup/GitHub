import numpy
from numpy import *
from numpy.linalg import *
rhs = [15000,92000,52000]
rhs = matrix(rhs)
rhs = transpose(rhs)

A = [[1,1,1],[10,6,5],[5,6,2.5]]
A = matrix(A)
result = linalg.solve(A,rhs)

print(result)