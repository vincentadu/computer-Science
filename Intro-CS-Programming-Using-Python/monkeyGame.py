
import random
import sys

class Card (object):
    def __init__ (self, type, value):
        self.type = type
        self.value  = value
    
    def __str__ (self):
        return str(self.value) + " of " + str(self.type) 

class Deck (Card):
    def __init__ (self):
        cardValue = ["A",2,3,4,5,6,7,8,9,10,"J","Q","K"]
        cardsType = ["Heart","Diamond", "Spade","Flower"]
        self.deck = []
        for ct in cardsType:
            for cv in cardValue:
               self.deck.append(Card(ct, cv))

        

    def shuffle (self):
        return random.shuffle(self.deck)
    
    def getDeck (self):
        return self.deck
    

    def Hide1card (self):
        self.shuffle()
        return self.deck.pop()
    
    def Deal (self):
        return self.deck.pop()

class Hand (object):
    def __init__ (self):
        self.player = []
        self.dealer = []
        self.vincent_card= None
    
    def dist_card (self):
        start_card = Deck()
        start_card.shuffle()
        self.vincent_card = start_card.Hide1card()
        self.player = []
        self.dealer  = []
        iteratestart_card = start_card.getDeck()
        for i in range (len (iteratestart_card)):
            if i % 2 == 0:
                self.dealer.append(start_card.Deal())
            else:
                self.player.append(start_card.Deal())
    

    def getplayercard (self):
        random.shuffle(self.player)
        return self.player
    
    def getdealercard (self):
        random.shuffle(self.dealer)
        return self.dealer
    def getmonkeycard (self):
        return self.vincent_card
    
    def showdupcard (self, name, text):
         duplicate_card =[]
         remaining_card = []
         duplicate = False
         k = 0
         while duplicate == False:
            temp = name.pop(0)
            for i, card in enumerate (name):
                if card.value == temp.value:
                    duplicate_card.append (card)
                    duplicate_card.append (temp)
                    del name[i]
                    break
                else:
                    ...
            if temp not in duplicate_card:
                remaining_card.append(temp)
            
            if len(name)==0:
                duplicate = True
         print ("""____________________________________________________________________________________
                 
                """)
         print (text, "Duplicate Card")
         print (""""
                    """)
         for i in duplicate_card:
             print (i, end = ", ")
         print ("")
         name = remaining_card 
         return name


# Game

def startgame ():
    while True:
        a = input("Ready to Play: (y/n) ")
        try:
            if a  == "y":
                dealcard ()
                break
            elif a == "n":
                sys.exit ("Good Bye")
            else:
                raise ValueError

            
        except ValueError:
            ...

def player_status(p):
    print ("""____________________________________________________________________________________
                 
                """)
    print ("Player On Hand Card")
    for i in p:
        print (i)
def dealer_status(d): 
    print ("""____________________________________________________________________________________
                 
                """)
    print("Dealer has ", len(d), "cards On Hand")


def pickmode (name,player_dealer):
    if player_dealer == "player":
               
        while True:
            try:
                a = int(input("Dealer still has "+str(len(name))+ " card." + "\n" + "Choose from [1-"+str(len(name))+"] : "))
                try:
                    if a > len(name):
                        print( "Out of Range Pick Again")
                        raise Exception
                    else:
                        return a
                except:
                    ...
            except:
                ...
    elif player_dealer == "dealer":
                return random.choice(range((len(name)+1)))
        

def card_pick_on_hand (name, player_dealer):
    card_num = pickmode (name, player_dealer)-1
    card_picked = name.pop(card_num)
    return card_picked


def check_duplicate (name,name2,player_dealer):
    duplicate_card =[]
    remaining_card = []
    temp = card_pick_on_hand (name2, player_dealer)
    for i, card in enumerate (name):
        if card.value == temp.value:
            duplicate_card.append (card)
            duplicate_card.append (temp)
            del name[i]
            break
        else:
            ...
    
    if temp not in duplicate_card:
                name.append(temp)
    
    duplicate = True

    if len(duplicate_card) == 0:
        pass

    else:

        print ("""____________________________________________________________________________________
                    
                    """)
        print (player_dealer, "Duplicate Card")
        print (""""
                """)
        for i in duplicate_card:
            print (i, end = ", ")
        print ("")

    
    return  random.shuffle (name)


def winner (name,name2, monkey):
    winner = False
    while winner== False:
        if len(name)>0 and len (name2)>0:
            check_duplicate (name,name2,"player")
            player_status(name)
            if len(name)>0:
                check_duplicate (name2,name,"dealer")
                player_status(name)
            else:
                winner = True
    
        else:
            winner = True
    
    if len(name) == 0:
        print("player Wins Here is the Monkey Card: "+ str(monkey))
    elif len (name2)== 0:
        print ("dealer Win Here is the Monkey Card: "+ str(monkey) )
    
        
  


def dealcard ():
    start = Hand()
    start.dist_card()
    player = start.getplayercard()
    dealer= start.getdealercard()
    monkey_card = start.getmonkeycard()
    p= start.showdupcard(player,"Player")
    d= start.showdupcard(dealer, "Dealer")
    player_status(p)
    winner (p,d, monkey_card)
    



def monkeygame():
    startgame ()
    print 
    


monkeygame()




                
      
           

             

                     
            
        
       

















