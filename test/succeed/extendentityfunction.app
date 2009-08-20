application test

section datamodel

  define body() {
    "default body"
  }

  entity User{
    name :: String

    function extendMe() {
      name := name + "one";
    }
  }
  
  extend entity User{
    function test(a:Int, b:Int, u:User) : Int
    {
      u.name == this.name;
      return a+b;
    }
    extend function extendMe() {
      name := name + "two";
    }
  }

  define main() 
  {
    body()
  }
  
  
  define page root(){
    main()
   
    var u:User := User{name := "Alice"};
  
    init{ 
      u.extendMe();
    }
    
    define body()
    {
      if(u.test(4,8,u)>0){
        output(u.name)
      }
      
    }
   }

   
   
  extend entity User{

    extend function extendMe() {
      name := name + "three";
    }
  }
