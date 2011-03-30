application test

  entity User{
    name :: String
  }

  var u1 := User{}

  define page root(){
  }
  
  test buttonclick {
    
    var d : WebDriver := FirefoxDriver();
    
    d.get(navigate(root())+"?logsql");
    assert(d.getPageSource().contains("The three queries that took the most time:"));
    
    d.close();
  }
