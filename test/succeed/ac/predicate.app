application test

section principal

  define body() {
    "default body"
  }
  
  entity User{
    name :: String
  }

  predicate test(a:Int,b:Int)
  {
    a+b>5
  }
  
  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    define body()
    {
      if(test(2,4))
      {
        "predicate"
      }
    }
   }