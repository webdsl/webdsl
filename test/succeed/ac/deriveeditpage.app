application test

section datamodel

  define body() {
    "default body"
  }
  
  principal is User with credentials name

  entity User{
    name :: String
  }

  define main() 
  {
    "main"
    body()
  }

  define page home(){
    "home"
    main()
    var u:User := User{};
    define body()
    {
      "body"
      navigate(editUser(u)){"editpage"}
    }
   }
   
  define page editUser(u : User) {
    "edit page"
    derive editPage from u
  }
  
  
  access control rules
    rule page editUser(us: User)
    {
      us != null
    }
    rule page home(){true}
    rule template main(){true}
