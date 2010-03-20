application test

  entity Config {
    js1 :: String	
    js2 :: String	
    css1 :: String	
    css2 :: String	
    css3 :: String	
    head1 :: String	
  }
  
  var c := Config{
    js1 := "sdmenu.js"
    js2 := "http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js"
    css1 := "dropdownmenu.css"
    css2 := "http://webdsl.org/stylesheets/common_.css"
    css3 := "screen"
    head1 := "<!--[if IE 6]><link rel=\"stylesheet\" href=/stylesheets/msie6.css\" type=\"text/css\" /><![endif]-->"
  }

  define page root() {
    
    includeJS(c.js1) 
    includeJS(c.js2)
  
    includeCSS(c.css1)
    includeCSS(c.css2)
    includeCSS(c.css2)
    includeCSS(c.css2,c.css3)
      
    includeHead(c.head1)
  }

  test head {
    var d : WebDriver := FirefoxDriver();
    
    d.get(navigate(root()));
    
    assert(d.getPageSource().contains(c.js1), "element missing: "+c.js1);
    assert(d.getPageSource().contains(c.js2), "element missing: "+c.js2);
    assert(d.getPageSource().contains(c.css1), "element missing: "+c.css1);
    assert(d.getPageSource().contains(c.css2), "element missing: "+c.css2);
    assert(d.getPageSource().contains(c.css3), "element missing: "+c.css3);
    assert(d.getPageSource().contains(c.head1), "element missing: "+c.head1);

    d.close();
  }