//Function with signature test(Int, String) of entity 'Test' is defined multiple times.
application test

  session test{
    name :: String

  }
  
  extend session test{

    function test(a:Int,b:String):String
    {
      return "test";
    }
  }
  extend session test{
    
    function test(a:Int,b:String):String
    {
      return "test";
    }
  }