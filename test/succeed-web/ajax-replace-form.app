application test

  entity One {
    prop :: String(id)
  }

  entity Two {
    prop :: Int
  }

  define page root(){
    "root page"
    form{
      submit("ajaxsave2", 
        action{ var one := One{prop:="1111"+random()}; 
        one.save();
        var two:=Two{prop :=234234}; 
        two.save();
        replace(pl, atemp(one,two,"dsfdsssf",34345)); 
        }
      )[ajax]
        
    }
    
    placeholder pl {}
  }
  
  define ajax atemp(one : One, two: Two, foo:String, bar:Int){
    var s : String := foo
    var i : Int := bar
    "ajax template"
    form{
      input(one.prop)
      input(two.prop)
      input(s)
      input(i)
      submit("save",action{refresh();})[ajax]
    }
    
    includeJS("http://localhost/resource.js")
    includeCSS("http://localhost/resource.css")
    submit("refresh",action{refresh();})[ajax]
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
    d.getSubmit().click();
    
    assert(d.getPageSource().contains("ajax template"), "expected to see ajax template");
    
    //check for dynamically loaded resources
    assert(d.getPageSource().contains("localhost/resource.js"), "expected to see js resource injected");
    assert(d.getPageSource().contains("localhost/resource.css"), "expected to see css resource injected");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length==10, "incorrect number of input elements found");
    log(d.getPageSource());
    d.getSubmits()[1].click();
    
    assert(!(d.getPageSource().contains("ajax template")), "expected ajax template to be removed here");
    
    //now click button outside form
    d.getSubmit().click();
    
    assert(d.getPageSource().contains("ajax template"), "expected to see ajax template");
    var elist1 : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist1.length == 10, "incorrect number of input elements found");
    log(d.getPageSource());
    d.getSubmits()[2].click();
    assert(!(d.getPageSource().contains("ajax template")), "expected ajax template to be removed here");
  }
   