application test

  entity User{
    file : File
  }
  
  var u1 := User{}
  
  page root(){
    form{
      input(u1.file)
      submit action{ validate(false, "fail"); }{
        "save"
      }
    } 
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("enctype=\"multipart/form-data\""));
    d.getSubmit().click();
    // form with upload should always have the enctype setting, also on validation error render
    assert(d.getPageSource().contains("enctype=\"multipart/form-data\""));
  }