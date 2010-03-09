application test

  entity Nav{
    name::String 
  }

  define page root(){
    var n : Nav := null
    navigate nav(n) { "show" }
  }
  
  define page nav(n:Nav){
    "viewpage"
  }
  
  test buttonclick {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));

    assert(!(d.getPageSource().contains("404")), "navigate with null argument may not produce a 404 error");

    d.close();
  }
  