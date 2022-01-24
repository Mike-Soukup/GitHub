import numpy as np
import matplotlib.pyplot as plt


z = np.linspace(0,40,41)
x1 = 2*z-9
x2 = -z+40
fig,ax = plt.subplots()
plt.scatter(z,x1)
plt.plot([0,40],[0,0])
plt.plot([0,40],[40,40])
plt.plot(z,x2)
plt.ylabel('X')
plt.xlabel('Z')
print(x1,z)
plt.show()
y = 40-x1-z

x_a = [1,3,5,7,9,11,13,15,17,19,21,23]
z_a = [5,6,7,8,9,10,11,12,13,14,15,16]
y_a = [34,31,28,25,22,19,16,13,10,7,4,1]

r1 = []
r2 = []

for i in range(0,len(x_a)):
    x = x_a[i]
    y = y_a[i]
    z = z_a[i]
    r_1 = x+y+z
    r_2 = (3.9*x)+(3.6*y)+(3.0*z)
    r1.append(r_1)
    r2.append(r_2)
