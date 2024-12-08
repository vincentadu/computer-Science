import tester.Tester;
interface ILOI{
	//check if list has  even number
	boolean iseven ();
	//check if list has positive and add
	boolean positiveOdd ();
	//check if list has a number between 5 and 10 inclusively
	boolean inclusive5And10 ();
	//find if the list satisfy the following requirement
	//A number that is even
	//A number that is positive and odd
	//A number between 5 and 10, inclusive
	boolean variant1 ();
	//find if the list satisfy the following requirement
	//A number that is even
	//A number that is positive and odd
	//A number between 5 and 10, inclusive
	// can use duplicate number to satisfy multiple requirement
	// only single requirement can satisfy an element
	boolean variant2 ();
	int count();
	ILOI variant2Even();
	ILOI variant2PosAdd();
	ILOI variant2Incl5To10();
	ILOI variant2Helper();
	boolean variant3 ();
}

class MTLoInt implements ILOI {
	MTLoInt (){}
	public boolean iseven () {
		return false;
	}
	
	public boolean positiveOdd () {
		return false;
	}
	
	public boolean inclusive5And10 () {
		return false;
	}
	
	public 	boolean variant1 () {
		return false;
	}
	
	public boolean variant2 () {
	return false;
	}
	
	public ILOI variant2Even() {
		return this;
	}
	
	public ILOI variant2PosAdd() {
		return this;
	}
	
	public ILOI variant2Incl5To10() {
		return this;
	}
	public ILOI variant2Helper() {
		return this;
	}
	
	public int count() {
		return 0;
	}
	
	public boolean variant3 () {
		return false;
	}
}


class LoInt implements ILOI {
	int first;
	ILOI rest;
	LoInt (int first, ILOI rest){
		this.first = first;
		this.rest = rest;
	}
	
	public boolean iseven () {
		if (this.first % 2 == 0) {
			return true;
		}else {
			return  rest.iseven();
		}
	}
	
	public boolean positiveOdd () {
		if (this.first % 2 !=0 && this.first > 0) {
			return true;
		}else {
			return rest.positiveOdd(); 
		}
	}
	
	public boolean inclusive5And10 () {
		if (this.first >= 5 && this.first <=10) {
			return true;
		}else {
			return false || rest.inclusive5And10();
		}
	}
	
	public 	boolean variant1 () {
		return this.iseven() && 
				this.positiveOdd()&& 
				this.inclusive5And10();
	}
	
	public boolean variant2 () {
		if (this.count()>= 3) {
			if (this.variant2Helper() instanceof MTLoInt ) {
				return true;
			} else {return false;}
		}else {
			return false;
		}

}

	public ILOI variant2Even() {
		if (this.first % 2 == 0) {
			return this.rest;
		}else {
			return new LoInt (this.first,rest.variant2Even());
		}
	}
	
	public ILOI variant2PosAdd() {
		if (this.first % 2 !=0 && this.first > 0) {
			return this.rest;
		}else {
			return new LoInt (this.first,rest.variant2PosAdd());
		}
	}
	
	public ILOI variant2Incl5To10() {
		if (this.first >= 5 && this.first <=10){
			return this.rest;
		}else {
			return new LoInt (this.first,rest.variant2Incl5To10());
		}
	}
	
	public ILOI variant2Helper() {
		return this.variant2Even().variant2PosAdd().variant2Incl5To10();
		}
	
	public int count() {
		return 1+ this.rest.count();
	}
	
	public boolean variant3 () {
		if (this.count() == 3) {
			if (this.variant2Helper() instanceof MTLoInt ) {
				return true;
			} else {return false;}
		}else {
			return false;
		}
	}
}

class ExamplesILOI{
	MTLoInt mti = new MTLoInt ();
	LoInt loi1 = new LoInt (5,mti);
	LoInt loi2 = (new LoInt (6, new LoInt (5,mti)));
	LoInt loi3 = (new LoInt (4, new LoInt (3,mti)));
	LoInt loi4 = (new LoInt (3, new LoInt (5,mti)));
	LoInt loi5 = new LoInt (4,mti);
	LoInt loi6 = new LoInt (10,mti);
	LoInt loi7 = (new LoInt (10, new LoInt (4,mti)));
	LoInt loi8 = (new LoInt (6,new LoInt (5, new LoInt (6,mti))));
	LoInt loi9 = (new LoInt (6,new LoInt (5,new LoInt (42, new LoInt (6,mti)))));
	boolean testILOIiseven(Tester t) {
		return t.checkExpect(loi1.iseven(), false) &&
				t.checkExpect(loi2.iseven(), true) &&
				t.checkExpect(loi4.iseven(), false);
	}
	
	boolean testILOIpositiveOdd(Tester t) {
		return t.checkExpect(loi1.positiveOdd(), true) &&
				t.checkExpect(loi5.positiveOdd(), false) &&
				t.checkExpect(loi2.positiveOdd(), true);
	}
	
	boolean testILOIinclusive5And10(Tester t) {
		return t.checkExpect(loi1.inclusive5And10(), true) &&
				t.checkExpect(loi6.inclusive5And10(), true) &&
				t.checkExpect(loi5.inclusive5And10(), false);
	
	}
	
	boolean testILOIvariant1(Tester t) {
		return t.checkExpect(loi2.variant1(), true) &&
				t.checkExpect(loi3.variant1(), false);
	}
	
	boolean testILOIvariant2Even(Tester t) {
		return t.checkExpect(loi2.variant2Even(), loi1) &&
				t.checkExpect(loi4.variant2Even(), loi4);
	}
	
	boolean testILOIvariant2PosAdd(Tester t) {
		return t.checkExpect(loi1.variant2PosAdd(), mti) &&
				t.checkExpect(loi4.variant2PosAdd(), new LoInt (5,mti)) &&
				t.checkExpect(loi2.variant2PosAdd(), new LoInt (6,mti));
	}

	boolean testILOIvariant2Incl5To10(Tester t) {
		return t.checkExpect(loi1.variant2Incl5To10(), mti)&&
				 t.checkExpect(loi4.variant2Incl5To10(), new LoInt (3,mti));
	}
	
	boolean testILOIvariantvariant2Helper(Tester t) {
		return t.checkExpect(loi7.variant2Helper(), new LoInt (4,mti)) &&
				t.checkExpect(loi8.variant2Helper(), mti);
	}
	
	boolean testILOICount(Tester t) {
		return t.checkExpect(mti.count(), 0) &&
				t.checkExpect(loi1.count(), 1) && 
				t.checkExpect(loi2.count(), 2);
	}
	
	
	boolean testILOIvariant2(Tester t) {
		return t.checkExpect(loi7.variant2(), false) &&
				t.checkExpect(loi8.variant2(), true) &&
				t.checkExpect(loi1.variant2(), false);
	}
	
	boolean testILOIvariant3(Tester t) {
		return t.checkExpect(loi8.variant2(), true) &&
				t.checkExpect(loi9.variant2(), false);
	}
	
}