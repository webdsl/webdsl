application test

//issue on yellowgrass: http://yellowgrass.org/issue/WebDSL/709

  define page root(){    
    var someString := "old";
    
    placeholder "MYPH" { showString( someString ) }
    inputTemplate( someString )
  }
  
  template inputTemplate( stringRef : Ref<String>){
    var i := ""
    form{  input(i)[onkeyup=update(), class="input1"] }    
    action update(){ stringRef := i; replace("MYPH"); }
  }
  
  template showString( str : String ){
    decorate { output(str) }
    "plain: " output(str)
  }
  
  ajax template decorate() {
    <h1> "decorated: " elements </h1>    
  }
    
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    sleep(2000);
    assert(d.getPageSource().contains("decorated: old"));
    var i1 : WebElement := d.findElement(SelectBy.className("input1"));
    i1.sendKeys("new");
    sleep(2000);
    assert(d.getPageSource().contains("decorated: new"));
  }