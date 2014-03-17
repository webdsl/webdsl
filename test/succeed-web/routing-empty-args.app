application customroutingissue

// regression bug related to custom routing feature changes
// was caused by usage of Arrays.asList which returns a fixed-size list,
// at runtime this results in UnsupportedOperationException when trying to invoke remove 

page root(){
  navigate search( "","" ) { "All projects" }
}
  
page search(s1:String,s2:String){
  "-searchpage-"
}

test {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
  assert(elist.length == 1, "expected number of <a> elements did not match");
  elist[0].click();  
  assert(d.getPageSource().contains("-searchpage-"));
}
  