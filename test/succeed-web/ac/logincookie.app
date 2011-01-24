//http://yellowgrass.org/issue/WebDSL/299
//cookies should set path explicitly, otherwise you get
//a cookie that is only valid for a subset of pages
application login

  entity User{
    name :: String
  }
  
  var u1 := User{name:="test"}
  
  principal is User with credentials name

  define page root(){
    authentication()
    navigate deep("123","456"){ "deep link" }
  }
  
  define page deep(s1:String,s2:String){
    authentication()
    navigate root(){ "root link" }
  }
  
  access control rules
    
    rule page *(*){ true }
    rule template *(*){ true }
    
section testing

  test login{
    var d : WebDriver := FirefoxDriver();
    //first navigate to deep link
    d.get(navigate(deep("123","456")));
    //login there
    var input := d.findElements(SelectBy.className("inputString"))[0];
    input.sendKeys("test");
    var button := d.findElements(SelectBy.className("button"))[0];
    button.click();
    //check whether root page sees login
    assert(d.getPageSource().contains("Logged in as: test"));
    d.close();    
  }