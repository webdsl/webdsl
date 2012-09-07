application registerexample

  entity User {
    i :: Int (validate(i>0,"should be > 0"))
  }
  
  var u := User{i := 1}
  
  define page root() {
    form{
      submitlink action{ u.i := 0; return red(); } [class="btn1"] {"savebutton"}
      submit action{ u.i := 0; return red(); } [class="btn2"] {"savebutton"}
      submitlink action{ u.i := 0; return red(); } [ajax, class="btn3"] {"savebutton"}  
      submit action{ u.i := 0; return red(); } [ajax, class="btn4"] {"savebutton"}  
    }
  }
  
  define page red(){
    "should not be redirected"
  }

  test datavalidation {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var btn1 := d.findElement(SelectBy.className("btn1"));
    btn1.click();
    checkStillOnRootPage(d);

    var btn2 := d.findElement(SelectBy.className("btn2"));
    btn2.click();
    checkStillOnRootPage(d);

    var btn3 := d.findElement(SelectBy.className("btn3"));
    btn3.click();
    checkStillOnRootPage(d);

    var btn4 := d.findElement(SelectBy.className("btn4"));
    btn4.click();
    checkStillOnRootPage(d);
  }
  
  
  function checkStillOnRootPage(d:WebDriver){
    var pagesource := d.getPageSource();
    assert(!pagesource.contains("should not be redirected"), "should be on root page still");
    assert(pagesource.contains("savebutton"), "should be on root page still");
  }
