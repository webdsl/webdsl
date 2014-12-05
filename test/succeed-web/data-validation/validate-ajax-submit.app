application registerexample

  entity User {
    password : Secret
  }

  template main(){
    elements
  }

  page root() {
    main {
      submit action{replace(reg,reg());} [ajax] { "replace form with ajax" }
      header { "Form:" }
      placeholder reg{ reg() }
    }
  }

  ajax template reg(){
      var i :Int
        action register() {
          validate(i==1,"validate in action");
          message("You have successfully entered '1'.");
        }
      form {
        label("enter '1':") { 
          input(i){validate(i==1,"passwords don't match inputcheck")}
        }
        validate(i==1, "passwords don't match formcheck")
        action("Register", register())
      }
  }

  test datavalidation {
    var d : WebDriver := getFirefoxDriver();
    
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 4, "expected 4 <input> elements");
    
    elist[0].click();
    
    var pagesource := d.getPageSource();
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 4, "expected 4 <input> elements");
    
    elist[3].click();
    assert(d.getPageSource().contains("passwords don't match inputcheck"), "expected message missing: passwords don't match inputcheck");
    assert(d.getPageSource().contains("passwords don't match formcheck"), "expected message missing: passwords don't match formcheck");
    
    
    var elist2 := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 4, "expected 4 <input> elements");
        
    elist2[2].clear();
    elist2[2].sendKeys("1");
    elist2[3].click();
 
    assert(d.getPageSource().contains("You have successfully entered '1'"), "expected message missing");
  }