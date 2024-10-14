s = 'azcbobobegghakl'
count = 0
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
        



      







