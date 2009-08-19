application test

section principal

  define body() {
    "default body"
  }
  
  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule page root()
    {
      true
    }
    rule page root(*)
    {
      1==1
    }
    rules page root()
    {
      2==2
    }
    rules page root(*)
    {
      3==3
    }
    rule template main(){true}
  
section somesection  
  
  define main() 
  {
    body()
  }
  
  define page root(){
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
    rule page root()
    {
      4==4
    }
    rule page root(*)
    {
      5==5
    }
    rules page root()
    {
      6==6
    }
    rules page root(*)
    {
      7==7
    }
  
  