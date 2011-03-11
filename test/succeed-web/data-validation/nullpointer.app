application registerexample

  entity User {
    s -> StringContainer
    validate(s.s.length() > 3,"data model validation error")
  }
  
  entity StringContainer{
    s :: String
  }

  var testUser := User{ s := StringContainer{s:="12345"}  }
  
  define page root() {
    //form validate
    form{
      input(testUser.s)[class="input1"]
      validate(testUser.s.s.length() > 2,"form validation error")
      submit action{  }[class="button1"]{"save1"}
    }
    //data invariant
    form{
      input(testUser.s)[class="input2"]
      submit action{  }[class="button2"] {"save2"}
    }
    //data invariant after action
    form{
      input(testUser.s)
      submit action{ testUser.s := null; } [class="button3"]{"save3"}
    }
    //action validate
    form{
      input(testUser.s)
      submit action{ var tmp := testUser; tmp := null; validate(tmp.s.s.length() > 4,"action validation error"); } [class="button4"]{"save4"}
    }
  }
  
  define page extra(){
    var l : Set<StringContainer> := null //could cause nullpointer when doing a contains check with 'in'
    form{
      input(testUser.s)[class="input1"]
      validate(testUser.s in l,"extra form validation error")
      submit action{  }[class="button1"]{"save1"}
    }
  }
  
  test validatenotnullchecks {
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    var i1 := Select(d.findElement(SelectBy.className("input1")));
    var b1 := d.findElement(SelectBy.className("button1"));
    i1.selectByIndex(0);
    b1.click();
    assert(d.getPageSource().contains("form validation error"));
    assert(d.getPageSource().contains("data model validation error"));

    d.get(navigate(root()));
    var i2 := Select(d.findElement(SelectBy.className("input2")));
    var b2 := d.findElement(SelectBy.className("button2"));
    i2.selectByIndex(0);
    b2.click();
    assert(d.getPageSource().contains("data model validation error"));

    d.get(navigate(root()));
    var b3 := d.findElement(SelectBy.className("button3"));
    b3.click();
    assert(d.getPageSource().contains("data model validation error"));

    d.get(navigate(root()));
    var b4 := d.findElement(SelectBy.className("button4"));
    b4.click();
    assert(d.getPageSource().contains("action validation error"));
    
    
    d.get(navigate(extra()));
    var b1 := d.findElement(SelectBy.className("button1"));
    b1.click();
    assert(d.getPageSource().contains("extra form validation error"));
    d.close();
  }