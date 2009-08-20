application test

section datamodel

  entity User{
    name :: String
  }
  
  define page root(){
    navigate(viewUser(45,"thestring",true,345.54)) {"view"}
  }


  define page viewUser(i:Int,s:String,b:Bool,f:Float)
  {
     output(i)
     output(s)
     output(f)
  }
