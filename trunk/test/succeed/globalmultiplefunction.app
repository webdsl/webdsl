application test

section datamodel

  entity User{
    username :: String
  }

  function test1(a:Int):Int
  {
    return a+1;
  }
  function test2(a:Int,b:Int):Int
  {
    return a-b;
  }
  globals {
    function test3(a:Int,b:Int):Int
    {
      return a-b;
    }
  }
  globals {
    function test4(a:Int,b:Int):Int
    {
      return a+b;
    }
    function test5(a:Int,b:Int):Int
    {
      return a*b;
    }
  }  

  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    
    define body()
    {
      if(test1(5)+test2(5,6)+test3(2,6)+test4(4,3)+test5(7,9)>5)
      {
        "test"
      }
      
    }
   }