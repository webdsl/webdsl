application test

  define page root() {
  }
  
  entity Foo{
    static function bla():String{
      return f1.name;
    }
  }
  
  var f1 := Foo{}
  var f2 := Foo{}
  var f3 := Foo{}
  var f4 := Foo{}
  
  
  test staticmethod{
    assert(Foo.bla()==f1.name);
  }