application test

section datamodel

  define body() {
    "default body"
  }

  entity User{
    name :: String
  }
  
  extend entity User{
    lastname :: String
  }

  define main() 
  {
    body()
  }
  
  define page root(){
    main()
    var u:User := User{};
    define body()
    {
      output(u.name)
      output(u.lastname)
    }
   }
