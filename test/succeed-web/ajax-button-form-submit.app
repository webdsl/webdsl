//test the form submit result, should invoke the first button, even if it's an ajax button

application test


  define page root(){
    var i := 1
    action red(){
      return success();
    }    
    form{
      input(i)
      submit("save",red())[ajax]
    }
  }
  
  define page success(){
    "redirected to success page"
  }

  test one {
    
    var d : WebDriver := FirefoxDriver();
    
    d.get(navigate(root()));
    
    var elist := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 3, "expected <input> elements did not match");
    elist[1].submit();
    
    assert(d.getPageSource().contains("redirected to success page"), "should have been redirected");
    
    d.close();
  }
  

  