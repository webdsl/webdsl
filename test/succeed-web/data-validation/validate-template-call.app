//http://yellowgrass.org/issue/WebDSL/575
application test

  entity Blub{ prop::String }

  define sometemplate(){
    var b : Blub := null
    validate(b.prop.length() > 0,"error message")
    submit action{} [class="btn"] { "do it" }
  }

  define page root(){
    sometemplate()
  }
  
  test{
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    var btn := d.findElement(SelectBy.className("btn"));
    btn.click();
    var pagesource := d.getPageSource();
    assert(pagesource.contains("error message"), "error should show");
  }