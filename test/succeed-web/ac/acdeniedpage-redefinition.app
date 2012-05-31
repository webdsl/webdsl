application test

section principal
  
  entity User{
    name :: String
  }

  principal is User with credentials name
  
  access control rules
    rule page root()
    {
      false
    }
  
section somesection  

   define page root(){
     "should not be able to see this"
   }
   
   define override page accessDenied(){
     "custom access denied page"
   }   
   
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(!d.getPageSource().contains("should not be able to see this"));
    assert(d.getPageSource().contains("custom access denied page"));
  }