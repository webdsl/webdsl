application test

section datamodel

  entity User{
    name :: String
  }

  entity User2{
    name :: String (id)
  }
  
  define page home(){
    var u:User := User{};
    var u1:User;
    var u2:User2 := User2{};
    var u3:User2;
    var s:String;
    var i:Int;
    var f:Float;
    var b:Bool;    
    var s:String := "jdfhskjsf";
    var i:Int := 445;
    var f:Float := 435.345;
    var b:Bool := false; 
  }


