application test

section datamodel

  entity User{
    name :: String
    function test(a:Int, b:Int, u:User) : Bool
    {
      u.name = this.name;
      return a<b;
    }
  }

  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    var u:User := User{name := "testuser"};
    define body()
    {
      if(u.test(4,8,u)){
        output(u.name)
      }
    }
   }
