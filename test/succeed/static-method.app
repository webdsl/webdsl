application test

  define page root() {
  }
  
  entity Foo{
    static function bla():String{
      return f1.name;
    }
    static function blaWithArg(f : Foo):String{
      return f.name;
    }
    static function blaOverload(f : Foo):String{
      return f.name;
    }
    static function blaOverload(f : Foo, ff : Foo):String{
      return ff.name;
    }

  }

  var f1 := Foo{}
  var f2 := Foo{}
  var f3 := Foo{}
  var f4 := Foo{}
  
  
  test staticmethod{
    assert(Foo.bla()==f1.name);
    assert(Foo.blaWithArg(f2)==f2.name);
    assert(Foo.blaOverload(f3)==f3.name);
    assert(Foo.blaOverload(f3, f4)==f4.name);
  }