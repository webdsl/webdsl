application test

page root(){
  for(i:One){
    output("123test")
  }
  for(i:One){
    submit action{ i.delete(); }{ "delete" }
  }
}

entity One{}

init{
  One{}.save();
}

test{
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));
    
  d.getSubmit().click();
  
  assert(!d.getPageSource().contains("123test"));
}
