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
          input(i){validate(i==1,"values don't match inputcheck")}
        }
        validate(i==1, "values don't match formcheck")
        action("Register", register())
      }
  }

  test datavalidation {
    var d : WebDriver := getFirefoxDriver();
    
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 2, "expected 2 <input> elements");
    
    d.getSubmits()[0].click();
    
    var pagesource := d.getPageSource();
    
    var elist1 : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist1.length == 2, "expected 2 <input> elements");
    
    d.getSubmits()[1].click();
    assert(d.getPageSource().contains("values don't match inputcheck"), "expected message missing: values don't match inputcheck");
    assert(d.getPageSource().contains("values don't match formcheck"), "expected message missing: values don't match formcheck");
    
    
    var elist2 := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 2, "expected 2 <input> elements");
        
    elist2[1].clear();
    elist2[1].sendKeys("1");
    d.getSubmits()[1].click();
 
    assert(d.getPageSource().contains("You have successfully entered '1'"), "expected message missing");
  }