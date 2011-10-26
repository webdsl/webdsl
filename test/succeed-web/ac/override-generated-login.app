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
  
  define override login(){
    "1234"
  }
  define override logout(){
    "5678"
  }
  define override authentication(){
    "91011"
  }
  
  define page root(){
    login()
    logout()
    authentication()
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("1234567891011"));
  }
  

  