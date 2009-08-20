//Function with signature test(Int, String) for Entity User is defined multiple times.
application test

  entity User{
    name :: String

  }
  
  extend entity User{

    function test(a:Int,b:String):String
    {
      return "test";
    }
  }
  extend entity User{
    
    function test(a:Int,b:String):String
    {
      return "test";
    }
  }
  
  define page root(){
    var u:User := User{};
    output(u.name)
   }
