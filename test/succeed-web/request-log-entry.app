application test

  define page root(){  
    for(r : RequestLogEntry){
      table{
        derive viewRows from r
        row{ column{ output(r.start.format("yyyy.MM.dd G 'at' HH:mm:ss z")) } }
        row{ column{ output(r.end.format("yyyy.MM.dd G 'at' HH:mm:ss z")) } }
      }
    }
    navigate bla("1234567") { "go" }
  }
  
  define page bla(s:String){
    output(s)
    navigate root() { "go" }
  }

  test one {
    
    var d : WebDriver := FirefoxDriver();

    d.get(navigate(root()));
    assert(d.getPageSource().contains("Firefox"), "firefox user agent not shown");
    
    d.close(); 
  }
  
