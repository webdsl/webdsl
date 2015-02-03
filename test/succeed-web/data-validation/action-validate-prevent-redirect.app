application registerexample

  entity User {
    i :: Int (validate(i>0,"should be > 0"))
  }
  
  var u := User{i := 1}
  
  define page root() {
    form{
      submit action{ u.i := 0; return red(); } [class="btn2"] {"savebutton"}
      submit action{ u.i := 0; return red(); } [ajax, class="btn4"] {"savebutton"}
      submitlink action{ u.i := 0; return red(); } [class="btn1"] {"savebutton"}
      submitlink action{ u.i := 0; return red(); } [ajax, class="btn3"] {"savebutton"}  
    }
  }
  
  define page red(){
    "should not be redirected"
  }

  test datavalidation {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    log("total submit actions: "+d.getSubmits().length);

    log("click 1");
    d.getSubmits()[0].click();
    checkStillOnRootPage(d);

    log("click 2");
    d.getSubmits()[1].click();
    checkStillOnRootPage(d);

    log("click 3");
    d.getSubmits()[2].click();
    checkStillOnRootPage(d);

    log("click 4");
    d.getSubmits()[3].click();
    checkStillOnRootPage(d);
  }
  
  
  function checkStillOnRootPage(d:WebDriver){
    var pagesource := d.getPageSource();
    assert(!pagesource.contains("should not be redirected"), "should be on root page still");
    assert(pagesource.contains("savebutton"), "should be on root page still");
    assert(pagesource.contains("should be &gt; 0"), "should show validation error");
  }
