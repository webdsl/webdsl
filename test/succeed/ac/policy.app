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
    rule page home()
    {
      true
    }
    rule template main(first:Int)
    {
      true
    }
    
  access control rules denied
    rule page home()
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
  
  define page home(){
    main(6)
    define body()
    {
      "test"
    }
   }