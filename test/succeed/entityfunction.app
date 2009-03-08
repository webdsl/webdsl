application test

section datamodel

  define body() {
    "default body"
  }
  
  entity User{
    name :: String
    function test(a:Int, b:Int, u:User) : Bool
    {
      u.name == this.name;
      return a<b;
    }
    function test2(a:Int, b:Int, u:User) : Bool
    {
      this.test(a,b,u);
      return test(a,b,u);
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
      if(u.test2(4,8,u)){
        output(u.name)
      }
    }
   }
