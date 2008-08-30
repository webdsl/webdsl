application test

section datamodel

  entity User{
    name :: String

    function extendMe() {
      var s : String := "";
    }
  }
  
  extend entity User{
    function test(a:Int, b:Int, u:User) : Int
    {
      u.name = this.name;
      return a+b;
    }
    extend function extendMe() {
      var a : String := "";
    }
  }

  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    var u:User := User{};
    define body()
    {
      if(u.test(4,8,u)>0){
        output(u.name)
      }
    }
   }
