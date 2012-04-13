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
    var s2 :String := ""
    var u := User { name := "bob" }
    form {
      validate(s == u.name,"Entered values differ.")
      label("Username") { input(u.name) }
      label("Repeat Username") { input(s) }
      label("Repeat Username") { input(s1) {validate(s1 == u.name,"Not the same name.")} }
      "Repeat Username" input(s2) {validate(s1 == u.name,"Not the same name either.")}
      action("save",save())
    }
    action save(){
      u.save();
      return success();
    }
  }
  
  define page success(){
    title { "successfully performed edit" }
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 6, "expected 6 <input> elements");
    //first is a hidden, second to fourth are the input fields, last is submit
    
    elist[5].click();
    
    assert("editing user" == d.getTitle());
    
    assert(d.getPageSource().contains("Entered values differ"), "first validation message was not produced");
    assert(d.getPageSource().contains("Not the same name"), "second validation message was not produced");
    assert(d.getPageSource().contains("Not the same name either"), "third validation message was not produced");
    
    //now do it correctly
    
    elist := d.findElements(SelectBy.tagName("input"));
    var nameinfirstfield := elist[1].getValue();
    assert(nameinfirstfield == "bob");
    
    elist[2].sendKeys(nameinfirstfield);
    elist[3].sendKeys(nameinfirstfield);
    elist[4].sendKeys(nameinfirstfield);
    
    elist[5].click();
    
    assert("successfully performed edit" == d.getTitle());
  }
  