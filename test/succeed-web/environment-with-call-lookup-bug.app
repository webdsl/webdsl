application test

  page root(){
    var i := "test1234"
    testtemplate{
      output(i)
    }
  }
  
  template testtemplate(){
    placeholder addProjectPH atemplate() // this broke the env, body/elements arg of testtemplate was no longer accessible
    elements
  }
  
  ajax template atemplate(){
    form{
      submit action{} {"go"}
    }
    // make sure access to global and session vars does not break because the bug is related to environments
    output(globalfoo.name)
    output(sessionbar.name)
  }
 
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("test1234"));
    assert(d.getPageSource().contains("globalfoo123"),"ajax template did not have access to global variable");
    assert(d.getPageSource().contains("test1234"),"ajax template did not have access to session variable");
  }
  
  entity Foo{
    name : String
  }
  var globalfoo := Foo{name := "globalfoo123"}
  session sessionbar{
    name : String (default="sessionbar456")
  }