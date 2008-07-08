application test

section principal

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule page home(first:Int)
    {
      true
      rule action test(second:Int)
      {
        first=second
      }
    }
  
section somesection  
  
  define main() 
  {
    body()
  }
  
  define page home(a:Int){
    main()
    define body()
    {
      action test(a:Int)
      {
        a=6;
      }
    }
   }