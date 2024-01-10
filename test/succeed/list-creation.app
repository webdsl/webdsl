application test

page root {}

entity Tmp {
  i : Int
}
var globaltmp1 := Tmp{ i := 1 }
var globaltmp2 := Tmp{ i := 2 }
var globaltmp3 := Tmp{ i := 3 }

test {
  var a := [ Tmp{}, Tmp{}, globaltmp1 ];
  assert( a.length == 3 );
  assert( [ 1, 2, 3, 4 ][ 3 ] == 4 );
  assert( [ 1, 2, 3, for( i in [ 4, 5, 6 ] ){ i, i*2, i*3 } ].length == 12 );
  assert( [ for( i in [ 4, 5, 6 ] order by i desc ){ i } ][ 0 ] == 6 );
  assert( [ for( t: Tmp order by t.i desc ){ t.i } ][ 0 ] == 3 );
  assert( [ for( i: Int from 0 to 5 ){ i } ].length == 5 );

  var b := { Tmp{}, Tmp{}, globaltmp1 };
  assert( b.length == 3 );
  assert( { 1, 2, 3, 4 }[ 3 ] == 4 );
  assert( { 1, 2, 3, for( i in [ 4, 5, 6 ] ){ i, i*2, i*3 } }.length == 11 );
  assert( { for( i in [ 4, 5, 6 ] order by i desc ){ i } }[ 0 ] == 6 );
  assert( { for( t: Tmp order by t.i desc ){ t.i } }[ 0 ] == 3 );
  assert( { for( i: Int from 0 to 5 ){ i } }.length == 5 );

}
