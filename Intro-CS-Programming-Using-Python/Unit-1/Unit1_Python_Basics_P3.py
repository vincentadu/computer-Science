"""
s = 'abcbcd'
bob = "bob"

for i in range (len (s)):
    a =""
    w = 0
    for j in range (i,len (s)):
            a+=s[j]
            #print (a)
            w+=1
            if w > 2:
                break
    if a == bob:
        count+=1



print (count)
        

"""



s = 'zyxwvutsrqponmlkjihgfedcba'
a = s[0]
final = s[0]
for i in range (1,len(s)):
    if a[-1]<= s[i]:
        a +=s[i]
    else:
        a = s[i]
    


    
    
    if len(final)< len(a):
        final = a

print (final)
    


    


        




