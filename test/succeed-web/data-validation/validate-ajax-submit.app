application registerexample

  entity User {
    password :: Secret
  }

  define main(){
    elements
  }

  define page root() {
    main {
      submit action{replace(reg,reg());} [ajax] { "replace form with ajax" }
      header { "Form:" }
      placeholder reg{ reg() }
    }
  }

  define ajax reg(){
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
    var d : WebDriver := FirefoxDriver();
    
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 4, "expected 4 <input> elements");
    
    elist[0].click();
    
    var pagesource := d.getPageSource();
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 4, "expected 4 <input> elements");
    elist[2].clear();elist[2].sendKeys("1");
    elist[3].click();
 
    assert(d.getPageSource().contains("You have successfully entered '1'"), "expected message missing");
    
    d.close();
  }