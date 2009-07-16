//Function with signature duplicate(Int, String) for Entity User is defined multiple times.
application test

  entity User{
    name :: String
    function duplicate(a:Int,b:String):String
    {
      return b;
    }
  }
  
  extend entity User{
    number :: Int
    function duplicate(a:Int,b:String):String
    {
      return "test";
    }
  }
  
  define page home(){
    var u:User := User{};
    output(u.name)
   }