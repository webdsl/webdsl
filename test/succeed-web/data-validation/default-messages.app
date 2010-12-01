application messages

  entity User{
    name :: String
  }
  var u : User := User{ name := "bob" };
  var u1 : User := User{ name := "alice" };
  
  define page root(){
    form {
      input(u.name)
      action("save",save())
    }
    action save() {
      u.save();
      message("1: username: "+u.name);
      message("2: username: "+u.name);
      return somepage();
    }
  }
  
  define page somepage(){
    "somepagefragment"  
  }
  
  test messages {
    var d : WebDriver := HtmlUnitDriver();
    
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected 3 <input> element");
    
    elist[1].sendKeys("blabla");
    
    elist[2].click();
    
    //check that messages are produced above "somepage fragment"  
    
    var pagesource := d.getPageSource();

    var list := /somepagefragment/.split(pagesource);
    
    assert(list.length == 2, "expected one occurence of \"somepagefragment\"");
    
    assert(list[0].contains("1: username: bobblabla"), "cannot find first message");
    assert(list[0].contains("2: username: bobblabla"), "cannot find second message");
    
    d.close();
  }
  