// Error: Extended entity Userr does not exist:

application test

section datamodel

  entity User{
    name :: String
  }
  
  extend entity Userr{
    lastname :: String
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
      output(u.lastname)
    }
   }