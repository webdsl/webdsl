application test

section datamodel

  entity User{
    username :: String
  }

  function test(a:Int):Int
  {
    return a+1;
  }

  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    
    define body()
    {
      if(test(5)>5)
      {
        "test"
      }
      
    }
   }