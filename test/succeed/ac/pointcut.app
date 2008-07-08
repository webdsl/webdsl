application test

section pc

  entity User{
    name :: String
  }
 
  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    define body()
    {

    }
   }
   
  access control rules
    pointcut test(a:Int)
    {
      page home(a),
      template ts(),
      action someaction(*)
    
    }
    
    rule pointcut test(b:Int)
    {
      b>4
    }