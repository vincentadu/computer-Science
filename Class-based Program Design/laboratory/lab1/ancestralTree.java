//Self-Referential Data
//The HtDP book includes the data definition for Ancestor Trees:
//
//;; An Ancestor Tree (AT) is one of
//;; -- 'unknown
//;; -- (make-tree Person AT AT)
// 
//;; A Person is defined as above
//Convert this data definition into Java classes and interfaces. 
//What options do you have for how to translate this into Java? 
//Make examples of ancestor trees that in at least one branch cover at least three generations.
interface IAT{
	
}

class Unknown implements IAT{
	Unknown () {}
}

class ATPerson implements IAT{
	String name;
	IAT mom;
	IAT dad;
	ATPerson (String name, IAT mom, IAT dad){
		this.name = name;
		this.mom = mom;
		this.dad = dad;
		}
}

class ExamplesIAT {
	
	Unknown unknown = new Unknown ();
	ATPerson m1 = new ATPerson ("Carmelita", unknown, unknown );
	ATPerson f1 = new ATPerson ("Enoy", unknown, unknown );
	ATPerson m2 = new ATPerson ("Angelita", unknown, unknown );
	ATPerson f2 = new ATPerson ("Victoriano", unknown, unknown );
	ATPerson m3 = new ATPerson ("Joan", m1, f1 );
	ATPerson f3 = new ATPerson ("Vincent", m2, f2 );
	ATPerson m4 = new ATPerson ("Nicole", m3, f3 );
	
	
}
