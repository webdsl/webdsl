application test

  define page root(){
    rawoutput{ output(c1) }
    submit action {init();}{ "save" }    
  }
  
  define no-span output(u:User){
    <span class="user-output">
      <b>output(u.name)</b>
      <i>output(u.address)</i>
    </span>
  }
  
  entity User{
    name :: String
    address :: String
  }
  
  var u1 := User{name:="user" address:="address"}
  var c1 := CachedUserOutput{}
  
  function init(){
    c1.name := c1.name + rendertemplate(output(u1));   
  }
  
  entity CachedUserOutput{
    name :: String
  }
  
  invoke init() every 1 minutes
  
  /*
  test buttonclick {
    
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    
    assert(!(d.getPageSource().contains("404")), "redirect may not produce a 404 error");
    log(d.getPageSource());
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 1, "expected <input> elements did not match");
    elist[0].click();
    
    assert(d.getPageSource().contains("<span class=\"user-output\"><b>user</b><i>address</i></span><span class=\"user-output\"><b>user</b><i>address</i></span>")
           , "output of cached template not found");

    d.close();
  }
  */