application test

  define page root(){  
    authentication()
    output(securityContext.principal)
    for(r : RequestLogEntry){
      table{
        derive viewRows from r
      }
    }
    navigate bla("1234567") { "go" }
  }
  
  define page bla(s:String){
    output(s)
    navigate root() { "go" }
  }
  
  entity User {
    name :: String
    password :: Secret
  }

  init{
    var u := User{ name := "1" password := ("1" as Secret).digest()  };
    u.save();
  }

  principal is User with credentials name, password
  
  define page user(u:User){
      table{
        derive viewRows from u
      }
  }

  access control rules

    rule page *(*){true}
    rule template *(*){true}
 
 
 section tests
 
   test one {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    assert(d.getPageSource().contains("Firefox"), "firefox user agent not shown");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 4, "expected <input> elements did not match");
    elist[1].sendKeys("1");
    elist[2].sendKeys("1");
    elist[3].click();  
    assert(d.getPageSource().contains("Principal: "), "principal not shown in request log");
    
    
    d.close(); 
  }
  

