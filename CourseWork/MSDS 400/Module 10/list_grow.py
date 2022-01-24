import time

def test1():
    start = time.time()
    l = []
    for i in range(1000):
        l = l + [i]
    end = time.time()
    print('Test1 time = {}'.format(end-start))

def test2():
    start = time.time()
    l = []
    for i in range(1000):
        l.append(i)
    end = time.time()
    print('Test2 time = {}'.format(end-start))

def test3():
    start = time.time()
    l = [i for i in range(1000)]
    end = time.time()
    print('Test3 time = {}'.format(end-start))

def test4():
    start = time.time()
    l = list(range(1000))
    end = time.time()
    print('Test4 time = {}'.format(end-start))

#Set up Benchmarking of our 4 test functions:

#Import the timeit module
import timeit
#Import the timer class defined in the module:
from timeit import Timer
#Call the functions and get a speed indicator:
t1 = Timer("test1()","from __main__ import test1")
print("concat ", t1.timeit(number=1000),"milliseconds")
t2 = Timer("test2()","from __main__ import test2")
print("append ",t2.timeit(number=1000),"milliseconds")
t3 = Timer("test3()","from __main__ import test3")
print("comprehension ",t3.timeit(number=1000),"milliseconds")
t4 = Timer("test4()","from __main__ import test4")
print("list range ",t4.timeit(number=1000),"milliseconds")