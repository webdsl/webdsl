application test

  define page root() {
    div{
      navigate(test()){ "test-mimetype" }
    }
    div{
      navigate(testraw()){ "test-rawoutput" }
    }
    div{
      navigate(testfun()){ "test-mimetype-fun" }
    }
  }
  
  define page test(){
    var s : String := "&'\"<>"
    mimetype("text/plain")
    "1 && 2 <> 3"
    output(s)
  }
  
  define page testraw(){
    var s : String := "&'\"<>"
    rawoutput(s)
    rawoutput{
      "&'\"<>" 
      output(s)
    }
    output(s)
  }

  define page testfun(){
    var s : String := "&'\"<>"
    init{
      mimetype("text/plain");
    }
    "1 && 2 <> 3"
    output(s)
  }

  service bla(){
    mimetype("text/plain");
    var s : String := "&'\"<>";
    return "1 && 2 <> 3" + s;
  }

  service bla2(){
    var s : String := "&'\"<>";
    return "1 && 2 <> 3" + s;
  }

  test {
    var d : WebDriver := getHtmlUnitDriver(); // firefox driver seems to always produce escaped output
    d.get(navigate(test()));
    //log(d.getPageSource());
    assert(d.getPageSource().contains("1 && 2 <> 3&'\"<>"));

    d.get(navigate(testfun()));
    assert(d.getPageSource().contains("1 && 2 <> 3&'\"<>"));

    d.get(navigate(bla()));
    assert(d.getPageSource().contains("1 && 2 <> 3&'\"<>"));

    d.get(navigate(bla2()));
    assert(d.getPageSource().contains("1 && 2 <> 3&'\"<>"));

    d.get(navigate(testraw()));
    //log(d.getPageSource());
    //assert(d.getPageSource().contains("&'\"<>&'\"<>&'\"<>&amp;'&quot;&lt;&gt;"));    
    // not shown correctly in webdriver output: 
    // http://selenium.googlecode.com/svn/trunk/docs/api/java/org/openqa/selenium/WebDriver.html#getPageSource()
    // The page source returned is a representation of the underlying DOM: do not expect it to be formatted or escaped 
    // in the same way as the response sent from the web server.
  }
