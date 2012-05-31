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

  test {
    var d : WebDriver := getFirefoxDriver();

    d.get(navigate(root()));
    d.get(navigate(root())); // access twice, so the previous request shows up
    assert(d.getPageSource().contains("GET"), "GET method not shown");
  }
  
