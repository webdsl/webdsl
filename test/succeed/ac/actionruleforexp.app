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
    
    rule template main(){ true }
    
    rule template templ(d:Int)
    {
      d>2
      rule action save(e:Int)
      {
        d==e
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
    output(a)
    action("Confirm", save(f))
    action save(c:Int)
    {
      a==f;
    }
  }
  
  define page root(){
    main()

    define body()
    {
      for(b:Int in [1,2,3,4,5,6,7,8,9,10,11,12])
      {
        templ(b)
      }
      
      templ(10)
    }
   }