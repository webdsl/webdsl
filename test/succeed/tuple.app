application test

page root {}

entity Tmp {}

test {
  // typed tuples
  // immutable after construction (referenced entities are mutable internally)

  var x: (Int,String) := (1,"123");
  assert( x.first == 1);
  assert( x.second == "123" );
  assert( x.length == 2 );
  assert( (1,"123") == (1,"123") );
  assert( x == (1,"123") );
  assert( (1,"123") != (2,"123") );

  var ten: (Int,Int,Int,Int,Int,Int,Int,Int,Int,Int) := (1,2,3,4,5,6,7,8,9,10);
  assert( ten.first   == 1 );
  assert( ten.second  == 2 );
  assert( ten.third   == 3 );
  assert( ten.fourth  == 4 );
  assert( ten.fifth   == 5 );
  assert( ten.sixth   == 6 );
  assert( ten.seventh == 7 );
  assert( ten.eighth  == 8 );
  assert( ten.ninth   == 9 );
  assert( ten.tenth   == 10 );
  assert( ten.length == 10 );

  assert( check() );

  var xlist: [Int,String] := [ (1,"123"), returntuple() ];
  assert( xlist[ 0 ] == x );
  assert( xlist[ 0 ] == returntuple() );

  var t := Tmp{};
  var z := [(t,1),(Tmp{},2)];
  assert( z[ 0 ].first == t );
  assert( z[ 1 ].first != t );

  assert( null as (Int,Int) != (1,2) );
  assert( (1,2) != null as (Int,Int) );
  assert( (1,2) == (1,2) );
  assert( (1,2) != (1,3) );

  var nullvals: (Int,Int) := (null as Int, null as Int);
  assert( (null as Int, null as Int) == nullvals );
  assert( (null as Int, 1) != nullvals );
  assert( (null as Int, 1) != (null as Int, 2) );
  assert( (null as Int, 1) == (null as Int, 1) );
}

function returntuple: (Int, String) {
  return (1,"123");
}

function check: Bool {
  return (1,"123") == (1,"123") && (1,"123") != (2,"123");
}
