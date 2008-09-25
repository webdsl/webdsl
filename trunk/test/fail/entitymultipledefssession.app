//Error: Session entities User are also defined as normal entities.


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
  
  define page home(){
    main()
    var u:User := User{};
    define body()
    {
      output(u.name)
    }
   }
