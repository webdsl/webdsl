//no analyzer defined with name: unknownAnalyzer
//unknownProp is no property owned by A
//a subclass can only be targeted on a reference (->) or composite (<>) type property
//unknown entity: unknownSubclass
//C is not a subclass of SuperA
//only simple properties owned by D can be used as namespace identifier
//#2 depth of embedding can only be specified on a reference (->) or composite (<>) type property
//an analyzer can only be specified in a mapping for simple properties. For reference/composite properties, the analyzers should be specified in the search mapping of the embedded type
//#2 a boost value can only be specified in a mapping for simple properties. For reference/composite properties, boost values should be specified in the search mapping of the embedded type
application test

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
    b using unknownAnalyzer //no analyzer defined with name: unknownAnalyzer
    a with depth 3 //depth of embedding can only be specified on a reference (->) or composite (<>) type property
    a depth 3 //depth of embedding can only be specified on a reference (->) or composite (<>) type property
}
search mapping A{
   unknownProp //unknownProp is no property owned by A
}
//C
entity C {
    a :: String
}
//D
entity D{
    val :: String
    someAs -> Set<SuperA>
}
search mapping D{
    val for subclass nonexisting //a subclass can only be targeted on a reference (->) or composite (<>) type property
    someAs for subclass unknownSubclass //unknown entity: unknownSubclass
    someAs for subclass C //C is not a subclass of SuperA
    namespace by someAs //only simple properties owned by D can be used as namespace identifier
    someAs using myAnalyzer //an analyzer can only be specified in a mapping for simple properties. For reference/composite properties, the analyzers should be specified in the search mapping of the embedded type
    someAs^1.3 //a boost value can only be specified in a mapping for simple properties. For reference/composite properties, boost values should be specified in the search mapping of the embedded type
    someAs boosted to 2.0 //a boost value can only be specified in a mapping for simple properties. For reference/composite properties, boost values should be specified in the search mapping of the embedded type
}

analyzer myAnalyzer{
    //charfilter = aCharFilter
    tokenizer = StandardTokenizer
    //tokenfilter = aTokenFilter
}