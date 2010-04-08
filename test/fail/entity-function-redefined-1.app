//Function with signature duplicate(Int, String) of entity 'User' is defined multiple times.
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
  
  define page root(){
    var u:User := User{};
    output(u.name)
   }
