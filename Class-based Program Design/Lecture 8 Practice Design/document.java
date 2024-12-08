import tester.Tester;

class Bibliography{
	String firstname;
	String lastname;
	String title;
	
	Bibliography (String firstname, String lastname, String title){
		this.firstname = firstname;
		this.lastname = lastname;
		this.title = title;
	}

}

interface IBibliography{
	IBibliography insert (Bibliography b1);
	IBibliography sort ();
	IBibliography removeDup ();
	boolean duplicate (IBibliography Ib, Bibliography b1);
	boolean duplicateHelper(Bibliography b1);
}
class MTBibliography implements IBibliography{
	MTBibliography(){}

	public IBibliography insert (Bibliography b1) {
		return new LoBibliography (b1,this);
	}
	public IBibliography sort () {
		return this;
	}
	public IBibliography removeDup () {
		return this;
	}

	public boolean duplicate (IBibliography Ib, Bibliography b1) {
		return false;
	}
	public boolean duplicateHelper(Bibliography b1) {
		return false;
	}
	
}

class LoBibliography implements IBibliography {
	Bibliography first;
	IBibliography rest;

	LoBibliography (Bibliography first, IBibliography rest ){
		this.first = first;
		this.rest = rest;
	}

	public IBibliography insert (Bibliography b1) {
		if (this.first.lastname.compareTo(b1.lastname)<0){
			return new LoBibliography (this.first, this.rest.insert (b1));
		}else {
			return new LoBibliography (b1,this);}
	}
	
	public IBibliography sort () {
		return this.rest.sort().insert(this.first);
	}
	
	public IBibliography removeDup () {
		if (this.rest.duplicateHelper(this.first)) {
			return this.rest.removeDup();
		}else {
		return new LoBibliography (this.first, this.rest.removeDup()) ;
		}
	}
	
	public boolean duplicate (IBibliography Ib, Bibliography b1) {
		return Ib.duplicateHelper(b1);
	}
	
	public boolean duplicateHelper(Bibliography b1) {
	   // Compare the first element's fields with the given Bibliography b1
    if (this.first.firstname.equals(b1.firstname) &&
        this.first.lastname.equals(b1.lastname) &&
        this.first.title.equals(b1.title)) {
        return true;  // If all fields match, return true (duplicate found)
    } else {
        // Continue checking the rest of the list recursively
        return rest.duplicateHelper(b1);
    }

}
}

interface Idocument{
	String getfirstname();
	String getlastname();
	String gettitle();

}

class DBook implements Idocument{
	DBAuthor author;
	String title;
	IBibliography lob;
	String publisher;
	
	DBook (DBAuthor author, String title, IBibliography lob, String publisher){
		this.author = author;
		this.title = title;
		this.lob = lob;
		this.publisher = publisher;
	}
	
	public String getfirstname() {
		return this.author.firstname;
	}
	public String getlastname() {
		return this.author.lastname;
	}
	public String gettitle() {
		return this.title;
	}
	
}
	

class Wiki implements Idocument {
	DBAuthor author;
	String title;
	IBibliography lob;
	String URLs;
	
	public String getfirstname() {
		return this.author.firstname;
	}
	public String getlastname() {
		return this.author.lastname;
	}
	public String gettitle() {
		return this.title;
	}
	
	public void  validDocs () {
		System.out.println(this.author.firstname + " " + this.author.lastname);
	}
	
	}


class DBAuthor{
	String firstname;
	String lastname;
	
	DBAuthor(String firstname, String lastname){
		this.firstname = firstname;
		this.lastname = lastname;
	}
}


class ExamplesIdocument{
	DBAuthor jkr = new DBAuthor("Joanne","Rowling");
	DBAuthor ac = new DBAuthor("Agatha","Christie");
	DBAuthor ws = new DBAuthor("William","Shakespeare");
	DBAuthor gs = new DBAuthor("Georges","Simenon");
	DBAuthor tc = new DBAuthor("Tom","Clancy");
	DBAuthor at = new DBAuthor("Akira","Toriyama");
	IBibliography mtbibliography = new MTBibliography ();
	// direct bibliographies
	Idocument db1 = new DBook (jkr,"Harry Potter and the Philosopher's Stone",mtbibliography,"Scholastic Corporation");
	Idocument db2 = new DBook (jkr,"Harry Potter and the Chamber of Secrets",mtbibliography,"Bloomsbury in the UK and Scholastic");
	Idocument db3 = new DBook (gs,"Detectives",mtbibliography,"A. Fayard, Harcourt, Penguin");
	Idocument db4 = new DBook (gs,"Maigret,",mtbibliography,"Artheme Fayard, Penguin Books, Harcourt ");
	Idocument db5 = new DBook (ac,"Whodunits",mtbibliography,"andom House Value Publishing, Deutscher Taschenbuch Verlag GmbH & Co, HarperCollins Publishers");
	Idocument db6 = new DBook (ac,"Miss Marple",mtbibliography,"Harper Collins Books Ltd ");
	Idocument db7 = new DBook (ws,"Romeo and Juliet",mtbibliography,"Simon & Schuster");
	Idocument db8 = new DBook (ws,"Macbeth",mtbibliography,"Simon & Schuster");
	
