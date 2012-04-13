application test

  define page root(){
    var s := "12345"
    test(){ output(s) }
  }
  
  define test(){
    var str := rendertemplate(elements())
    output(str)
    "---"
    output(bla.s)
    //submit action{ bla.s := rendertemplate(elements()); } [class="testbtn"] {"click"}   //TODO
    //submit action{ bla.s := rendertemplate(test3(str)); } [class="testbtn"] {"click"} // TODO
    submit action{ bla.s := rendertemplate(test4()); } [class="testbtn"] {"click"}
    /*
    submit action{ bla.s := rendertemplate(test2()); } [class="testbtn"] {"click"} //TODO
    define test2(){
      output(tmp)
    }
    */
  }
  
  //define test2(){}
  
  //define test3(s:String){ output(s) }
  
  define test4(){ output("12345") }
  
  session bla {
    s :: String
  }

  test buttonclick {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    assert(d.getPageSource().contains("12345"));
    
    var btn := d.findElement(SelectBy.className("testbtn"));
    btn.click();
    assert(d.getPageSource().split("12345").length==3);
  }

