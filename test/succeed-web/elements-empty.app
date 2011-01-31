//empty elements caused runtime nullpointer exception in rev4370

application test

  define page root(){
    testtemplate{
      "foobar"
    }
    testtemplate{}
  }
  
  define testtemplate(){
    <h1>
      elements()
    </h1>
  }

  test one {
    var d : WebDriver := HtmlUnitDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("foobar"));
    d.close();
  }
  

  