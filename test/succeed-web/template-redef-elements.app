application basic

  define page root(){
    foo("123"){ "BAR"}
  }
 
  define foo(s:String){
    elements()
    <hr/>
    bar("789"){
      elements()
    }
    define labelInternal(s:String) = labelInternal2
  }  
  define labelInternal2(s:String){  
    "redef" elements()
  }
  define labelInternal(s:String){
    "original" elements()
  }
  define bar(s:String){
    labelInternal("456"){ elements() }
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("redefBAR"));
  }
  