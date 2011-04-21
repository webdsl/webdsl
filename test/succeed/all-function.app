application test

  define page root() {
  }
  
  entity Foo{
    
  }
  
  var f1 := Foo{}
  var f2 := Foo{}
  var f3 := Foo{}
  var f4 := Foo{}
  
  
  test allfunction{
    assert(f1.all().length==4);
    assert(Foo.all().length==4);
  }