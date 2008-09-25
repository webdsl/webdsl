// Extend session/entity redefines function: function test ( a : Int b : String ) : String
application test

section datamodel

  entity User{
    name :: String
    function test(a:Int,b:String):String
    {
      return b;
    }
    
    
  }
  
  extend entity User{
    number :: Int
    function test(a:Int,b:String):String
    {
      return "test";
    }
  }

  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    var u:User := User{};
    define body()
    {
      output(u.name)
    }
   }