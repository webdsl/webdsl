application test

  entity Nav{
    name::String 
  }

  define page root(){
    var n : Nav := null
    navigate nav(n) { "show" }
    "rootpageisvisible"
  }
  
  define page nav(n:Nav){
    "viewpage"
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("rootpageisvisible"));
  }
  