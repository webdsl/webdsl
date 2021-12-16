application test

//issue on yellowgrass: http://yellowgrass.org/issue/WebDSL/709
//Dec 2021: updated test for related issue: https://yellowgrass.org/issue/WebDSL/926 

  define page root(){    
    var someString := "old";
    
    placeholder "MYPH" {
      showString( someString )
      showVar()
    }
    inputTemplate( someString )
  }
  
  entity Dummy{
    text : String
  }
  
  var x := Dummy{ text := "empty" }
  
  template inputTemplate( stringRef : Ref<String>){
    var i := ""
    form{
      input(i)[onkeyup=update(), class="input1"]
      input(x.text)[class="input2"]
    }    
    action update(){ stringRef := i; replace("MYPH"); }
  }
  
  template showString( str : String ){
    decorate[class=if(str == "new") "new" else "old"] { output(str) }
    "plain: " output(str)
    
    //check for control flow caching
    if( str == "old"){
    	"found-old"
    }
  }
  template showVar(){
    var y := x
    
    "value:" ~y.text
    
    //check for control flow caching
    if( y.text == "non-empty"){
    	"found-non-empty"
    }
  }
  
  template decorate() {
    <h1 all attributes> "decorated: " elements </h1>    
  }
    
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    sleep(2000);
    assert(d.getPageSource().contains("decorated: old"));
    assert(d.getPageSource().contains("h1 class=\"old"));
    assert(d.getPageSource().contains("value:empty"));
    assert(d.getPageSource().contains("found-old"));
    assert(!d.getPageSource().contains("found-non-empty"));
    var i1 := d.findElement(SelectBy.className("input1"));
    var i2 := d.findElement(SelectBy.className("input2"));
    i2.clear();
    i2.sendKeys("non-empty");
    i1.sendKeys("new"); //triggers update() = save
    sleep(2000);
    assert(d.getPageSource().contains("decorated: old"));
    assert(d.getPageSource().contains("h1 class=\"old"));
    assert(d.getPageSource().contains("value:non-empty"));
    assert(d.getPageSource().contains("found-old"));
    assert(d.getPageSource().contains("found-non-empty"));
    log(d.getPageSource());
  }