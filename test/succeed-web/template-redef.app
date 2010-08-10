
application test

  entity TestEntity{
    name :: String
  }

  define page root() {
    var i := "1"
    b(i,56)
    define b(s:String,i:Int) = a
  }

  define a(s:String,i:Int){output("replaced"+s+i)}
  define b(s:String,i:Int){output(""+i+s)}

  test var {
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("replaced156"), "template a contents not shown");
    d.close();
  }
  
