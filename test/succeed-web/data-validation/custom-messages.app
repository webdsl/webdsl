application messages

  entity User{
    name :: String
  }
  var u : User := User{ name := "bob" };
  var u1 : User := User{ name := "alice" };
  
  define page root(){
    for(u:User) {
      output(u.name)
    }
    
    navigate(somepage()){"link"}
    
    form {
      input(u.name)
      action("save",save())
    }
    action save() {
      u.save();
      message("1:username="+u.name);
      message("2:username="+u.name);

      return somepage();
    }
  }
  
  define page somepage(){
    "somepagefragment"  
    
    messages()
  }
  
  define ignore-access-control templateSuccess(messages : List<String>){
    
    for(ve: String in messages){
      output(ve)   
    } separated-by {", "}
  }

  
  test messages {
    var d : WebDriver := HtmlUnitDriver();
    
    d.get(navigate(root()));
    assert(!/404/.find(d.getPageSource()), "root page may not produce a 404 error");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected 3 <input> element");
    
    elist.get(1).sendKeys("blabla");
    
    elist.get(2).click();
    
    //check that messages are produced below "somepage fragment"  
    
    var pagesource := d.getPageSource();
    
    var list := /somepagefragment/.split(pagesource);
    
    assert(list.length == 2, "expected one occurence of \"somepagefragment\"");
    
    assert(!/1:username=blabla/.find(list.get(1)), "cannot find first message");
    assert(!/2:username=blabla/.find(list.get(1)), "cannot find second message");
    
  }
  