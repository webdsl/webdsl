application test

  template one(s:String){
    output(s)"456"
  }

  override template one(s:String){
    output(s)"123"
  }

  ajaxtemplate two(s:String){
    output(s)"incorrect"
  }

  override ajaxtemplate two(s:String){
    output(s)"1112"
  }

  page root(){
    one("0")
    two("10")
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("0123101112"));
  }
