import matplotlib.pyplot as plt
import numpy as np
import math
 
def f(x):
    return ((1/75)*math.exp(-x/75))

def integrate_trap(a, b, n):
    total = 0.0
    delta = (b-a)/n
    i = 0
    while i < n:
        total = total + delta * ((f(a + delta * (i + 1)) + f(a + delta * i)) / 2.0) 
        i = i + 1
    return total

def integrate_midpoint(a,b,n):
    total = 0.0
    delta = (b-a)/n
    i = 0
    while i < n:
        total = total + (delta * f(a + delta*(0.5 + i)))
        i = i + 1
    return total