application test

section principal

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule page home()
    {
      true
    }
    rule template main(first:Int)
    {
      true
      rule action test(second:Int)
      {
        first=second
      }
    }
  
section somesection  
  
  define main(a:Int) 
  {
    body()
    action test(a:Int)
    {
      a=6;
    }
  }
  
  define page home(){
    main(6)
    define body()
    {
      "test"
    }
   }