application test

section principal

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule template bla()
    {
      1=1
    }
    rule page home()
    {
      true
    }
  
section somesection  
  
  define main() 
  {
    body()
  }
  
  define bla()
  {
    "tester"
  }
  
  define page home(){
    main()
    define body()
    {
    
      bla()
      action save()
      {
        1=1;
      }
    }
   }