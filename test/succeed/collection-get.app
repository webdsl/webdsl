application test

page root(){}

test get {
  var list := [ 1, 2, 3 ];
  assert( list[1] == 2 );
  assert( list.get(2) == 3 );

  var set := { "1", "2", "3" };
  assert( set[1] == "2" );
  assert( set.get(2) == "3" );
}

test firstlast {
  var list := [ 1, 2, 3 ];
  assert( list.first == 1 );
  assert( list.last == 3 );

  var set := { "1", "2", "3" };
  assert( set.first == "1" );
  assert( set.last == "3" );
}

test random {
  var list := [ 1, 2, 3 ];
  assert( list.random() > 0 );
  assert( list.random() < 4 );

  var set := { "1", "2", "3" };
  var setrandom := set.random();
  assert( setrandom == "1" || setrandom == "2" || setrandom == "3" );

  assert( random( 4 ) >= 0 );
  assert( random( 4 ) < 4 );
  assert( random( 1, 2 ) > 0 );
  assert( random( 1, 2 ) < 3 );
  assert( list[ random( 1, 2 ) ] == 2 );
}

request var list := List<Int>()
request var set  := Set<Int>()

test { var x := list.random(); }
test { var x := list.get(0); }
test { var x := list[0]; }
test { var x := list.first; }
test { var x := list.last; }

test { var x := set.random(); }
test { var x := set.get(0); }
test { var x := set[0]; }
test { var x := set.first; }
test { var x := set.last; }
