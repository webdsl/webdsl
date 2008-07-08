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
    
    rule template templ(d:Int)
    {
      d>2
      rule action save(e:Int)
      {
        d=e
      }
    }
  
section somesection  
  
  define main() 
  {
    body()
  }
  
  define templ(a:Int)
  {
    var f: Int := 10;
    action("Confirm", save(f))
    action save(c:Int)
    {
      a=f;
    }
  }
  
  define page home(){
    main()

    define body()
    {
      for(b:Int in [1,2,3,4,5,6])
      {
        templ(b)
      }
    }
   }