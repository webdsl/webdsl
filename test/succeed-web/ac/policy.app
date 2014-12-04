application test

section principal

  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule page cannotGoHere(*) { pred() } 
    rule page root() { true }
    
  
    predicate pred(){
      true
    }
    
  access control rules extraRules
  
    rule page cannotGoHere(*) { pred2() }
    
    // need to repeat these because of the AND combination with default group
    rule page root() { true }
    rule page accessDenied() { true }
    
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
    var d : WebDriver := getHtmlUnitDriver();
    
    d.get(navigate(root()));
    // No navigate button
    assert(!d.getPageSource().contains("Cannot see this link"), "Navigate should be hidden.");
    
    // Go to denied page
    d.get(navigate(cannotGoHere()));
    assert(d.getPageSource().contains("Access Denied"), "Access should be denied.");
  }