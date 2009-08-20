//is defined multiple times


application test

section datamodel

  entity SuperUser{
    name :: String
  }
  
  entity User{
    name :: String
  }
  
  entity User : SuperUser{
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
