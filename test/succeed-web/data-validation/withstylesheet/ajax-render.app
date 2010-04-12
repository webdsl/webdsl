application registerexample

entity Competition{
}
function createCompetition():Competition{ validate(false, "error"); return Competition{}; }

define applicationmenu() {
  <div id="navbar">
  <ul>
    <li>form{ actionLink("Randomize", randomCompetition()) }</li>
  </ul>
  </div>
  action randomCompetition() {
    var c: Competition := createCompetition();
    return root();
  }
}

define page root(){
  applicationmenu()
}

  test datavalidation {
    var d : WebDriver := FirefoxDriver();
    
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist.length == 1, "expected 1 <a> element");
    
    elist[0].click();
    
    var b : List<WebElement> := d.findElements(SelectBy.tagName("body"));
    assert(b.length == 1, "<body> element gone");
        
    d.close();
  }