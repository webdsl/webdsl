application test

section model

//A
entity SuperA {
    a :: String
    myD -> D
}
extend entity SuperA {
    b :: String (searchable(name = searchfield, analyzer = no)^4.0)
}
entity A : SuperA{
    c :: String (searchable)
}

//B
entity SuperB {
    a :: String
}
entity B : SuperB{
    b :: String (searchable(name = c))
    c :: String (searchable(name = b))
}

//C
entity C {
    a :: Int
}
extend entity C {
    b :: Int (searchable)
}

//D
entity D{
    someAs -> Set<A> (searchable, inverse=A.myD)
}

//E
entity E{
    a :: String
}
extend entity E{
    b :: Int (searchable(analyzer = no, name = number, boost = 0.001, autocomplete, spellcheck, numeric))
    //the arguments autocomplete,spellcheck and numeric are used as flags, their value are ignored.
}
//F
entity F{
    a :: String (searchable, searchable(name = aUntokenized, analyzer = no), searchable(name = aBoosted)^4.0)
}
//G
entity G {
    a :: String (searchable)
}

//H
entity H : G{
    b :: String
    search mapping{} //empty search mapping will make H searchable, using searchfields of superclass
}


// Each entity should be indexed and static search functions created.
define page root() {

    action test() {
        var x1 := searchA("x",0,10);
        var x2 := searchB("x",10);
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
        var z1 : List<A> := ASearcher().query("webdsl").results();
        var z2 : List<B> := BSearcher().query("webdsl").results();
        var z3 : List<C> := CSearcher().query("webdsl").results();
        var z4 : List<D> := DSearcher().query("webdsl").results();
        var z5 : List<E> := ESearcher().query("webdsl").results();
        var z6 : List<F> := FSearcher().query("webdsl").results();
        var z7 : List<G> := GSearcher().query("webdsl").results();
        var z8 : List<H> := HSearcher().query("webdsl").results();

    }

}
