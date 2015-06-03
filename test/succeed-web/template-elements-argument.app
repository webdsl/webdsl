application test

page root(){
  var title := "123"
  var abc := Abc{}
  threeColumns(
    "title1",
    { "123" box(title){ icon{  "456"  } } },
    "title2",
    { form{ input(abc.i)[class="testinput"] submit action{ abc.save(); } {"save"} } box("789"){ icon{ "101112" } } },
    {}
  )
  box("")
  icon
  body
  for(a:Abc){
    output(a.i)
  }
}

entity Abc{
  i:Int
}

template threeColumns(
  t1:String,
  tmpl1 : TemplateElements,
  t2:String,
  tmpl2 : TemplateElements,
  testempty : TemplateElements
){
  output(t1)
  tmpl1
  output(t2)
  tmpl2
  testempty
}

template icon(){ <div class="123" all attributes> elements </div> }
template body(){ elements }
template box(s:String){ output(s) elements }

test{
  var d : WebDriver := getFirefoxDriver();
  d.get(navigate(root()));	
  
  checkCommon(d);
  
  var input := d.findElement(SelectBy.className("testinput")); 
  input.sendKeys("999");
  d.getSubmit().click();
  
  checkCommon(d);
  assert(d.getPageSource().contains("999"));
}

function checkCommon(d:WebDriver){
  assert(d.getPageSource().contains("title1"));
  assert(d.getPageSource().contains("title2"));
  assert(d.getPageSource().contains("123"));
  assert(d.getPageSource().contains("456"));  
  assert(d.getPageSource().contains("789"));  
  assert(d.getPageSource().contains("101112"));  
}