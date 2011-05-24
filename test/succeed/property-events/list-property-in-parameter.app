application bla

  entity Foo{
    list -> List<Foo> (inverse=Foo.back)
    t :: String
    extend function addToList(s: Foo){
      t := "123";
    }
    extend function removeFromList(s: Foo){
      t := "456";
    }
    back -> Foo
  }
  
  var gfoo := Foo{}
  
  test bla{
    var f := Foo{};
    bar(f.list);
    assert(f.t=="123");
    assert(gfoo.back==f);
    
    test1(f.list);
    assert(f.t=="456");
    assert(gfoo.back==null);
    
  }
  
  function bar(l:List<Foo>){
    l.add(gfoo);
  }
  
  predicate test1(l:List<Foo>){
    test2(l)
  }
  
  function test2(l1:List<Foo>):Bool{
    l1.remove(gfoo);
    return true;
  }
  
  define page root(){}