//#4 Expected type

application test

page root {}

entity Bla : Bla1 {}

entity Bla1 {}

function test( arg: Bool ) {
  var x := [ true, 1, arg, Bla{} ];
  var y := [ false, 1, 2, arg ];
  var z := [ Bla1{}, Bla{} ];
  log( "" + x[0] + y[0] + z[0].name );
}
