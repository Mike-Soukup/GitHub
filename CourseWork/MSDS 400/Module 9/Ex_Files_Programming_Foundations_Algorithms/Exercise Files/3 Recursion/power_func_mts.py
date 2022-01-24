def power(num, pwr):
    '''Calculate num^pwr using recursion, pwr >= 0, pwr must be an integer'''
    if pwr == 0:
        return 1
    while pwr > 0:
        return num * power(num, pwr-1)

def factorial(num):
    '''Calculate the factorial of a number using recursion'''
    if num == 0:
        return 1
    else:
        return num * factorial(num-1)