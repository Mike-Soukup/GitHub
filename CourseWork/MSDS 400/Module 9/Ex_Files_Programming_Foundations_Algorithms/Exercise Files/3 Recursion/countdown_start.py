# use recursion to implement a countdown counter


def countdown(x):
    if (x == 0):
        print("done!")
        return
    else:
        print(x,'...')
        countdown(x-1)
        print(x) #Shows how a call stack is unwound!

countdown(5)
