//#2 Assignment to this property is not allowed.
//No property third defined

application test

page root {}

test {
  [1,2].length := 1;
  var x := (1,2);
  x.first := 1;
  var xlist: [Int,String] := [(1,"123"),(true,2)];
  xlist[1].third;
}
