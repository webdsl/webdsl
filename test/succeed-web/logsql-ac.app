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
  
  test {
    var d : WebDriver := getFirefoxDriver();

    d.get(navigate(root())+"?logsql");
    assert(d.getPageSource().contains("Access to SQL logs was denied."));
    
    var button : WebElement := d.findElement(SelectBy.className("button"));
    button.click();
    
    d.get(navigate(root())+"?logsql");
    assert(d.getPageSource().contains("The three queries that took the most time:"));
  }
  
  principal is User with credentials name
  
  access control rules
  
    rule page root(){true}
    rule logsql { loggedIn }