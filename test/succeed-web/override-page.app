application test

  define override page root(){
    "123456789"
  }

  define page root(){
    "default root"
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("123456789"));
  }
  