	Bibliography bdb1 = new Bibliography (db1.getfirstname(),db1.getlastname(),db1.gettitle());
	Bibliography bdb2 = new Bibliography (db2.getfirstname(),db2.getlastname(),db2.gettitle());
	Bibliography bdb3 = new Bibliography (db3.getfirstname(),db3.getlastname(),db3.gettitle());
	Bibliography bdb4 = new Bibliography (db4.getfirstname(),db4.getlastname(),db4.gettitle());
	Bibliography bdb5 = new Bibliography (db5.getfirstname(),db5.getlastname(),db5.gettitle());
	Bibliography bdb6 = new Bibliography (db6.getfirstname(),db6.getlastname(),db6.gettitle());
	Bibliography bdb7 = new Bibliography (db7.getfirstname(),db7.getlastname(),db7.gettitle());
	Bibliography bdb8 = new Bibliography (db8.getfirstname(),db8.getlastname(),db8.gettitle());
	
//transitively through the bibliographies of other documents
	IBibliography lob1 = (new LoBibliography (bdb3, new LoBibliography (bdb1,mtbibliography)));
	IBibliography lob2 = (new LoBibliography (bdb2, lob1));
	IBibliography lob3 = (new LoBibliography (bdb1, lob2));
	IBibliography lob4 = (new LoBibliography (bdb1, mtbibliography));
	IBibliography lob5 = (new LoBibliography (bdb1, new LoBibliography (bdb1,mtbibliography)));
	IBibliography lob6 = (new LoBibliography(bdb2, new LoBibliography (bdb3, new LoBibliography (bdb1,mtbibliography))));
	IBibliography lob7 = (new LoBibliography (bdb1, lob1));
	IBibliography lob8 = (new LoBibliography (bdb3,lob1));
	IBibliography lob9 = (new LoBibliography (bdb3, new LoBibliography(bdb2, new LoBibliography (bdb3, new LoBibliography (bdb1,mtbibliography)))));
	
	
	Idocument db9 = new DBook (tc,"Espionage",lob1.sort().removeDup(),"Penguin Random House");
	Idocument db10 = new DBook (tc,"Dragon Ball",lob2.sort().removeDup(),"Simon & Schuster");
	Idocument db11 = new DBook (tc,"Dragon Ball Super",lob3.sort().removeDup(),"Simon & Schuster");
	
boolean testIBibliographySort(Tester t) {
	return t.checkExpect(mtbibliography.sort(), this.mtbibliography) &&
			t.checkExpect(lob4.sort(), this.lob4) &&
			t.checkExpect(lob1.sort(),(new LoBibliography (bdb1, new LoBibliography (bdb3,mtbibliography)))) &&
			t.checkExpect(lob2.sort(), ((new LoBibliography(bdb2,new LoBibliography (bdb1, new LoBibliography (bdb3,mtbibliography))))));
}
	
boolean testIBibliographyremoveDup(Tester t) {
	return t.checkExpect(mtbibliography.removeDup(), this.mtbibliography) &&
			t.checkExpect(lob5.removeDup(), lob4) && 
			t.checkExpect(lob7.removeDup(), lob1) &&
			t.checkExpect(lob8.removeDup(), lob1) &&
			t.checkExpect(lob2.removeDup(), lob2) &&
			t.checkExpect(lob3.removeDup(), lob6) &&
			t.checkExpect(lob9.removeDup(), lob6);
}


boolean testIBibliographyduplicateHelper(Tester t) {
	return t.checkExpect(mtbibliography.duplicateHelper(bdb1), false) &&
			t.checkExpect(lob1.duplicateHelper(bdb1), true)
			;
}

}

