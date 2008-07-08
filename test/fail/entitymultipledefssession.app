//Error: Session Entity user of type User is defined multiple times.


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