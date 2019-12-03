application test

section datamodel

  define override body() {
    "default body"
  }

  entity User{
    name     :: String
    children -> List<User>
    childrenset -> Set<User>
    self     -> User
  }
  var u0:User := User{name := "bob" }
  var u1:User := User{name := "alice"}
  var u2:User := User{name := "charlie"}
  var u3:User := User{name := "dave"}

  define page root(){
    main()
    define body(){
    init{
      var u11:User := User{name := "alice" self := u1};
      var u22:User := User{name := "charlie" self := u2};
      var u33:User := User{name := "dave" self := u3};
      u0.childrenset := {u1,u2};
      u0.children := [fr.self | fr : User in [u11,u22,u33]];
    }

    if(u1 in u0.children)
    {
      "test ok"
    }
    else
    {
      "test fail"
    }

    output(u0.children)
    "-"
    output(u0.childrenset)
    }
  }

  define override main(){
    body()
  }

  define page user(u:User){
    derive viewPage from u
  }
  /*
  predicate isEducationDirector(p : Person, c : Course) {
    p != null && Or [e in p.directs | e : Education in c.educations]
  }
*/
  function bar(ilist:List<Int>):Bool{
    return Or [i==3 | i:Int in ilist];
  }
  predicate foo(ilist:List<Int>){
    Or [i==3 | i:Int in ilist]
  }
  test orlist{
    var ilist := [1,2,3,4,5];  
    assert(Or [i==3 | i:Int in ilist]);
    assert(foo(ilist));
    assert(bar(ilist));
  }


  entity Lab{
    coll : [Lab]
    order : Int
  }
  template classify(c: Lab){
    // these 'l' names are not in overlapping scopes
    for(l:Int in [l.order | l: Lab in c.coll order by l.order asc]){
      output(l)
    }
  }
  test{
    var testobj := Lab{ coll := [Lab{order:=1},Lab{order:=2}] };
    assert(rendertemplate(classify(testobj)) == "12");
  }


test implicittype {
  assert([x | x in [1,2,3]] == [1,2,3]);
  assert([y.id | y in [Lab{},Lab{}]].length == 2);
  assert([x.parseInt() | x in ["1","2"] where x == "1"] == [1]);
}


entity OrderTest {
  first  : Int
  second : Int
  nested : OrderTest
}
var ob1 := OrderTest{ first := 1 second := 2 nested := OrderTest{ first := 2 second := 1 } }
var ob2 := OrderTest{ first := 1 second := 1 nested := OrderTest{ first := 1 second := 1 } }
test multipleorderby {
  assert([foo.second | foo in [ob1, ob2] order by foo.first, foo.second] == [1, 2]);
  assert([x.nested.first | x in [ob1, ob2] order by x.nested.second asc, x.nested.first asc] == [1, 2]);
  assert([x.nested.first | x in [ob1, ob2] order by x.nested.second asc, x.nested.first desc] == [2, 1]);
  assert([x.nested.first | x in [ob1, ob2] order by x.nested.first desc, x.nested.second asc] == [2, 1]);
  for(foo in [ob1, ob2] order by foo.first, foo.second limit 1){
    assert(foo == ob2);
  }
  var list := [OrderTest{ first := 1 second := 3 }, OrderTest{ first := 1 second := 1 }, OrderTest{ first := 1 second := 4 }, OrderTest{ first := 1 second := 2 }];
  assert([x.second | x in list order by x.first, x.second] == [1, 2, 3, 4]);
  var listnulls := [OrderTest{ first := null second := 3 }, OrderTest{ first := 1 second := null }, OrderTest{ first := null second := 2 }];
  assert([x.second | x in listnulls order by x.first, x.second] == [null as Int, 2, 3]);
  assert([x.second | x in listnulls order by x.first] == [null as Int, 3, 2]);
}

entity GroupByTest {
  i : Int
  s : String
  d : DateTime
  nested : GroupByTest
}
var gb1 := GroupByTest{ i := 0 s := "c" nested := GroupByTest{ i := 2 } d := now().addYears(-1) }
var gb2 := GroupByTest{ i := 1 s := "b" nested := GroupByTest{ i := 1 } d := now().addYears(1) }
var gb3 := GroupByTest{ i := 1 s := "c" nested := GroupByTest{ i := 3 } d := now().addYears(-1) }
var gb4 := GroupByTest{ i := 0 s := "a" nested := GroupByTest{ i := 1 } }
var gb5 := GroupByTest{ i := 0 s := "a" }
var gb6 := GroupByTest{ i := 0 s := "a" nested := null }
var gb7 := GroupByTest{ i := 0 s := "a" nested := null }

init {
  gb5.nested := gb4.nested;
}

test groupby {
  assert([x | x in [1,2,3] group by x] == [[1],[2],[3]] );
  assert([e.i | e in [gb1,gb2,gb3,gb4] group by e.i] == [[0,0],[1,1]]);
  assert([e | e in [gb1,gb2,gb3,gb4] group by e.s] == [[gb1,gb3],[gb2],[gb4]]);
  assert([e | e in [gb1,gb2,gb3,gb4] order by e.s group by e.s] == [[gb4],[gb2],[gb1,gb3]]);
  assert([e | e in [gb1,gb2,gb3,gb4] order by e.s, e.i desc group by e.s] == [[gb4],[gb2],[gb3,gb1]]);
  assert([e | e in [gb1,gb2,gb3,gb4] group by e.nested.i] == [[gb1],[gb2, gb4],[gb3]]);
  assert([e | e in [gb1,gb2,gb3,gb4] group by e.nested] == [[gb1],[gb2],[gb3],[gb4]]);
  assert([e | e in [gb4,gb5,gb6,gb7] group by e.nested] == [[gb4,gb5],[gb6,gb7]]);
  assert([e | e in [gb1,gb2,gb3] group by now().after(e.d)] == [[gb1,gb3],[gb2]]);
}

test nested {
  assert( [ x | x in [0,1] where x in [ y | y in [x,2] ] ] == [0,1] );
  var tmp := 0;
  assert( [ x | x in [tmp,1] where x in [ y | y in [tmp,2] where x == y ] ] == [0] );
  assert( [ x | x in [tmp,1] where x in [ y | y in [tmp,2] where y in [ z | z in [tmp,3] where x == y && y == z ] ] ] == [0] );
  regression1();
  rendertemplate(regression2());
}

entity SigTest{
  i : Int
}
template regression2() {
  var col := [ i | i in [SigTest{}] ]
  for( i: SigTest in col ){}
}
function regression1() {
  var col := [ i | i in [SigTest{}] ];
  for( x: SigTest in col ){}
}
