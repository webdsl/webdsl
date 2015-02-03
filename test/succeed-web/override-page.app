application test

  override page root(){
    "123456789"
    submit action{ replace("ph",two("10")); } { "test ajax template" }
    placeholder "ph" { }
  }

  page root(){
    "default root"
  }

  ajaxtemplate two(s:String){
    output(s)"incorrect"
  }

  override ajaxtemplate two(s:String){
    output(s)"1112"
    submit action{ replace("ph",two("10")); } { "test ajax template" }
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("123456789"));
    d.getSubmit().click();
    assert(d.getPageSource().contains("101112"));
    d.getSubmits()[1].click();
    assert(d.getPageSource().contains("101112"));
  }
