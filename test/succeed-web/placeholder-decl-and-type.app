application test

  page root(){
    var i1 := 1
  
    action update1(){ replace(ph1); }
    action update2(ph:Placeholder){ replaceSomething(ph); }

    form{
      inputajax(i1)[class="input1", oninput=update1()]
      placeholder ph1{
        if(i1 > 2){ 
          "ph-test1"
        }
      }

      submitlink update2(ph2) [class="input2"]{"test2"}      
      placeholder ph2{
      	 if(i1 > 2){ 
          "ph-test2"
        }
      }
    }
    <br/>
    <br/>
    var ints := [IntBox{i:=1},IntBox{i:=2},IntBox{i:=3}]
    form{
      for(i:IntBox in ints){
        "test"
        output(i.i)
        inputajax(i.i)[class="input3", oninput=update3(ph3)]
        placeholder ph3{
          if(i.i > 10){ 
            "ph-test3 for " output(i.i)
          }
        }
	  }
    }
    action update3(p:Placeholder){
      replace(p);
    }
    
  }
  
  entity IntBox{
  	i:Int
  }
  
  function replaceSomething(pl:Placeholder){
    replace(pl);
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    placeholderNotShown(d,"ph-test1");
    placeholderNotShown(d,"ph-test2");
    placeholderNotShown(d,"ph-test3");
    
    var i1 : WebElement := d.findElement(SelectBy.className("input1"));
    i1.sendKeys("9");
    placeholderShown(d,"ph-test1");
    
    var i2 : WebElement := d.findElement(SelectBy.className("input2"));
    i2.click();
    placeholderShown(d,"ph-test2");
    
    i1.clear();
    i1.sendKeys("0");
    placeholderNotShown(d,"ph-test1");
    
    placeholderShown(d,"ph-test2");
    i2.click();
    placeholderNotShown(d,"ph-test2");
    
    var i3s := d.findElements(SelectBy.className("input3"));
    assert(i3s.length == 3);
    
    i3s[0].sendKeys("42");
    placeholderShown(d,"ph-test3 for 1");  
    placeholderNotShown(d,"ph-test3 for 2");  
    placeholderNotShown(d,"ph-test3 for 3");
    
    i3s[2].sendKeys("34");
    placeholderShown(d,"ph-test3 for 1");  
    placeholderNotShown(d,"ph-test3 for 2");  
    placeholderShown(d,"ph-test3 for 3");
    
    i3s[0].clear();
    i3s[0].sendKeys("0");
    placeholderNotShown(d,"ph-test3 for 1");  
    placeholderNotShown(d,"ph-test3 for 2");  
    placeholderShown(d,"ph-test3 for 3");

  }
  
  function placeholderShown(d:WebDriver, check:String){
    sleep(2000);
    assert(d.getPageSource().contains(check));
  }
  
  function placeholderNotShown(d:WebDriver, check:String){
    sleep(2000);
    assert(!d.getPageSource().contains(check));
  }
