application registerexample

  entity User {
    password :: Secret
  }

  define main(){
    elements
  }

  define page root() {
    main {
   
      var u : User := User{};
      var p : Secret;

      header { "Register" }
      form {
        label("Password:") { input(u.password) }
        label("Verify password:") { 
          input(p){validate(p==u.password,"passwords don't match inputcheck")}
          <hr/> 
        }
        <hr/>
        validate(p==u.password,"passwords don't match formcheck")
        action("Register", register())

        action register() {
          validate(p==u.password,"passwords don't match action");
          u.password := u.password.digest();
          u.save();
          message("You have successfully registered. Sign in now.");
        }
      }
    }
  }

  test datavalidation {
    var d : WebDriver := HtmlUnitDriver();
    
    d.get(navigate(root()));
    assert(!/404/.find(d.getPageSource()), "root page may not produce a 404 error");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 4, "expected 4 <input> elements");
    
    elist.get(1).sendKeys("123");
    elist.get(2).sendKeys("111");
    
    elist.get(3).click();
    
    var pagesource := d.getPageSource();
    
    var list := /<hr\/>/.split(pagesource);
    
    assert(list.length == 3, "expected two occurences of \"<hr/>\"");
    for(i:Int from 0 to 3){
      log(i+"    "+list.get(i));
    }
 
    assert(/inputcheck/.find(list.get(1)), "cannot find inputcheck message");
    assert(/formcheck/.find(list.get(2)), "cannot find formcheck message");
    
  }