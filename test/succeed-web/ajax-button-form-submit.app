//test the form submit result, should invoke the first button, even if it's an ajax button

application test


  define page root(){
    var i := 1
    action red(){
      return success();
    }    
    form{
      input(i)
      submit("save",red())[class="pushbutton",ajax]
    }
  }
  
  define page success(){
    "redirected to success page"
  }
  
  native class Thread{
    static sleep(Int)
  }

  test one {
    
    var d : WebDriver := FirefoxDriver();
    
    d.get(navigate(root()));
    
    var button := d.findElement(SelectBy.className("pushbutton"));
    button.click();
    Thread.sleep(2000);
    
    assert(d.getPageSource().contains("redirected to success page"), "should have been redirected");
    
    d.close();
  }
  

  