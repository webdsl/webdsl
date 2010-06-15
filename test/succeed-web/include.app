application test
    
  function js1():String{return "sdmenu.js";}
  function js2():String{return "http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js";}
  function css1():String{return "dropdownmenu.css";}
  function css2():String{return "http://webdsl.org/stylesheets/common_.css";}
  function css3():String{return "screen";}
  function head1():String{return "<!--[if IE 6]><link rel=\"stylesheet\" href=/stylesheets/msie6.css\" type=\"text/css\" /><![endif]-->";}
  function https():String{return "https://localhost/stylesheets/common_.css";}
  function httpsjs():String{return "https://localhost/javascript/ajax.js";}

  define page root() {
    
    includeJS(js1()) 
    includeJS(js2())
  
    includeCSS(css1())
    includeCSS(css2())
    includeCSS(css2())
    includeCSS(css2(),css3())
      
    includeHead(head1())
    
    includeCSS(https(),"screen")
    includeJS(httpsjs())
    
  }

  test head {
    var d : WebDriver := FirefoxDriver();
    
    d.get(navigate(root()));
    var pagecontent := d.getPageSource();
    d.close(); 
     
    assert(pagecontent.contains(js1()), "element missing: "+js1());
    assert(pagecontent.contains("\""+js2()), "element missing: "+js2());
    assert(pagecontent.contains(css1()), "element missing: "+css1());
    assert(pagecontent.contains("\""+css2()), "element missing: "+css2());
    assert(pagecontent.contains("\""+css3()), "element missing: "+css3());
    assert(pagecontent.contains(head1()), "element missing: "+head1());
    assert(pagecontent.contains("\""+https()), "element missing: "+https());
    assert(pagecontent.contains("\""+httpsjs()), "element missing: "+httpsjs());

  }