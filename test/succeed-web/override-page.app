application test

  define override page root(){
    "123456789"
  }

  define page root(){
    "default root"
  }
  
  test buttonclick {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    
    log(d.getPageSource());
    assert(d.getPageSource().contains("123456789"));

    d.close();
  }
  