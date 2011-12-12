application test


  entity LivingThing{
    stringRepresentation 	:: String
    name	  				:: String
    
    searchmapping {
      name (autocomplete, spellcheck);
      stringRepresentation
    }
  }
  
  entity Person : LivingThing{
    gender	  :: String
        
  searchmapping {
    namespace by gender;
    }
  }
  
  entity Child : Person {
    notes :: String  	
    searchmapping{
      notes
    }
  }
  
  define page root(){
  init{
    var l1 := LivingThing{stringRepresentation := "Unidentified organism"};
      var p1 := Person{stringRepresentation := "Person" name := "John" gender := "male"};
      var p2 := Person{stringRepresentation := "Person" name := "Ted" gender := "male"};
      var p3 := Person{stringRepresentation := "Person" name := "Kim" gender := "female"};
      var p4 := Person{stringRepresentation := "Person" name := "Jolanda" gender := "female"};
      var c1 := Child{stringRepresentation := "Child" name := "Sandra" gender := "female" notes:="has medication"};
      
      l1.save();
    p1.save();
    p2.save();
    p3.save();
    p4.save();
    c1.save();
  }
    output("TEST")
    navigate searchPage() { "go to search" }
  }
  
   
  define page searchPage(){
    init{
      IndexManager.indexSuggestions();
    }
    var personSearcher := PersonSearcher();
    var livingThingSearcher := LivingThingSearcher();
    
    "male-1:" output(personSearcher.query("John").setNamespace("male").resultSize())
    "male-2:" output(personSearcher.list()[0].name)
    "male-3:" output(personSearcher.query("Sandra").resultSize())
    "female-1:" output(personSearcher.setNamespace("female").query("Kim").resultSize())
    "female-2:" output(personSearcher.list()[0].name)
    "female-3:" output(personSearcher.query("Sandra").resultSize())
    "female-4:" output(personSearcher.list()[0].name)
    "super-1:" output(livingThingSearcher.query("unidentified").resultSize())
    "super-2:" output(livingThingSearcher.query("John").resultSize())
    "super-3:" output(livingThingSearcher.query("Sandra").resultSize())
    "super-4:" output(livingThingSearcher.query("Kim").resultSize())
    "noResult-1:" output(personSearcher.setNamespace("male").query("Kim").resultSize())
    "noResult-2:" output(personSearcher.setNamespace("nonexisting").query("John").resultSize())
    "noResult-3:" output(personSearcher.setNamespace("female").query("Ted").resultSize())
    "autocomplete-1:" output(PersonSearcher.autoCompleteSuggest("j", "male", "name",5).length)
    "autocomplete-2:" output(PersonSearcher.autoCompleteSuggest("j", "male", "name",5)[0])
    "autocomplete-3:" output(PersonSearcher.autoCompleteSuggest("j", "female", "name",5).length)
    "autocomplete-4:" output(PersonSearcher.autoCompleteSuggest("j", "female", "name",5)[0])
    "autocomplete-5:" output(PersonSearcher.autoCompleteSuggest("j", "name",5).length)
    "autocomplete-6:" output(ChildSearcher.autoCompleteSuggest("s", "name",5).length)
    "autocomplete-7:" output(ChildSearcher.autoCompleteSuggest("s", "male", "name",5).length)
    "autocomplete-8:" output(ChildSearcher.autoCompleteSuggest("s", "female", "name",5).length)
    "spellcheck-1:" output(PersonSearcher.spellSuggest("jon", "male", "name", 0.7, 5).length)
    "spellcheck-2:" output(PersonSearcher.spellSuggest("jon", "male", "name", 0.7, 5)[0])
    "spellcheck-3:" output(PersonSearcher.spellSuggest("Jolandea", "female", "name", 0.7, 5).length)
    "spellcheck-4:" output(PersonSearcher.spellSuggest("Jolandea", "female", "name", 0.7, 5)[0])
    "spellcheck-5:" output(PersonSearcher.spellSuggest("Jolandea", "name", 0.7, 5).length)
    "spellcheck-6:" output(ChildSearcher.spellSuggest("sandrea", "female", "name", 0.7, 5).length)
    "spellcheck-7:" output(ChildSearcher.spellSuggest("sandrea", "female", "name", 0.7, 5)[0])
    "spellcheck-8:" output(ChildSearcher.spellSuggest("sandrea", "male", "name", 0.7, 5).length)
    "spellcheck-9:" output(ChildSearcher.spellSuggest("sandrea", "name", 0.7, 5).length)
    "spellcheck-10:" output(ChildSearcher.spellSuggest("jon", "male", "name", 0.7, 5).length)
    "spellcheck-11:" output(ChildSearcher.spellSuggest("jon", "name", 0.7, 5).length)
    "spellcheck-12:" output(LivingThingSearcher.spellSuggest("jon", "name", 0.7, 5).length)
    "spellcheck-13:" output(LivingThingSearcher.spellSuggest("jon", "name", 0.7, 5)[0])
    
  }
  
  test searchNamespace {
    IndexManager.clearAutoCompleteIndex("Person");
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    var link := d.findElement(SelectBy.className("navigate"));
    link.click();
    var pagesource := d.getPageSource();
    assert(pagesource.contains("male-1:1"), "Querying 'John' in namespace 'male' should give 1 result");
    assert(pagesource.contains("male-2:John"), "Querying 'John' in namespace 'male' should return person with name 'John'");
    assert(pagesource.contains("male-3:0"), "Querying 'Sandra' in namespace 'male' should give 0 result");
    assert(pagesource.contains("female-1:1"), "Querying 'Kim' in namespace 'female' should give 1 result");    
    assert(pagesource.contains("female-2:Kim"), "Querying 'Kim' in namespace 'female' should return person with name 'Kim'");
    assert(pagesource.contains("female-3:1"), "Querying 'Sandra' in namespace 'female' should give 1 result");    
    assert(pagesource.contains("female-4:Sandra"), "Querying 'Sandra' in namespace 'female' should return child with name 'Sandra'");
    assert(pagesource.contains("super-1:1"), "Querying 'unidentified' using searcher for Living Thing (a super entity of an entity with namespace def) should give 1 result");
    assert(pagesource.contains("super-2:1"), "Querying 'John' using searcher for Living Thing (a super entity of an entity with namespace def) should give 1 result");
    assert(pagesource.contains("super-3:1"), "Querying 'Sandra' using searcher for Living Thing (a super entity of an entity with namespace def) should give 1 result");
    assert(pagesource.contains("super-4:1"), "Querying 'Kim' using searcher for Living Thing (a super entity of an entity with namespace def) should give 1 result");   
    assert(pagesource.contains("noResult-1:0"), "There should be no match in namespace:'male', query:'Kim'");
    assert(pagesource.contains("noResult-1:0"), "There should be no match in namespace:'nonexisting', query:'John'");
    assert(pagesource.contains("noResult-1:0"), "There should be no match in namespace:'female', query:'Ted'");
    assert(pagesource.contains("autocomplete-1:1"), "PersonSearcher.autoCompleteSuggest should return 1 completion (namespace:'male', to complete:'j')");
    assert(pagesource.contains("autocomplete-2:john"), "PersonSearcher.autoCompleteSuggest should return 'john' (namespace:'male', to complete:'j')");
    assert(pagesource.contains("autocomplete-3:1"), "PersonSearcher.autoCompleteSuggest should return 1 completion (namespace:'female', to complete:'j')");
    assert(pagesource.contains("autocomplete-4:jolanda"), "PersonSearcher.autoCompleteSuggest should return 'jolanda' (namespace:'female', to complete:'j')");
    assert(pagesource.contains("autocomplete-5:2"), "PersonSearcher.autoCompleteSuggest should return 2 completions (namespace:'', to complete:'j')");
    assert(pagesource.contains("autocomplete-6:1"), "ChildSearcher.autoCompleteSuggest should return 1 completion (namespace:'', to complete:'s')");
    assert(pagesource.contains("autocomplete-7:0"), "ChildSearcher.autoCompleteSuggest should return 0 completions (namespace:'male', to complete:'s')");
    assert(pagesource.contains("autocomplete-8:1"), "ChildSearcher.autoCompleteSuggest should return 1 completion (namespace:'female', to complete:'s')");
    assert(pagesource.contains("spellcheck-1:1"), "PersonSearcher.spellSuggest should return 1 correction (namespace:'male')");
    assert(pagesource.contains("spellcheck-2:john"), "PersonSearcher.spellSuggest should return 'john' (namespace:'male')");
    assert(pagesource.contains("spellcheck-3:1"), "PersonSearcher.spellSuggest should return 1 correction (namespace:'female')");
    assert(pagesource.contains("spellcheck-4:jolanda"), "PersonSearcher.spellSuggest should return 'jolanda' (namespace:'female')");
    assert(pagesource.contains("spellcheck-5:1"), "PersonSearcher.spellSuggest should return 1 correction (namespace:'')");
    assert(pagesource.contains("spellcheck-6:1"), "ChildSearcher.spellSuggestshould return 1 correction (namespace:'female')");
    assert(pagesource.contains("spellcheck-7:sandra"), "ChildSearcher.spellSuggest should return 'sandra' (namespace:'female')");
    assert(pagesource.contains("spellcheck-8:0"), "ChildSearcher.spellSuggest should return 0 corrections (namespace:'male')");
    assert(pagesource.contains("spellcheck-9:1"), "ChildSearcher.spellSuggest should return 1 correction (namespace:'')");
    // assert(pagesource.contains("spellcheck-10:0"), "ChildSearcher.spellSuggest should return 0 corrections (namespace:'male'), because 'john' does not appear as name in Child, only in Person");
    // assert(pagesource.contains("spellcheck-11:0"), "ChildSearcher.spellSuggest should return 0 corrections (namespace:''), because 'john' does not appear as name in Child, only in Person");
    assert(pagesource.contains("spellcheck-12:1"), "LivingThingSearcher.spellSuggest should return 1 correction");
    assert(pagesource.contains("spellcheck-13:john"), "LivingThingSearcher.spellSuggest should return 'john'");
  }