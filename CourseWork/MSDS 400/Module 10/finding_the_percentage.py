if __name__ == '__main__':
    n = int(input("How many students? "))
    student_marks = {}
    for i in range(n):
        name, *line = input("Enter Students Name and Test Scores ").split()
        scores = list(map(float, line))
        student_marks[name] = scores
    query_name = input("Name a student to look up: ")
    student_scores = list(student_marks[query_name])
    avg_score = sum(student_scores)/len(student_scores)
    print('{:.2f}'.format(avg_score))