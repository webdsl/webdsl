application test

page root(){}

function casetest1( option: String ): String {
  case( option ){
    "1"            { return "q"; }
    "1"+"!"        { return "w"; }
    getStringVal() { return "e"; }
    default        { return "r"; }
  }
}

function getStringVal(): String {
  return "3";
}

entity Foo {
  i : Int
}
entity SubFoo : Foo {}

function casetest2( arg: Foo ): String {
  case( true ){
    arg.i == 0     { return "a"; }
    arg.i == 1     { return "b"; }
    arg.i + 1 > 5  { return "c"; }
    arg isa SubFoo { return "d"; }
    default        { return "e"; }
  }
}

function casetest3( one: String, two: Foo ): String {
  case( one, two ){
    "1", testa { return "p"; }
    "2", testa { return "o"; }
    "3", testb { return "i"; }
    "4", testb { return "u"; }
    default    { return "y"; }
  }
}

function casetest4( one: String, two: Foo, three: Int, four: Float ): String {
  case( one, two, three, four ){
    "1", testa, 1, 1.0 { return "m"; }
    "2", testa, 1, 2.0 { return "n"; }
    default            { return "b"; }
  }
}

var testa := Foo{}
var testb := Foo{}

test {
  assert( casetest1("1")  == "q" );
  assert( casetest1("1!") == "w" );
  assert( casetest1("3")  == "e" );
  assert( casetest1("ds") == "r" );

  assert( casetest2(Foo{ i := 0 })  == "a" );
  assert( casetest2(Foo{ i := 1 })  == "b" );
  assert( casetest2(Foo{ i := 5 })  == "c" );
  assert( casetest2(Foo{ i := -3 }) == "e" );
  assert( casetest2(SubFoo{ i := -3 }) == "d" );

  assert( casetest3("5", testb) == "y" );
  assert( casetest3("4", testb) == "u" );
  assert( casetest3("3", testb) == "i" );
  assert( casetest3("2", testa) == "o" );
  assert( casetest3("1", testa) == "p" );

  assert( casetest4("1", testa, 1, 1.0) == "m" );
  assert( casetest4("2", testa, 1, 2.0) == "n" );
  assert( casetest4("1", testb, 1, 1.0) == "b" );
}
