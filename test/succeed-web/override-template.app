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
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("0123"));
  }
  