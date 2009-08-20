application test

section datamodel

  entity User{
    name :: String
  }

  entity User2{
    name :: String (id)
  }
  
  define page root(){
    
    var u:User;
    var u1:User;
    var u2:User2;
    var u3:User2;
    var s:String;
    var i:Int;
    var f:Float;
    var b:Bool;    
    
    output(u.name)
    output(u1.name)
    output(u2.name)
    output(u3.name)
    output(s)
    output(f)
    output(b)
    output(i)
    
    
    init{
      u := User{name := "u"};
      u1 := User{name := "u1"};
      u2 := User2{name := "u2"};
      u3 := User2{name := "u3"};
      s := "s";
      f := 45644.456;
      b := true;
      i := 453;
    }

  }


