application test

section pc

  define body() {
    "default body"
  }
  
  entity User{
    name :: String
  }
 
  define main() 
  {
    body()
  }
  
  
  define page root(){
    main()
    define body()
    {
      "testpage"
      
      for(i:Int in [3,4,5,6])
      {
        navigate(testpage(i)){"testpage"}
      }
    }
   }
   
  define page testpage(c:Int)
  {
    "testpage" output(c)
  }
   
  access control rules
    principal is User with credentials name
    
    pointcut test(a:Int)
    {
      page testpage(a)
    }
    
    rule pointcut test(b:Int)
    {
      b>4
    }
    
    pointcut test2()
    {
      page root(),
      template main(),
      template body(),
      action someaction(*)
    }
    
    rule pointcut test2()
    {
      true
    }
    