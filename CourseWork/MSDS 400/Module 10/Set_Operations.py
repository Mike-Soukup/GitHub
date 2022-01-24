U = {1,2,3,4,5,6,7,8,9,10,11}
A = {1,2,4,5,7}
B = {2,4,5,7,9,11}
Uab = A | B       #Union of A and B
AB = A & B        #Intersection of A & B
Ac = U - A        #Complement of A
Bc = U - B        #Complement of B
AsB = A ^ B       #Finding symmetric difference between A and B
SD = (A|B) - (A&B) #Another way to find the symmetric difference
R = Ac | Bc | AB  #Union of several sets
Add = {12,13,14}
U = U | Add       
U = range(1,27)
U = set(U)

