import numpy
num_spaces = 29

x = numpy.arange(0,num_spaces,1)
test = [305,817,173,445]
for j in test:
    for i in x:
        if (i-j)%num_spaces == 0:
            print('First three digits of SSN = {}: Employee Number = {}'.format(j,i))
