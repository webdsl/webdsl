application test

section datamodel

  define body() {
    "default body"
  }

  session user{
    name :: String
  }
  
  extend session user{
    lastname :: String
  }

  define main() 
  {
    body()
  }
  
  define page root(){
    main()
    init{
      user.name := "Bob";
      user.lastname := "J";
    }
    
    define body()
    {
      output(user.name)
      output(user.lastname)
    }
  }
