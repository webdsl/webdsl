application atermtest

  define page root(){
  }
  
  test aterm {
    var s := "Foo(\"123\",456,[789])";
    var a := s.parseATerm(); 
    assert(a.constructor()=="Foo");
    assert(a.subterms().length==3);
    assert(a.stringValue()==s);
    assert(a.get(1).toInt()==456);
    assert(a.get(0).toString()=="\"123\"");
    assert(a.get(2).length()==1);
  }
