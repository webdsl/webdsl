//conflict with generated logout template

application test
  
  entity User{
    name :: String
  }

  principal is User with credentials name

  access control rules
    rule page logout(){true}

section somesection  

  define page root(){
    navigate logout() {}
  }

  define override page logout(){
    "custom logout page"
  }
  
  test one {
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(logout()));
    assert(d.getPageSource().contains("custom logout page"));
    d.close();
  }
  
