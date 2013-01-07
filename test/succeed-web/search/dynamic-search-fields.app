application test

  entity Person{
    name::String
    
    function getDynamicSearchFields() : Set<DynamicSearchField>{ 
      return {DynamicSearchField( name + "-field" , "myval")};
    }
    
    search mapping {
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
    var dynamicSearchField := "Pepe Roni-field";
    var zeroCount := (search Person matching ~dynamicSearchField: "notfound").count();
    
    output("Search page:")
    output(( search Person matching ~dynamicSearchField: "myval" ).results()[0].name)
    
    output("zeroCount:" + zeroCount)
    
  }

  test DynamicSearchFields {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));

    var link := d.findElement(SelectBy.className("navigate"));
    link.click();
    assert(d.getPageSource().contains("Pepe Roni"), "Searching on dynamic field with query 'myval' should have returned the Person with name Pepe Roni.");
    assert(d.getPageSource().contains("zeroCount:0"), "Searching on dynamic field with query 'notfound' should give no results, but it did.");
  }