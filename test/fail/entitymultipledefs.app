//Error: Entity User is defined multiple times.


application test

section datamodel

  entity User{
    name :: String
  }
  
  entity User{
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