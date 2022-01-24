import numpy
from numpy import *

m = 4
k = 4
n = 5

def make_matrix_zeros(r,c):
    """Make matrix of zeros"""
    A = [0]*r
    for i in range(0,r,1):
        zeros = [0]*c
        A[i] = zeros
    A = matrix(A)
    return A
def make_matrix_rand(r,c):
    """Make matrix of size r = rows and c = columns with random numbers"""
    A = random.randint(5,size = (r,c))
    A = matrix(A)
    return A

A = make_matrix_rand(m,k)
B = make_matrix_rand(k,n)
C = make_matrix_rand(m,n)

count_addition = 0
count_multiplication = 0

for i in range(0,m,1):
    for j in range(0,n,1):
        c_ij = 0
        for q in range(0,k,1):
            c_ij = c_ij + (A[i,q]*B[q,j])
            count_addition += 1
            count_multiplication += 1
            C[i,j] = c_ij
print("Number of multiplications = {}".format(count_multiplication))
print("Number of additions = {}".format(count_addition))
print("A {} \n * \n B {} \n = \n C {}".format(A,B,C))