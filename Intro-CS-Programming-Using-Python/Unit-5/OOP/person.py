import datetime
class Person (object):
    def __init__ (self, name):
        self.name = name
        self.birthday = None
        self.lastname = name.split (" ")[-1]

    def getName (self):
        return self.name

    def getLastname (self):
        return self.lastname

    def getBirthday (self):
        return self.birthday
    
    def getAge (self):
        if self.birthday == 0:
            raise ValueError ("Birthday not set")
        else:
            return (datetime.date.today()-self.birthday).days

    
    def setBirthday (self, month, day, year):
        self.birthday = datetime.date ( year, month, day)
    def __lt__ (self, other):
        """compare if less than the last names in case same last name compare using the complete name"""
        if self.lastname == other.lastname:
            return self.name <other.name
        else:
            return self.lastname <other.lastname
        
    def __str__ (self):
        return self.name

class MITPerson (Person):
    nextIdNUm = 0
    def __init__ (self, name):
        Person.__init__ (self,name)
        self.IdNum = MITPerson.nextIdNUm
        MITPerson.nextIdNUm +=1

    def getIdnum (self):
        return self.IdNum
    

    def __lt__ (self, other):
        return self.getIdnum() < other.getIdnum() 
    
    def speak (self, utterance):
        return ( self.getLastname() + " says" + utterance)
    

class Student (MITPerson):
    pass

class UG ( Student):
    def __init__ (self, name, classyear = None):
        MITPerson.__init__ (self, name)
        self.classyear = classyear

    
    def getClassYear(self):
        return self.classyear
    
    def speak (self, utterance):
     return   MITPerson.speak (self," Yo Bro "+ utterance)
    
class Grad (Student):
    pass

class TransferStudent (Student):
    pass

def isclass (obj):
    return isinstance(obj,Student)


def hello ():
    print ("hello")
    


# p1 = Person ("Vincent Angelo Ortiz")
# p2 = Person ( "Nicole Emery Ortiz")
# listofname = [p1,p2]
# p1.setBirthday (5,6,1986)
# print (p1.getBirthday())
# listofname.sort()
# for i in listofname:
#     print (i)
# m1 = MITPerson ("Harlequin Ortiz")
# m2 = MITPerson  ("Joanahil Ortiz")

# listofMITname = [m1,  m2, p2]

# print(p1<m1)
# listofMITname.sort()

# for i in listofMITname:
#     print (i)


# m2.setBirthday(12,5,1984)
# print (m2.getAge())


# print(p1.getAge())


# ug1 = UG("Karen Ortiz", 2001)

# print(ug1.speak("hello there"))


# print(isclass (ug1))