def genPrimes():
    p=[]
    x = 0
    def isprime(x):        
        if x <=1:
            return False
        else:
            for i in range(2, int(x**0.5) + 1):
                if x % i == 0:
                    return False
        return True


    while True:
        if isprime(x):
            p.append(x)
            yield(x)
            
        x+=1


prime = genPrimes()
for i in range (17):
    print(prime.__next__())


    