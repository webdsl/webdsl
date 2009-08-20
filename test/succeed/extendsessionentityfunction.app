application test

section datamodel

  define body() {
    "default body"
  }
  
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
  
  define page root(){
    main()

    define body()
    {
      if(user.test(4,8,user) == 12){
        output(user.name)
      }
    }
   }
