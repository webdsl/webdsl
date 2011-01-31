application test

  entity Bar {
    foo :: String (id)
  }

  var glob := Bar { foo := "test" }

  define page root(){
    "root page"
    form{
      input(glob.foo)
      submit("save", action{ return view(glob); })
      submit("ajaxsave", action{ return view(glob); })[ajax]
      submit("ajaxsave2", action{ replace(pl,viewA(glob)); })[ajax]
    }
    
    placeholder pl {}
    
    navigate view(glob) {"view"}
    
  }
  
  define page view(g:Bar){
    "view page"
    output(g.foo)
    form{
    
      input(glob.foo)
      submit("save", action{ return view(glob); })
      submit("ajaxsave", action{ return view(glob); })[ajax]
      submit("ajaxsave2", action{ replace(pl2,viewA(glob)); })[ajax]
      
    }
    
    placeholder pl2 {}
  }
  
  define ajax viewA(g:Bar){
    "viewA ajax template"
    navigate view(g) { output(g.foo) }
    form{
    
      input(glob.foo)
      submit("save", action{ return view(glob); })
      submit("ajaxsave", action{ return view(glob); })[ajax]
      submit("ajaxsave2", action{ replace(pl,viewA(glob)); })[ajax]
    }
    block[onclick:=action{refresh();}]{
      "clickme"
    }
  }
  
  native class Thread{
    static sleep(Int)
  }
  
  test encodingstest {
    var d : WebDriver := FirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(!(d.getPageSource().contains("404")), "root page may not produce a 404 error");
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length==5, "incorrect number of input elements found");
    
    var entered1 := "+ /\\'?^:\u1234\u4352\u0044\u00F6"; //TODO webdsl should parse these \u as unicode escape
    
    elist[1].sendKeys(entered1);
    elist[2].click();
    Thread.sleep(2000);
    
    assert(d.getPageSource().contains("view page"), "expected to be on view page");
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length==6, "incorrect number of input elements found");
    
    assert(elist[2].getValue() == "test"+entered1, "input not correctly displayed after submit");   
    
    //root second submit button 
    d.get(navigate(root()));
    assert(!(d.getPageSource().contains("404")), "root page may not produce a 404 error");
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length==5, "incorrect number of input elements found");
    
    var entered2 := "\u0055";
    
    elist[1].sendKeys(entered2);
    elist[3].click();
    Thread.sleep(2000);
    
    assert(d.getPageSource().contains("view page"), "expected to be on view page");
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length==6, "incorrect number of input elements found");
    
    assert(elist[2].getValue() == "test"+entered1+entered2, "input not correctly displayed after submit");   
    
    
    //root third submit button
    d.get(navigate(root()));
    assert(!(d.getPageSource().contains("404")), "root page may not produce a 404 error");
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length==5, "incorrect number of input elements found");
    
    var entered3 := "+ + \\//";
    
    elist[1].sendKeys(entered3);
    log(elist[1].getValue());
    elist[4].click();
    Thread.sleep(2000);
    
    assert(d.getPageSource().contains("viewA ajax template"), "expected to see ajax template viewA");
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length==11, "incorrect number of input elements found");
    
    assert(elist[6].getValue() == "test"+entered1+entered2+entered3, "input not correctly displayed after submit");   
    //log(d.getPageSource());
    
    d.close();
  }
   