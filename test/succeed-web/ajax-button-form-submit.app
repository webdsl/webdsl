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

  page moretests(){
    placeholder p testajax()
  }
  
  ajax template testajax(){
    placeholder p showit("",p)
  }
  
  ajax template showit(s: String, p: Placeholder){
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
  }
  
  ajax template noise(){
    <div>"should not be rendered during non-render phase"</div>
  }
  
  test{
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(moretests()));
    d.getSubmits()[1].click();
    assert(d.getPageSource().contains("first test"));
    assert(d.getPageSource().contains("second test"));
    
    d.getSubmits()[0].click();
    assert(!d.getPageSource().contains("first test"));
    assert(!d.getPageSource().contains("second test"));
  }
  