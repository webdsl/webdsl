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
  var u:User := User{name := "bob" };
  var u1:User := User{name := "alice"};
  var u2:User := User{name := "charlie"};
  var u3:User := User{name := "dave"};
  
  define page root(){
    main()
    define body(){
    init{
      var u11:User := User{name := "alice" self := u1};
      var u22:User := User{name := "charlie" self := u2};
      var u33:User := User{name := "dave" self := u3};
      u.childrenset := {u1,u2};
      u.children := [fr.self | fr : User in [u11,u22,u33]];
    }

    if(u1 in u.children)
    {
      "test ok"
    }
    else
    {
      "test fail"
    }
    
    output(u.children)
    "-"
    output(u.childrenset)
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
  
  
entity OrderTest{
  first  : Int
  second : Int
  nested : OrderTest
}
var ob1 := OrderTest{ first := 1 second := 2 nested := OrderTest{ first := 2 second := 1 } }
var ob2 := OrderTest{ first := 1 second := 1 nested := OrderTest{ first := 1 second := 1 } }
test implicittype{
  assert([x | x in [1,2,3]] == [1,2,3]);
  assert([y.id | y in [Lab{},Lab{}]].length == 2);
  assert([x.parseInt() | x in ["1","2"] where x == "1"] == [1]);
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
