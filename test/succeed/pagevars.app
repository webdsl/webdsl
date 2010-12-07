application test

section datamodel

  entity User{
    name :: String
  }

  entity User2{
    name :: String (id)
  }
  
  define page root(){
    var us:User;
    var us1:User;
    var us2:User;
    var us3:User;
  
    var users:Set<User> := {us,us1,us2,us3};
  
    var u:User := User{};
    var u1:User;
    var u2:User2 := User2{};
    var u3:User2;
    var s:String;
    var i:Int;
    var f:Float;
    var b:Bool;    
    var s1:String := "jdfhskjsf";
    var i1:Int := 445;
    var f1:Float := 435.345;
    var b1:Bool := false; 
    
    input(u.name)
    output(u.name)
    input(u1.name)
    output(u1.name)
    input(u2.name)
    output(u2.name)
    input(u3.name)
    output(u3.name)
    input(s)
    output(s)
    input(i)
    //output(i)
    input(f)
    output(f)
    input(b)
    output(b)
    input(s1)
    output(s1)
    input(i1)
    //output(i1)
    input(f1)
    output(f1)
    input(b1)
    output(b1)
    
    div
    {
      input(b1)
    }
    
    div
    {
      input(b1)
      input(s)
      input(i)
    }
    
    block("test")
    {
    
    }
  }


