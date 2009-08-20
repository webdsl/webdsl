application test

section datamodel

  entity User{
    name :: String
  }
  
  define body() {
    "default body"
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
    }
  }
