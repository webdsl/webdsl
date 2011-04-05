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
  
  native class Thread {
    static sleep(Int)
  }
  
  test one {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 9, "expected <input> elements did not match");
    elist[1].sendKeys("test");
    elist[2].sendKeys("test");
    elist[3].click();    
    assert(d.getPageSource().contains("You are now logged in."));
    
    var elist1 : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist1.length == 2, "expected <a> elements did not match");
    elist1[0].click();
    
    Thread.sleep(2000);
    
    var elist2 : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist2.length == 9, "expected <input> elements did not match");
    elist2[5].sendKeys("test");
    elist2[6].sendKeys("test");
    elist2[7].click();    
    assert(d.getPageSource().contains("You are now logged in."));

    var elist3 : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist3.length == 2, "expected <a> elements did not match");
    elist3[1].click();
    
    Thread.sleep(2000);
    
    var elist4 : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist4.length == 9, "expected <input> elements did not match");
    
    d.close();
  }
  

  