application test

  entity TestEntity{
    name :: String
  }

  //var globaltext := TextEntity{ text := "1" }

  define page root(){
    var t1 : TestEntity := null
    navigate test(t1.name) { "test-link-navigate-null" }
     "123456789"
  }
  
  define page test(t:String){}

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("123456789"), "page not shown");
    assert(!d.getPageSource().contains("test-link-navigate-null"), "navigate should be hidden");
  }
  
