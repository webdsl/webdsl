application test

define page root(){
  
  navigate issue(5){"go"}
  
  for(i:Issue){
    output(""+i.open+i.num)
  }
}
entity Issue{
  open :: Bool
  num:: Int
}
define page issue( issueNumber : Int) {
  body()
  define body(){
    var i := Issue{open := true}
    
    output(issueNumber)
    form{
      submit close(i){"Save"}
    }
    action close(issue : Issue){
      issue.num := issueNumber;
      issue.save();
      return root();
    }
  }
}
define body(){"default body"}
entity User {
  name :: String
  password :: Secret
}

principal is User with credentials name, password

access control rules
  rule page root(){
    true
  }
  
  rule page issue(issueNumber : Int) { 
    issueNumber > 0
    rule action close(issue : Issue) {
      issueNumber > 0 && issue.open
    }
  }
  
section bla  
  test ac {
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    assert(elist.length == 1, "expected 1 <a> elements did not match");
    elist[0].click();
    
    var elist2 : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist2.length == 3, "expected 3 <input> elements did not match");
    elist2[2].click();
      
    d.get(navigate(root()));
    assert(d.getPageSource().contains("true5"), "entered data not found");
    
    d.close();
  }
  