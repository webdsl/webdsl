application test

  var u1 := User{ name := "testuser"};

  define page root(){
    title{ "root" }
    navigate(test(u1,"")){"test"}
    navigate(test1(u1,"",0)){"test1"}
    navigate(test2(0,"",u1)){"test2"}
    navigate(test3(0,u1,"")){"test3"}
    navigate(test4(0,u1,"",0.0)){"test4"}
    navigate(root()){"root"}
  }
  
  entity User {
    name :: String
  }
  
  define page test(u:User, s:String){
    title{ "test" }
    output(u.name)
    output(s)
  }
  
  define page test1(u:User, s:String, i:Int){
    title{ "test1" }
    output(u.name)
    output(s)
    output(i)
  }
  
  define page test2(i:Int,s:String, u:User){
    title{ "test2" }
    output(u.name)
    output(s)
    output(i)
  }

  define page test3(i:Int, u:User,s:String){
    title{ "test3" }
    output(u.name)
    output(s)
    output(i)
  }
  
  define page test4(i:Int, u:User,s:String,f:Float){
    title{ "test4" }
    output(u.name)
    output(s)
    output(i)
  }
  
  define override page pagenotfound(){
   "custom page not found"
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("a"));
    
    var size := elist.length;
    
    assert(size==6,"not all 6 links were generated");
    
    for(i:Int from 0 to size){
      d.get(navigate(root()));
      var elist1 : List<WebElement> := d.findElements(SelectBy.tagName("a"));
      var e := elist1.get(i);
      var text := e.getText();
      e.click();
      log(d.getTitle());
      assert(text == d.getTitle());
    }
  }
  
  test {
    var d : WebDriver := getFirefoxDriver();
    //construct URL with too few arguments
    var urlTooFewArgs := navigate(test(u1,"")).replace("test", "test2");
    d.get( urlTooFewArgs );
    assert( d.getPageSource().contains( "custom page not found" ) );
    //construct URL with too many arguments
    var urlTooManyArgs := navigate(test(u1,"bla")) + "/more/args";
    d.get( urlTooManyArgs );
    assert( d.getPageSource().contains( "custom page not found" ) );
  }
  

  