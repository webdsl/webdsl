application test

  entity Person{
    name::String
  searchmapping {
    name;
    }
  }

  define page root(){
  init{
      var p := Person{};
    p.name := "Pepe Roni";
      p.save();
  }
    output("TEST")
    navigate searchPage() { "go to search" }
  }
  
  define page searchPage(){
    var searcher := PersonSearcher();
    output("Search page:")    
    output(searcher.query("pepe").list()[0].name) 
  }
  
  test SimpleSearch {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var link := d.findElement(SelectBy.className("navigate"));
    link.click();
    assert(d.getPageSource().contains("Pepe Roni"), "Person with name 'Pepe Roni' not found");
  }