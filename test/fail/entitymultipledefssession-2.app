//Entity 'User' is defined multiple times

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
  
  define page root(){
    main()
    var u:User := User{};
    define body()
    {
      output(u.name)
    }
   }
