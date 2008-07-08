// Extend session/entity redefines property: name :: Int

application test

section datamodel

  entity User{
    name :: String
  }
  
  extend entity User{
    name :: Int
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