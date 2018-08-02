//test the form submit result, should invoke the first button, even if it's an ajax button

application test

  page root(){
    var i := 1
    action red(){
      return success();
    }    
    form{
      input(i)
      submit("save",red())[class="pushbutton",ajax]
    }
  }
  
  page success(){
    "redirected to success page"
  }
  
  test{
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    var button := d.findElement(SelectBy.className("pushbutton"));
    button.click();
    assert(d.getPageSource().contains("redirected to success page"), "should have been redirected");
  }


  request var rv := "initial"
  page moretests(){
    init{ rv := "Request var set 1"; }
    placeholder p testajax()
  }
  
  ajax template testajax(){
    init{ rv := rv + "2"; }
    placeholder p showit("",p)
  }
  
  ajax template showit(s: String, p: Placeholder){
    init{ rv := rv + "3"; }
    output(s)
    placeholder ph noise()
    div{
	  submit clear(){ "Update 1" } 
    }
    div{
	  submit update(){ "Update 2" } 
    }
    placeholder "test" noise()
    action clear(){}
    action update(){
      replace(p, showit("first test",p));
      replace("test", showit("second test",p));
    }
    
    output(rv)
  }
  
  ajax template noise(){
    <div>"should not be rendered during non-render phase"</div>
  }
  
  test{
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(moretests()));
    assert(d.getPageSource().contains("Request var set 123"));
    d.getSubmits()[1].click();
    assert(d.getPageSource().contains("first test"));
    assert(d.getPageSource().contains("second test"));
    
    d.getSubmits()[0].click();
    assert(!d.getPageSource().contains("first test"));
    assert(!d.getPageSource().contains("second test"));
  }
  