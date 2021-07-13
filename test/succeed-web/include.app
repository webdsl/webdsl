application test
    
  function js1():String{return "sdmenu.js";}
  function js2():String{return "http://ajax.googleapis.com/ajax/libs/jquery/1.2.6/jquery.min.js";}
  function css1():String{return "dropdownmenu.css";}
  function css2():String{return "http://webdsl.org/stylesheets/some.css";}
  function css3():String{return "screen";}
  function css4():String{return "http://webdsl.org/stylesheets/blabla.css";}
  function favicon():String{return "http://webdsl.org/html/othericon.ico";}
  function head1():String{return "<!--[if IE 6]><link rel=\"stylesheet\" href=/stylesheets/msie6.css\" type=\"text/css\" /><![endif]-->";}
  function https():String{return "https://localhost/stylesheets/common_.css";}
  function httpsjs():String{return "https://localhost/javascript/ajax.js";}
  function viewport():String{ return "<meta name=\"viewport\" " + viewportcontent() + ">"; }
  function viewportcontent():String{ return "content=\"width=device-width, user-scalable=no\""; }

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
  
  define page overriddenHeadTags(){
    includeHead("viewport", viewport())
    includeHead("defaultcss", css4())
    includeHead("favicon", favicon())
  }

  test head {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    var pagecontent := d.getPageSource();
    assert(pagecontent.contains(js1()), "element missing: "+js1());
    assert(pagecontent.contains("\""+js2()), "element missing: "+js2());
    assert(pagecontent.contains(css1()), "element missing: "+css1());
    assert(pagecontent.contains("\""+css2()), "element missing: "+css2());
    assert(pagecontent.contains("\""+css3()), "element missing: "+css3());
    assert(pagecontent.contains(head1()), "element missing: "+head1());
    assert(pagecontent.contains("\""+https()), "element missing: "+https());
    assert(pagecontent.contains("\""+httpsjs()), "element missing: "+httpsjs());
    
    assert(pagecontent.contains("\"viewport\""), "default element missing: viewport meta tag");
    assert(pagecontent.contains("favicon.ico"), "default element missing: favicon.ico");
    assert(pagecontent.contains("common_.css"), "default element missing: common_.css");
    assert(pagecontent.contains("\"Content-Type\""), "default element missing: Content-Type meta tag");
    
  }
  
  test overrideDefault{
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(overriddenHeadTags()));
    var pagecontent := d.getPageSource();
    assert(pagecontent.contains(viewportcontent()), "overridden element missing: " + viewport());
    assert(pagecontent.contains(favicon()), "overridden element missing: " + favicon());
    assert(pagecontent.contains(css4()), "overridden element missing: " + css4());
    assert(! pagecontent.contains("common_.css"), "default element `common_.css` still included, while it should only include overridden");
  }
  