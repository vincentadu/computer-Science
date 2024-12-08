
interface IDeliMenu{
	
}
class Soup implements IDeliMenu{
	String name;
	int price; // Price in cents
	boolean vegan; // is it for vegetarian???
	
	Soup (String name, int price, boolean vegan ){
		this.name = name;
		this.price = price;
		this.vegan = vegan;
	}
		
}

class Salad implements IDeliMenu{
	String name;
	int price; // Price in cents
	boolean vegan; // is it for vegetarian???
	String dressing;
	Salad (String name, int price, boolean vegan, String dressing){
		this.name = name;
		this.price = price;
		this.vegan = vegan;
		this.dressing = dressing;
			
	}
	
}


class Sandwich implements IDeliMenu{
	String name;
	int price;
	String breadtype;
	String filling1;
	String filling2;
	
	Sandwich(String name, int price, String breadtype, String filling1, String filling2){
		this.name= name;
		this.price = price;
		this.breadtype = breadtype;
		this.filling1 = filling1;
		this.filling2 = filling2;
			
	}
}


class ExamplesIDelimenu{
	ExamplesIDelimenu(){}
	
	IDeliMenu chicken_soup = new Soup ("Chicken Soup", 50, false);
	IDeliMenu pumpkin_soup = new Soup ("Pumpkin Soup", 35, true);
	
	IDeliMenu makaroni_salad = new Salad ("Macaroni Salad", 25, false, "Mayonaise");
	IDeliMenu green_salad = new Salad ("Green Salad", 25, false, "Olive and Vinegar");
	
	IDeliMenu hamegg_sandwich = new Sandwich ("Ham and Egg Sandwich", 25, "White Bread", "Ham", "Egg");
	IDeliMenu Peanut_Strwbrysandwich = new Sandwich ("Peanut and Strawberry Jam Sandwich", 15, "Wheat Bread", "Peanut Butter", "Strawberry Jelly");
	
	
}
