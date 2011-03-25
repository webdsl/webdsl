application test

  define one(s:String){
    output(s)"456"
  }

  define override one(s:String){
    output(s)"123"
  }

  define page root(){
    one("0")
  }
  
  test buttonclick {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    
    log(d.getPageSource());
    assert(d.getPageSource().contains("0123"));

    d.close();
  }
  