import numpy
x = numpy.arange(0,29,1)
k = [305,817,173,445]

for j in k:
    for i in x:
        if (i - j)%29 == 0:
            print("The Employee SSN {} has Employee number {}".format(j,i))