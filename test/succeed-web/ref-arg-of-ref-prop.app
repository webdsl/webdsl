application test

  entity Str{
    name::String 
  }
  
  define page root(){
    var a := Str{ name := "1" }
    form{
      foo(a)
      submit action{ a.save(); } [class="testbutton1"] {"save"}
    }
    for(s:Str){  output(s) }
  }
  
  define foo(s: Ref<Str>){
    bar(s.name)
  }
  
  define bar(s:Ref<String>){
    input(s)[class="testinput1"]
  }
  
  
  test propertyofrefarg {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    
    var input := d.findElement(SelectBy.className("testinput1"));
    input.sendKeys("234567");
    var button := d.findElement(SelectBy.className("testbutton1"));
    button.click();  

    assert(d.getPageSource().contains("1234567"));
    
    d.close();
  }
  
