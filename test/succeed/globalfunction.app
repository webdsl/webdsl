application test

section datamodel

  define body() {
    "default body"
  }
  
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
  
  define page root(){
    main()
    
    define body()
    {
      if(test(5)>5)
      {
        "test"
      }
      
    }
   }
