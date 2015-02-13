application test

  entity Two {
    prop :: Int
  }

  define page root(){
    "root page"
    form{
      submit("ajaxsave2", 
        action{ 
        var two:=Two{prop := 1}; 
        two.save();
        replace(pl, atemp(two)); 
        }
      )[ajax]
    }
    placeholder pl {}
  }
  
  define ajax atemp(two: Two){
    "ajax template"
    form{
      input(two.prop)
      submit("save",action{refresh();})[ajax]
    }
    submit("refresh",action{refresh();})[ajax]
  }
  
  test encodingstest {
    var d : WebDriver := getFirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 1, "expected <input> elements did not match");
    d.getSubmit().click();
    
    var elist1 : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist1.length == 4, "expected <input> elements did not match");
    elist1[3].sendKeys("45gdg"); // should cause validation error, since this field is for Int
    d.getSubmits()[1].click();
    assert(d.getPageSource().contains("Not a valid number"));
  }
   