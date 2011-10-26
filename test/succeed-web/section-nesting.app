application test


  define page root(){
    a()  
  }
  
  define a() { section{ header{"A"} b() } }
  define b() { section{ header{"B"} } }
  
  test {
    var d : WebDriver := getHtmlUnitDriver();
    d.get(navigate(root()));
    
    var actual := d.findElements(SelectBy.tagName("h1")).length; 
    assert(actual == 1, "Must have 1 h1 header, but has " + actual);
    assert(d.findElement(SelectBy.tagName("h1")).getText() == "A");
   
    actual := d.findElements(SelectBy.tagName("h2")).length; 
    assert(actual == 1, "Must have 1 h2 header, but has " + actual);
    assert(d.findElement(SelectBy.tagName("h2")).getText() == "B");
  }
  

  