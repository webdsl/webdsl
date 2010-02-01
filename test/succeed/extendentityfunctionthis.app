application test

section datamodel

  entity User{
    name :: String

    function inUser(a: Int, b: Int): Int {
      return a + b;
    }
  }
  
  extend entity User{
    name2 :: String
  
    function test(a:Int, b:Int) : Int
    {
      return inUser(a, b);
    }
  }


  define page root(){
    var u:User := User{};
    output(u.name2)
    "expects 7 : " output(u.test(2, 3))
   }
