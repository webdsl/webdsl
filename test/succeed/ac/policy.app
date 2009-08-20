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
    rule template main(first:Int)
    {
      true
    }
    
  access control rules denied
    rule page root()
    {
      false
    }
    rule template main(first:Int)
    {
      false
    }
  
  access control policy anonymous OR denied
  
section somesection  
  
  define main(a:Int) 
  {
    body()
    
  }
  
  define page root(){
    main(6)
    define body()
    {
      "test"
    }
   }
