import numpy
from numpy import *
from numpy.linalg import *

r = [96, 87, 74]
r = matrix(r)
r = transpose(r)
A = [[1, 3, 4], [2, 1, 3], [4, 2, 1]]
A = matrix(A)
IA = inv(A)
I = dot(IA,A)
I = int_(I) # This converts floating point to integer
result = linalg.solve(A,r)
B = [[2,2],[5,3],[6,1]]
B = matrix(B)
AB = A*B