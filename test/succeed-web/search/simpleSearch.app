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
    var q := PersonSearchQuery();
    output("Search page:")    
    output(q.terms("pepe").list()[0].name) 
  }
  
  test SimpleSearch {
    
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    
    var link := d.findElement(SelectBy.className("navigate"));
    link.click();
    assert(d.getPageSource().contains("Pepe Roni"), "Person with name 'Pepe Roni' not found");
    d.close();
  }