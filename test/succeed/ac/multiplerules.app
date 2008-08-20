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
    rule page home(*)
    {
      1=1
    }
    rules page home()
    {
      2=2
    }
    rules page home(*)
    {
      3=3
    }
    rule template main(){true}
  
section somesection  
  
  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    define body()
    {
      "test succeeded"
      if(loggedIn())
      {
        output(securityContext.principal.name)
      }
    }
   }
   
   
   
  access control rules
    rule page home()
    {
      4=4
    }
    rule page home(*)
    {
      5=5
    }
    rules page home()
    {
      6=6
    }
    rules page home(*)
    {
      7=7
    }
  
  