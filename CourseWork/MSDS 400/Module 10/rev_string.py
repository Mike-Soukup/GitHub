from Stack import Stack
def rev_string(my_str):
    original_str = list(my_str)
    s = Stack()
    for i in original_str:
        s.push(i)
    j = s.size()
    rev_str_lst = []
    while j > 0:
        rev_str_lst.append(s.pop())
        j = j - 1
    rev_str = ''
    for i in rev_str_lst:
        rev_str = rev_str + i
    return rev_str

rev_string('Mikey')