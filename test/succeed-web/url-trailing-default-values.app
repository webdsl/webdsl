application trailingdefaultvalues

page root(){
  navigate search("","12345") { "test" }
}
  
page search(s1:String,s2:String){
  output(s1)
  "-searchpage-"
  output(s2)
}

test {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
  var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
  assert(elist.length == 1, "expected number of <a> elements did not match");
  elist[0].click();  
  assert(d.getPageSource().contains("-searchpage-12345"));
}
  