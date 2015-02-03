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
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 11, "expected <input> elements did not match");
    elist[1].sendKeys("test");
    elist[2].sendKeys("test");
    d.getSubmits()[0].click(); // first login submit
    assert(d.getPageSource().contains("You are now logged in."));
    
    var elist1 : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist1.length == 2, "expected <a> elements did not match");
    d.getSubmits()[0].click(); // first logout submitlink  
    
    var elist2 : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist2.length == 11, "expected <input> elements did not match");
    elist2[6].sendKeys("test");
    elist2[7].sendKeys("test");
    d.getSubmits()[1].click(); // second login submit
    assert(d.getPageSource().contains("You are now logged in."));

    var elist3 : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist3.length == 2, "expected <a> elements did not match");
    d.getSubmits()[2].click(); // second logout submitlink
    
    var elist4 : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist4.length == 11, "expected <input> elements did not match");
  }
  

  