// http://yellowgrass.org/issue/WebDSL/630
application test

  page root(){
   	question() 
  }

  template question(){
    gridSpan(){
      gridSpan(){  } // ends in stackoverflow, caused by the nested gridSpan incorrectly retrieving the elements of the enclosing gridSpan
    }
    "12345"
  }
  
  template gridSpan(){elements}
  
  test{
    var d := getHtmlUnitDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("12345"));
  }
  