application formcheckseparate

  entity User {
    name :: String
  }
  
  define page root() {
    title { "editing user" }
   
    for(us:User){
      output(us.name)
    }
    
    var s :String := ""
    var s1 :String := ""
    var u := User { name := "bob" }
    form {
      validate(s == u.name,"Entered values differ.")
      formgroup("User"){   
        label("Username") { input(u.name) }
        label("Repeat Username") { input(s) }
        label("Repeat Username") { input(s1) {validate(s1 == u.name,"Not the same name.")} }
        action("save",save())
      }
    }
    action save(){
      u.save();
      return success();
    }
  }
  
  define page success(){
    title { "successfully performed edit" }
  }

  test one {
    var d : WebDriver := HtmlUnitDriver();
    
    d.get(navigate(root()));
    assert(!/404/.find(d.getPageSource()), "root page may not produce a 404 error");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 5, "expected 5 <input> elements");
    //first is a hidden, second to fourth are the input fields, last is submit
    
    elist.get(4).click();
    
    assert("editing user" == d.getTitle());
    
    assert(!/Entered values differ/.find(d.getPageSource()), "first validation message was not produced");
    
    assert(!/Not the same name/.find(d.getPageSource()), "second validation message was not produced");
    
    //now do it correctly
    
    elist := d.findElements(SelectBy.tagName("input"));
    var nameinfirstfield := elist.get(1).getValue();
    assert(nameinfirstfield == "bob");
    
    elist.get(2).sendKeys(nameinfirstfield);
    elist.get(3).sendKeys(nameinfirstfield);
    
    elist.get(4).click();
    
    assert("successfully performed edit" == d.getTitle());
    
  }
  