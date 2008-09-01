//Error: Extended session entity Userr does not exist

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
  
  define page home(){
    main()
    
    define body()
    {
      output(user.name)
      output(user.lastname)
    }
   }
