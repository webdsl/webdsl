//is defined multiple times


application test

section datamodel

  entity User{
    name :: String
  }
  
  entity User{
    password :: Secret
  }

  define main() 
  {
    body()
  }

  define body(){}
  
  define page root(){
    main()
    var u:User := User{};
    define body()
    {
      output(u.name)
    }
   }
