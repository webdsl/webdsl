//is also defined as normal entity

application test

section datamodel

  entity User{
    name :: String
  }
  
  session user{
    name :: String
  }

  define main() 
  {
    body()
  }
  
  define body(){}
  
  define page home(){
    main()
    var u:User := User{};
    define body()
    {
      output(u.name)
    }
   }
