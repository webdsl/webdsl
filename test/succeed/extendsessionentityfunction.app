application test

section datamodel

  session user{
    name :: String
  }
  
  extend session user{
    function test(a:Int, b:Int, u:User) : Int
    {
      u.name := this.name;
      return a+b;
    }
  }

  define main() 
  {
    body()
  }
  
  define page home(){
    main()

    define body()
    {
      if(user.test(4,8,user)){
        output(user.name)
      }
    }
   }