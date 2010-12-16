application test

  define page root(){
    template1("temp1")
    template2("temp2")
  }
  
  define template1(a:String){output(a)}
  define span template2(a:String){output(a)}
  
  test one {
    
    var d : WebDriver := HtmlUnitDriver();
    log(navigate(root()));
    d.get(navigate(root()));
    log(d.getPageSource());
    assert(d.getPageSource().contains("<span id=\"template2String\" class=\"scopediv template2String template2\">"));
    assert(!d.getPageSource().contains("<span id=\"template1String\""));
    d.close();
  }
  
