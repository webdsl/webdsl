application exampleapp
  
  define page root(){
    for(i:Int from 0 to 9){
      local var x := i
      output(x) " "
    }
  }
  
test {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  var pagesource := d.getPageSource();
  
  for(i:Int from 0 to 9){
    assert(pagesource.contains(""+i), "local variable is not rerendered with newly assigned values");
  }
}