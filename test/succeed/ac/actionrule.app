application test

section principal

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule action save()
    {
      true
    }
  
section somesection  
  
  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    define body()
    {
      action save()
      {
        1=1;
      }
    }
   }