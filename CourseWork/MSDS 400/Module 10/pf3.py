import numpy
from numpy import *
from numpy.linalg import *

rhs = [28400,27600,956.4]
rhs = matrix(rhs)
rhs = transpose(rhs)
A = [[140,140,160],[190,60,60],[4.97,4.45,4.65]]
A = matrix(A)
result = linalg.solve(A,rhs)
print(result)