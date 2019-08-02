application derivedpropertycache

page root(){}

entity Example {
  i    : Int
  list : [Example]
  all  : [Example] (cache) := [e | e : Example in list]
  num  : Int (cache) := i * 100
}

test{
  var e := Example{};
  var tmp := e.all;
  e.list.add( Example{} );
  assert(tmp.length == 0);
  assert(e.all.length == 0);
  e.invalidateAll();
  assert(e.all.length == 1);
  assert(e.list.length == 1);
  e.i := 2;
  var tmpnum := e.num;
  e.i := 3;
  assert(e.num == 200);
}
