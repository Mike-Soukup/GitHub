import numpy
num_spaces = 31

x = numpy.arange(0,num_spaces,1)
test = [362,868,28,662]
for j in test:
    for i in x:
        if (i-j)%num_spaces == 0:
            print('First three digits of license plate = {}: Parking space number = {}'.format(j,i))
