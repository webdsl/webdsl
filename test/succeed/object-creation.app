application test

  define page root(){header{"dsfdgfG"}}
  
  entity Test{
  	name :: String
  	b :: Bool
  	i :: Int
  	f :: Float
  }
  
  function createTest(name:String,b:Bool,i:Int,f:Float) : Test{
    return Test{ name := name b := b i := i f := f};  	
  }
  
  test one {
  	var t := Test{};
    assertDefaults(t);
  	
  	var et := createEmptyTest();
  	assertDefaults(et);
  	
  	var dt := createTest("",false,0,0.0);
  	assertDefaults(dt);
  }

  function assertDefaults(t:Test){
  	assert(t != null);
  	assert(t.name == "");
  	assert(t.b == false);
  	assert(t.i == 0);
  	assert(t.f == 0.0);
  }
  
  //constructor events
  entity A : B{
    extend function A(){
      name := name +"A";
    }	
  }
  
  entity B:C{
  	extend function B(){
      name := name +"B";
    }	
  }
  entity C{
  	name :: String
  	extend function C(){
      name := name +"C";
    }	
  }
  
  test two {
  	var t := A{};
  	assert(t.name == "CBA");
  }
  
  //global var objectcreation
  
  var a := A{ name := "111"}
  
  test three{
  	assert(a.name=="111");
  	
  }
  
  //special case of secret type property in global var init
  //global var objectcreation
  entity TestSecret{
  	s :: Secret
  	
  }
  var ts := TestSecret{ s := "111"}
  
  test four{
  	assert(ts.s!="111");
  	assert(ts.s.check("111" as Secret));
  }
  