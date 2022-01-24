import time

def anagram_solution1(s1,s2):
    """Assume same s1 and s2 are the same length \n
        T(n) = (1/2)n^2 + (1/2)n \n
        O(n^2)"""
    start = time.time()
    a_list = list(s2)
    pos1 = 0
    still_ok = True

    while pos1 < len(s1) and still_ok:
        pos2 = 0
        found = False
        while pos2 < len(a_list) and not found:
            if s1[pos1] == a_list[pos2]:
                found = True
            else:
                pos2 = pos2 + 1
        if found:
            a_list[pos2] = None
        else:
            sill_ok = False
        pos1 = pos1 + 1
        end = time.time()
    return still_ok, end-start
print(anagram_solution1('abcde','edcba'))
def anagram_solution2(s1,s2):
    start = time.time()
    a_list1 = list(s1)
    a_list2 = list(s2)

    a_list1.sort()
    a_list2.sort()

    pos = 0
    matches = True

    while pos < len(s1) and matches:
        if a_list1[pos] == a_list2[pos]:
            pos = pos + 1
        else:
            matches = False
    end = time.time()
    return matches, end-start
print(anagram_solution2('abcde','edcba'))
def anagram_solution4(s1,s2):
    start = time.time()
    c1 = [0]*26
    c2 = [0]*26

    for i in range(len(s1)):
        pos = ord(s1[i]) - ord('a')
        c1[pos] = c1[pos] + 1
    
    for i in range(len(s2)):
        pos = ord(s2[i]) - ord('a')
        c2[pos] = c2[pos] + 1

    j = 0
    still_ok = True
    while j < 26 and still_ok:
        if c1[j] == c2[j]:
            j = j+1
        else:
            still_ok = False
    end = time.time()
    return still_ok, end-start
print(anagram_solution4('abcde','edcba'))