application test

section datamodel

  principal is User with credentials name

  entity User{
    name :: String
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
      navigate("editpage",editUser(u))
    }
   }
   
  define page editUser(u : User) {
    derive editPage from u
  }
  
  
  access control rules
    rule page editUser(us: User)
    {
      us != null
    }