application test

  define page root(){
  }
  
  native class java.util.UUID as Foo {
    static randomUUID():Object
  }
  
  entity Test{
    name :: String
    tmp :: Object (transient)
  }
  
  test {
    var f := Test{ name := "1" tmp := Foo.randomUUID() };
    f.save();
    var all := Test.all();
    assert(all.length==1 && all[0].name=="1");
  }
