application test

section model

//A
entity SuperA {
	a :: String
}
extend entity SuperA {
	b :: String
}
entity A : SuperA{
	c :: String
}

searchmapping SuperA{
	b as searchfield
}
searchmapping A{
	
}
//B
entity SuperB {
	a :: String
}
entity B : SuperB{
	b :: String
}

searchmapping B{
	b as searchfield;
}
//C
entity C {
	a :: String
}
extend entity C {
	b :: String
}
searchmapping C{
	b as searchfield;
}
//D
entity D{
	someAs -> Set<A>
}
searchmapping D{
	someAs
}
//E
entity E{
	a :: String
}
extend entity E{
	searchmapping {
		a as b
	}
}
//F
entity F{
	a :: String
	searchmapping {
		a as b;
	}
}
//G (searchable anno and multiple searchmappings)
entity G {
	a :: String (searchable)
	searchmapping{
		a as a2 using no (spellcheck);
	}
	searchmapping{
		a using no as a3 (autocomplete);
	}
}

searchmapping G{
	a as a4 boosted to 3.0;
}

//H
entity H : G{
	b :: String
	searchmapping{} //empty search mapping will make H searchable, using searchfields of superclass
}


// Above mappings should result in each entity to be indexed and static search functions created.
define page root() {
	
	action test() {
		var x1 := searchA("x");
		var x2 := searchB("x");
		var x3 := searchC("x");
		var x4 := searchD("x");
		var x5 := searchE("x");
		var x6 := searchF("x");
		var x7 := searchG("x");
		var x8 := searchH("x");
		var y1 : List<A> := x1;
		var y2 : List<B> := x2;
		var y3 : List<C> := x3;
		var y4 : List<D> := x4;
		var y5 : List<E> := x5;
		var y6 : List<F> := x6;
		var y7 : List<G> := x7;
		var y8 : List<H> := x8;
		var z1 : List<A> := ASearcher().query("webdsl").list();
		var z2 : List<B> := BSearcher().query("webdsl").list();
		var z3 : List<C> := CSearcher().query("webdsl").list();
		var z4 : List<D> := DSearcher().query("webdsl").list();
		var z5 : List<E> := ESearcher().query("webdsl").list();
		var z6 : List<F> := FSearcher().query("webdsl").list();
		var z7 : List<G> := GSearcher().query("webdsl").list();
		var z8 : List<H> := HSearcher().query("webdsl").list();
	}
		
}
