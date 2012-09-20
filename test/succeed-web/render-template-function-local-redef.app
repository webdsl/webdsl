application test

  define page root(){
    wikilayout
  }
  
  define mainResponsive() {    
    includeHead(rendertemplate(rssLink()))
    elements()
  }

  define rssLink() { } // default definition

  template wikilayout() {
     define rssLink() { // local override
       "this should be visible as well"
       output(navigate(feed("wiki12345")))
       <link rel="alternate" type="application/rss+xml" title="RSS" href=navigate(feed("wiki56789")) ></link>
     }
     mainResponsive { "test page content" }
  }
  
  define page feed(s:String){
    output(s)
  }
    
  test {
    
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    assert(d.getPageSource().contains("test page content"));
    assert(d.getPageSource().contains("this should be visible as well"));
    assert(d.getPageSource().contains("feed/wiki12345"));
    assert(d.getPageSource().contains("wiki56789"));
    
  }
