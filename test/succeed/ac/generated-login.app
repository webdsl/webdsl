application test

  entity User{
    username :: String
    password :: Secret
    info :: Text
  }
  
  init {
    var u := User{ username := "test" password := "test" };
    u.password := u.password.digest();
    u.save();
  }

  principal is User with credentials username, password
  
  access control rules
    rule page root()
    {
      true
    }
    
  section pages
  
  define page root(){
    
    "authentication() template: "
    break
    
    authentication()
    
    break
    "login() template: "
    break
    
    login()
    
    break
    "logout() template: "
    break
    
    logout()
  }