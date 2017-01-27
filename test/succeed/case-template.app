application test

page root(){}

template casetest1( option: String ) {
  case( option ){
    "1"            { "q" }
    "1"+"!"        { "w" }
    getStringVal() { "e" }
    default        { "r" }
  }
}

function getStringVal(): String {
  return "3";
}

entity Foo {
  i : Int
}
entity SubFoo : Foo{}

template casetest2( arg: Foo ) {
  case( true ){
    arg.i == 0     { "a" }
    arg.i == 1     { "b" }
    arg.i + 1 > 5  { "c" }
    arg isa SubFoo { "d" }
    default        { "e" }
  }
}

template casetest3( one: String, two: Foo ) {
  case( one, two ){
    "1", testa { "p" }
    "2", testa { "o" }
    "3", testb { "i" }
    "4", testb { "u" }
    default    { "y" }
  }
}

template casetest4( one: String, two: Foo, three: Int, four: Float ) {
  case( one, two, three, four ){
    "1", testa, 1, 1.0 { "m" }
    "2", testa, 1, 2.0 { "n" }
    default            { "b" }
  }
}

var testa := Foo{}
var testb := Foo{}

test {
  assert( rendertemplate(casetest1("1"))  == "q" );
  assert( rendertemplate(casetest1("1!")) == "w" );
  assert( rendertemplate(casetest1("3"))  == "e" );
  assert( rendertemplate(casetest1("ds")) == "r" );

  assert( rendertemplate(casetest2(Foo{ i := 0 }))  == "a" );
  assert( rendertemplate(casetest2(Foo{ i := 1 }))  == "b" );
  assert( rendertemplate(casetest2(Foo{ i := 5 }))  == "c" );
  assert( rendertemplate(casetest2(Foo{ i := -3 }))  == "e" );
  assert( rendertemplate(casetest2(SubFoo{ i := -3 })) == "d" );

  assert( rendertemplate(casetest3("5", testb))  == "y" );
  assert( rendertemplate(casetest3("4", testb))  == "u" );
  assert( rendertemplate(casetest3("3", testb))  == "i" );
  assert( rendertemplate(casetest3("2", testa))  == "o" );
  assert( rendertemplate(casetest3("1", testa))  == "p" );

  assert( rendertemplate(casetest4("1", testa, 1, 1.0))  == "m" );
  assert( rendertemplate(casetest4("2", testa, 1, 2.0))  == "n" );
  assert( rendertemplate(casetest4("1", testb, 1, 1.0))  == "b" );
}
