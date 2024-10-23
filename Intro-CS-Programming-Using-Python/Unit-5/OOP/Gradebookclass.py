from person import *
class Grades (object):
    """A mapping from students to a list of grades
    """
    def __init__ (self):
         """create empty Grade book"""
         self.student = []
         self.grades = {}
         self.isSorted = True

    def addStudent (self, student):
        if student not in self.student:
              self.student.append (student)
              self.grades [student.getIdnum()] = []
              self.isSorted = False
        else:
             raise ValueError ("Duplicate Student Name")
        
    def addGrades (self, student, grades):
        try:
              self.grades[student.getIdnum()].append(grades)
        except TypeError:
            raise ValueError ("Student not found")
        

    def getGrade (self,student):
        try:
              return self.grades[student.getIdnum()]
         
        except TypeError:
             raise ValueError ("Student Not Found")
        
    # def allStudent (self):
    #     """return all the student in the gradebook"""
    #     if not self.isSorted:
    #         self.student.sort()
    #         self.isSorted = True
    #     return self.student[:]
        
    def allStudent (self):
        """return all the student in the gradebook"""
        if not self.isSorted:
            self.student.sort()
            self.isSorted = True
        for s in self.student:
             yield s
        

def gradeReport (course):
    """Assume course is a type of grade"""
    report= []
    for i in course.allStudent():
        tot = 0
        numall = 0
        for j in course.getGrade(i):
              tot +=j
              numall+=1
        try:
            average = tot /numall
            report.append (str(i)+ "\"s mean grade is "+ str(average))
        except ZeroDivisionError:
            report.append (str(i)+ "No Grades")

    return "\n".join(report)



# #test

# ug1  = UG("Vincent Ortiz", 2001)
# t1 = TransferStudent("Karen Ortiz")

# cs50 = Grades()

# cs50.addStudent(ug1)
# cs50.addStudent(t1)
# cs50.addGrades(ug1,100)
# cs50.addGrades(t1,85)
# # print(cs50.getGrade (t1))
# # print (cs50.grades)
# # for i in cs50.allStudent():
# #      print (i)


# print(gradeReport (cs50))



    