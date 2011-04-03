application test

  entity User{
    name :: String
  }

  var u1 := User{}

  define page root(){
    form{
      submit root()[class="button"]{"login"}
    }
    action root(){
      securityContext.principal  := u1;
      return root();
    }
  }
  
  test buttonclick {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root())+"?logsql");
    assert(d.getPageSource().contains("Access to SQL logs was denied."));
    
    var button : WebElement := d.findElement(SelectBy.className("button"));
    button.click();
    
    d.get(navigate(root())+"?logsql");
    assert(d.getPageSource().contains("The three queries that took the most time:"));
    
    d.close();
  }
  
  principal is User with credentials name
  
  access control rules
  
    rule page root(){true}
    rule logsql { loggedIn }