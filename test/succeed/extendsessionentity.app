application test

section datamodel

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
  
  define page home(){
    main()
   
    define body()
    {
      output(user.name)
      output(user.lastname)
    }
   }