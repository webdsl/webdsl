//does not exist

application test

section datamodel

  session user{
    name :: String
  }
  
  extend session userr{
    lastname :: String
  }

  define main() 
  {
    body()
  }
  
  define page root(){
    main()
    
    define body()
    {
      output(user.name)
      output(user.lastname)
    }
   }
