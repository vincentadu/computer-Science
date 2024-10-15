



c =  {'B': [15], 'u': [10, 15, 5, 2, 6]}

def how_many(aDict):
    '''
    aDict: A dictionary, where all the values are lists.

    returns: int, how many values are in the dictionary.
    '''
    new = []
    for i in aDict:
        new.append(c[i])

    count = 0
    for n in new:
        count +=len(n)



    return count 



print(how_many (c))

animals = { 'a': ['aardvark'], 'b': ['baboon'], 'c': ['coati']}

animals['d'] = ['donkey']
animals['d'].append('dog')
animals['d'].append('dingo')


print (animals)



def biggest(aDict):
    '''
    aDict: A dictionary, where all the values are lists.

    returns: The key with the largest number of values associated with it
    '''
    new = {}
    for i in aDict:
        new[i]=len(aDict[i])
    
    value = new.values()
    maximum = max(value)

    for j in new:
        if new[j]==maximum:
            break

    if new[j]==maximum:
        return j







biggest(c)

