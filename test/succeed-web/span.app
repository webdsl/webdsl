application test

  define page root(){
    template1("temp1")
    template2("temp2")
  }
  
  define template1(a:String){
    output(a)
  }
  define span template2(a:String){output(a)}
  
  //nested define with span mod
  define page foo() {
    template2("bar")
    define span template2(a:String){output(a)}
  }
  
  test {
    var d : WebDriver := getHtmlUnitDriver();
    //log(navigate(root()));
    d.get(navigate(root()));
    //log(d.getPageSource());
    assert(d.getPageSource().contains("<span id=\"template2String\" class=\"scopediv template2String template2\">"));
    assert(!d.getPageSource().contains("<span id=\"template1String\""));
    d.get(navigate(foo()));
    assert(d.getPageSource().contains("<span id=\"template2String\" class=\"scopediv template2String template2\">"));
  }
  
