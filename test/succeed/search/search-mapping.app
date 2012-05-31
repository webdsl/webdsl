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

search mapping SuperA{
    b as searchfield
}
search mapping A{

}
//B
entity SuperB {
    a :: String
}
entity B : SuperB{
    b :: String
}

search mapping B{
    b as searchfield;
}
//C
entity C {
    a :: String
}
extend entity C {
    b :: String
}
search mapping C{
    b as searchfield;
}
//D
entity D{
    someAs -> Set<A>
}
search mapping D{
    someAs
}
//E
entity E{
    a :: String
}
extend entity E{
    search mapping {
        a as b
    }
}
//F
entity F{
    a :: String
    search mapping {
        a as b;
    }
}
//G (searchable anno and multiple search mappings)
entity G {
    a :: String (searchable)
    search mapping{
        a as a2 using no (spellcheck);
    }
    search mapping{
        a using no as a3 (autocomplete);
    }
}

search mapping G{
    a as a4 boosted to 3.0;
}

//H
entity H : G{
    b :: String
    search mapping{} //empty search mapping will make H searchable, using searchfields of superclass
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
