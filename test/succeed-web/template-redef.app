application test

  entity TestEntity{
    name :: String
  }

  define page root() {
    var i := "1"
    b(i,56)
    b()
    define b(s:String,i:Int) = a
    define b() = a
  }

  define a(s:String,i:Int){output("replaced"+s+i)}
  define b(s:String,i:Int){output(""+i+s)}
  
  define a(){"replacedsecond"}
  define b(){"failed"}

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("replaced156"), "template a(2) contents not shown");
    assert(d.getPageSource().contains("replacedsecond"), "template a(0) contents not shown");
  }
  
