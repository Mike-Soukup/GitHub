k = [362,868,28,662] #First three digits of license plate
m = 31 #Number of spaces available
m_list = list(range(0,31,1))

def h(k):
    for i in m_list:
        if ((i-k)%m) == 0:
            return i

for j in k:
    parking_space = h(j)
    print("Parking space for license plate {} is {}".format(j,parking_space))