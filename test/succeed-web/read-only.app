application test

read-only page root(){
  "number of entities: "
  output("" + (select count(*) from Ent))
  init{
    var e := Ent{};
    e.save();
    e.i := 1;
  }
  placeholder p{}
  testajax(p)
}

read-only ajax template testajax(p:Placeholder){
  submit action{ replace(p,testajax(p)); } [class="testbutton"] {"go"}
  init{
    var e := Ent{};
    e.save();
    e.i := 1;
  }
}
  
entity Ent{
  i : Int
}
  
test {
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));  
  d.get(navigate(root()));  
  d.findElement(SelectBy.className("testbutton")).click();
  d.findElement(SelectBy.className("testbutton")).click();
  d.get(navigate(root())); 
  
  assert(d.getPageSource().contains("number of entities: 0"));
}
  
 