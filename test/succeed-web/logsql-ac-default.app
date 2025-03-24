application test

  entity User{
    name :: String
  }

  var u1 := User{}

  define page root(){
    form{
      submit root()[class="button", style="margin-top: 100px;"]{"login"}
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
    assert(d.getPageSource().contains("Access to SQL logs was denied."));
  }
  
  principal is User with credentials name
  
  access control rules
  
    rule page root(){true}
