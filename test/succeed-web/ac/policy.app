application test

section principal

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule page cannotGoHere(*) { pred() }
  
    predicate pred(){
      true
    }
    
  access control rules extraRules
  
    rule page cannotGoHere(*) { pred2() }
    
    predicate pred2() {
      "x" == "y"			
    }
    
  access control policy anonymous AND extraRules
    
section somesection  
  
  define page cannotGoHere() {
    
  }
  
  define page root(){
    navigate(cannotGoHere()) { "Cannot see this link" }  
  }
  
  test messages {
    var d : WebDriver := HtmlUnitDriver();
    
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("404"), "root page may not produce a 404 error");
    // No navigate button
    assert(!d.getPageSource().contains("Cannot see this link"), "Navigate should be hidden.");
    
    // Go to denied page
    d.get(navigate(cannotGoHere()));
    assert(d.getPageSource().contains("Access Denied"), "Access should be denied.");
    
    d.close();
  }