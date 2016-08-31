application test

page root() {}

entity Foo {}

extend entity Foo {
  a : String ( id )
}

var a := Foo{ a := "1" }

test{
  assert( findFoo( "1" ) == a );
  assert( ! isUniqueFooId( "1" ) );
  assert( isUniqueFooId( "2" ) );
}