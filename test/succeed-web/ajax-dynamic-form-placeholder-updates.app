application test

  entity Tmp {
    i1:Int
    i2:Int
    s:String
  }

  page root(){
    var i1 := 1
    var i2 := 1
    var s := ""

    action ignore-validation update(){
      // ignore-validation action modifier is needed to prevent the input from losing focus on validation error, 
      // losing focus is caused by the whole form being rerendered as result of a validation failure (current default behavior)
      // validation actions in inputajax templates also use the ignore-validation modifier
      replace("ph1");
      
      // invoke rollback to complete action normally but not commit anything,
      // in order to avoid concurrent write action failures
      rollback();
    }

    dynamicform{
      inputajax(i1)[class="input1", oninput=update()]
      placeholder "ph1"{
        if(i1 > 2){ //cannot be placed before input(i1)
          inputajax(i2)[class="input2"]
          "placeholder rendered"
        }
      }
      submitlink action{ Tmp{ i1:= i1 i2:=i2 s := s }.save(); } [class="button"] {"save"}
      div{ 
        output("inside form: "+i1+i2) 
      }
    }
    div{ output("outside form: "+i1+i2) }
    div{
      "saved entities: "
      for(t:Tmp){
        output(t.i1)
        output(t.i2)
        output(t.s)
      }
    }
  }
  
  //TODO seems to be some issues still with tests not waiting for the ajax response, using sleep for workaround
  
  function placeholderShown(d:WebDriver){
    sleep(2000);
    log(d.getPageSource().contains("placeholder rendered"));
    assert(d.getPageSource().contains("placeholder rendered"));
  }
  function placeholderNotShown(d:WebDriver){
    sleep(2000);
    assert(!d.getPageSource().contains("placeholder rendered"));
  }
  function validationErrorShown(d:WebDriver){
    sleep(2000);
    assert(d.getPageSource().contains("Not a valid number"));
  }
  function validationErrorNotShown(d:WebDriver){
    sleep(2000);
    assert(!d.getPageSource().contains("Not a valid number"));
  }
  function stringShown(d:WebDriver, s:String){
    sleep(2000);
    assert(d.getPageSource().contains(s));
  }
  

  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    placeholderNotShown(d);
    var i1 : WebElement := d.findElement(SelectBy.className("input1"));
    i1.sendKeys("9");
    placeholderShown(d);
    i1.sendKeys("abc");
    placeholderNotShown(d);
    i1.clear();
    placeholderNotShown(d);
    i1.sendKeys("0");
    placeholderNotShown(d);
    i1.sendKeys("2");
    placeholderNotShown(d);
    i1.sendKeys("2");
    placeholderShown(d);
    
    // cause validation error in second input
    var i2 : WebElement := d.findElement(SelectBy.className("input2"));
    i2.sendKeys("9");
    placeholderShown(d);
    i2.sendKeys("abc");
    placeholderShown(d);
    validationErrorShown(d);
    i2.clear();
    placeholderShown(d);
    validationErrorShown(d);

    // update placeholder with a validation error inside it, error should remain visible
    i2.sendKeys("abc");  
    sleep(2000);          
    i1.sendKeys("8");
    placeholderShown(d);
    validationErrorShown(d);
           
    // change first input to remove second input and its error        
    i1.clear(); // note: this clear doesn't fire oninput event
    sleep(2000);
    i1.sendKeys("0");
    placeholderNotShown(d);
    validationErrorNotShown(d);
    
    //have error in second input and press save button
    i1.sendKeys("7777");
    placeholderShown(d);
    var i3 : WebElement := d.findElement(SelectBy.className("input2"));
    i3.sendKeys("abcd");    
    placeholderShown(d);
    validationErrorShown(d);
    var b : WebElement := d.findElement(SelectBy.className("button"));
    b.click();
    stringShown(d,"inside form: 7777null");
    stringShown(d,"outside form: 11");
    
    //fix error and complete submit
    i3 := d.findElement(SelectBy.className("input2"));
    i3.clear();
    i3.sendKeys("8888");
    b := d.findElement(SelectBy.className("button"));
    sleep(2000);
    b.click();
    stringShown(d,"saved entities: 77778888");  
  }
