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
  
  // http://yellowgrass.org/issue/WebDSL/807
  entity User {
    static function check() : Int { 
      var q : Int := 10;
      return q;
    }
	static function checkStuff(a : Int) : String { 
		var x : String := "x";
		var str : String := "String";
		//var y : Int;
		var q := 10;
		//var r := 20;
		var q1 := q;
		var j := a;
		var lst : [Int] := [1, 2, 3, 4];
		var z0 : Int := 0;
		var lst0 := lst[z0];
		//var k := null;
		var b := q1 == 10;
		var z := if (b) x else str;
		//var c1 : Bool := false;
		//var lst00 := lst0;
		var loop : Int;
		for (foo : Int from 3 to 10){
		  loop := loop + foo;
		}
		var z2 := z;
		return z2+q+j+loop;
	}
	static function other(a1 : Int) : Int
	{
		return a1+1;
	}
  }
  
  test staticmethod{
    assert(Foo.bla()==f1.name);
    assert(Foo.blaWithArg(f2)==f2.name);
    assert(Foo.blaOverload(f3)==f3.name);
    assert(Foo.blaOverload(f3, f4)==f4.name);
    assert(User.check() == 10);
    assert(User.checkStuff(123) == "x1012342");
  }
  
  
