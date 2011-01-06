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
    submit("refresh",action{refresh();})[ajax]
  }
  
  test encodingstest {
    var d : WebDriver := FirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(!(d.getPageSource().contains("404")), "root page may not produce a 404 error");
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length==2, "incorrect number of input elements found");
    
    elist[1].click();
    
    assert(d.getPageSource().contains("ajax template"), "expected to see ajax template");
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length==13, "incorrect number of input elements found");
    log(d.getPageSource());
    elist[11].click();
    
    assert(!(d.getPageSource().contains("ajax template")), "expected ajax template to be removed here");
    
    //now click button outside form
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length==2, "incorrect number of input elements found");
    elist[1].click();
    assert(d.getPageSource().contains("ajax template"), "expected to see ajax template");
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length==13, "incorrect number of input elements found");
    log(d.getPageSource());
    elist[12].click();
    assert(!(d.getPageSource().contains("ajax template")), "expected ajax template to be removed here");
    
    d.close();
  }
   