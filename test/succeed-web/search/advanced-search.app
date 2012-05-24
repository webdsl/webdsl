application test

  entity Person{
    name      :: String
    birthday  :: Date
    items     -> Set<Item>

    search mapping {
        name;
        items;
        birthday;
      }
  }

  entity Item{
      name         :: String
      description :: String (length = 1000)
      owner         -> Person (inverse=Person.items)

      search mapping {
          name as nameField
          name as nameFieldNoStop using standard_no_stop
          name as nameCustomStop using custom_stop
          name as nameCompletion using autocomplete_untokenized (autocomplete);
          description;
      }
  }

  entity DateThingy{
      date         :: Date (searchable(analyzer=year))
      datetime     :: DateTime (searchable(analyzer=year))
      time         :: Time (searchable(analyzer=year))
  }

analyzer year{
  tokenizer = PatternTokenizer(pattern="^([0-9]{4})", group="1")
}
analyzer month{
    tokenizer = PatternTokenizer(pattern="^[0-9]{4}([0-9]{2})", group="1")
}

  analyzer autocomplete_untokenized {
    tokenizer = KeywordTokenizer
    token filter = LowerCaseFilter
  }

  analyzer standard_no_stop{
    tokenizer = StandardTokenizer
    token filter = StandardFilter
    token filter = LowerCaseFilter
  }

  analyzer custom_stop{
    tokenizer = StandardTokenizer
    token filter = StandardFilter
    token filter = LowerCaseFilter
      // token filter = StopFilter (words="analyzerfiles/stopwords.txt")
  }



  define page root(){
      var d : DateThingy;
    init{
        d := DateThingy{date := Date("01/02/2003") datetime := now() time := Time("12:34")}; //DateTime("01/02/2003 12:34")
          var p := Person{name := "Pepe Roni" birthday := Date("05/05/1955")};
          var i1 := Item{
              name := "Bottle of dr Pepper"
              description := "ingredients for Dietetic Dr Pepper, circa 1963: Carbonated water, caramel color, citric acid, phosphoric acid, caffeine, sodium    cyclamate, sodium carboxymethylcellulose, sodium saccharin, monosodium phosphate, lactic acid, flavoring, spices, less than 1/20th of 1% benzoate of soda (preservative), .088% sodium cyclamate, .007% sodium saccharine, non-nutritive artificial sweeteners which should be used    only by persons who must restrict their intake of ordinary sweets. No fat or protein. .28% available carbohydrates. 1/3 calorie per fl. oz. TheEnd."
            owner := p };
          var i2 := Item{
              name := "Diet Coke"
              description := "Amount (% RDA Ingredients) Calories 0 Fat 0g (0%) Sodium 40mg (2%) Carbohydrates 0g (0%) Sugar 0g Protein 0g (0%) Diet Coke™ - Ingredients Carbonated Water    High Fructose Corn Syrup Caramel Color Phosphoric Acid Natural Flavors Caffeine Aspartame (NutraSweet) Potassium Benzoate Citric acid. TheEnd."
            };
          var i3 := Item{
              name := "Car"
              description := "The Fiat 500 (Italian: cinquecento, Italian pronunciation: [tralala]) is a car produced by the Fiat company of Italy between 1957 and 1975, with limited production of the Fiat 500 K estate continuing until 1977. The car was designed by Dante Giacosa. Launched as the Nuova (new) 500 in July 1957,[1] it was marketed as a cheap and practicaltown car. Measuring only 3 metres (~10 feet) long, and originally powered by a tiny 479 cc two-cylinder, air-cooled engine, the 500 redefined the term 'small car' and is considered one of the first city cars. In 2007 Fiat launched a similar styled, longer and heavier front wheel drive car, the Fiat    Nuova 500. TheEnd."
            };
        d.save();
        p.save();
        i1.save();
        i2.save();
        i3.save();
    }
      output("TEST") output(d.date) " " output(d.datetime) " " output(d.time)
      navigate searchPageNativeJava() { "go to search" }
  }

  define page searchPageNativeJava(){
      init{
          IndexManager.indexSuggestions();
      }
    var personSearcher := PersonSearcher();
    var personSearcher2 := PersonSearcher();
    var personSearcher3 := PersonSearcher();
    var itemSearcher := ItemSearcher();
    var itemSearcher1 := ItemSearcher();
    var itemSearcher2 := ItemSearcher();
    var itemSearcher3 := ItemSearcher();
    var itemSearcher4 := ItemSearcher();
    var name := "Bottle of dr Pepper"
    var drPepperItems := from Item as i where i.name = ~name;
    output("Search page:")


    "simplesearch-1:" output(itemSearcher.query("bottle AND Dietetic").results()[0].name)
    "embeddedsearch-1:" output(personSearcher.query("bottle").results()[0].name)
    "embeddedsearch-2:" output(personSearcher.field("items.nameField").query("bottle").results()[0].name)
    "nostopfilter-1:" if(itemSearcher.field("nameFieldNoStop").query("of").results().length == 1){output(itemSearcher.results()[0].name)}
    "stopfilter-1:" if(itemSearcher.fields(["nameField"]).query("of").results().length == 0){"OK"}
    "morelikethis-1:" output(itemSearcher.field("description").moreLikeThis(drPepperItems[0].description).setLimit(10).count())
    "morelikethis-2-3:" output(itemSearcher.results()[0].name)
    "morelikethis-2-3:" output(itemSearcher.results()[1].name)
    "rangesearch-1:" output(personSearcher.field("birthday").rangeQuery(Date("05/05/1955"),Date("05/05/1955")).count())
    "rangesearch-2:" output(personSearcher.field("birthday").rangeQuery(Date("05/05/1954"),Date("05/05/1956")).count())
    "rangesearch-3:" output(personSearcher.field("birthday").rangeQuery(Date("03/05/1955"),Date("04/05/1955")).count())
    "rangesearch-4:" output(personSearcher.field("birthday").rangeQuery(Date("01/01/2005"),Date("31/12/2013")).count())
    "autocomplete-1:" output(ItemSearcher.autoCompleteSuggest("coke","nameCompletion",5)[0])
    "autocomplete-2:" output(ItemSearcher.autoCompleteSuggest("ca",["nameCompletion"],5)[0])
    "autocomplete-3:" output(ItemSearcher.autoCompleteSuggest("pepf","nameCompletion",1)[0])
    "autocomplete-4:" output(ItemSearcher.autoCompleteSuggest("b","nameCompletion",1)[0])
    "boolean-1:" output(itemSearcher1.mustNot().field("description").query("Pepper").should().query("Color").count())
    "boolean-2:" output(itemSearcher1.results()[0].name)
    "boolean-3:" output(itemSearcher2.startShouldClause().mustNot().query("italian").field("description").must().query("TheEnd").endClause().count())
    "boolean-4:" output(itemSearcher3.startShouldClause().mustNot().query("italian").field("description").must().query("TheEnd").endClause().should().query("italian").count())
    "boolean-5:" output(personSearcher2.mustNot().field("birthday").rangeQuery(Date("05/05/1954"),Date("05/05/1956")).should().query("Pepe").field("name").count())
    "boolean-6:" output(personSearcher3.startShouldClause().mustNot().field("birthday").rangeQuery(Date("05/05/1954"),Date("05/05/1956")).endClause().should().query("Pepe").field("name").count())
    "phrase-1:" output(itemSearcher4.phraseQuery("fat protein", 2).count())
    "phrase-2:" output(itemSearcher4.results()[0].name)

    navigate BooleanResultPage(personSearcher3) {"click"}
   // "customstopfilter-1:" output(itemSearcher.field("nameCustomStop").query("diet").count())
   // "customstopfilter-2:" output(itemSearcher.field("nameCustomStop").query("bottle").count())

  }

  define page BooleanResultPage(ps : PersonSearcher){
      "searcherPageArg:" output(ps.count())
      navigate searchPageDSL() {"click"}
  }

  define page searchPageDSL(){

    var personSearcher := search Person;
    var personSearcher2 := search Person;
    var personSearcher3 := search Person;
    var itemSearcher := search Item;
    var itemSearcher1 := search Item;
    var itemSearcher2 := search Item;
    var itemSearcher3 := search Item;
    var itemSearcher4 := search Item;
    var name := "Bottle of dr Pepper"
    var drPepperItems := from Item as i where i.name = ~name;
    output("Search page:")


    "simplesearch-1:" output( (~itemSearcher matching "bottle AND Dietetic").results()[0].name)
    "embeddedsearch-1:" output( (~personSearcher matching "bottle").results()[0].name)
    "embeddedsearch-2:" output( (~personSearcher.reset() matching items.nameField: "bottle").results()[0].name)
    "nostopfilter-1:" if( (~itemSearcher.reset() matching nameFieldNoStop: "of").results().length == 1){output(itemSearcher.results()[0].name)}
    "stopfilter-1:" if( (~itemSearcher.reset() matching nameField: "of").results().length == 0){"OK"}
    //morelikethis is not yet supported in search dsl:
    "morelikethis-1:" output( itemSearcher.field("description").moreLikeThis(drPepperItems[0].description).setLimit(10).count())
    "morelikethis-2-3:" output(itemSearcher.results()[0].name)
    "morelikethis-2-3:" output(itemSearcher.results()[1].name)

    "rangesearch-1:" output( count from ~personSearcher.reset() matching birthday: [Date("05/05/1955") to Date("05/05/1955")] )
    "rangesearch-2:" output( count from ~personSearcher.reset() matching birthday: [Date("05/05/1954") to Date("05/05/1956")] )
    "rangesearch-3:" output( count from ~personSearcher.reset() matching birthday: [Date("03/05/1955") to Date("04/05/1955")] )
    "rangesearch-4:" output( count from ~personSearcher.reset() matching birthday: [Date("01/01/2005") to Date("31/12/2013")] )
    "autocomplete-1:" output((Item completions matching nameCompletion : "coke" limit 5)[0])
    "autocomplete-2:" output((Item completions matching nameCompletion : "ca" limit 5)[0])
    "autocomplete-3:" output((Item completions matching nameCompletion : "pepf" limit  1)[0])
    "autocomplete-4:" output((Item completions matching nameCompletion : "b" limit 1)[0])

    "boolean-1:" output(count from ~itemSearcher1 matching -(description: "Pepper") "Color")
    "boolean-2:" output((results from itemSearcher1)[0].name)
    "boolean-3:" output(count from ~itemSearcher2 matching (description: -"italian" +"TheEnd"))
    "boolean-4:" output(count from ~itemSearcher3 matching (description: -"italian" +"TheEnd") "italian")
    "boolean-5:" output(count from ~personSearcher2 matching birthday: -[Date("05/05/1954") to Date("05/05/1956")] name: "Pepe")
    "boolean-6:" output(count from ~personSearcher3 matching (birthday: -[Date("05/05/1954") to Date("05/05/1956")]) name: "Pepe")
    "phrase-1:" output(count from ~itemSearcher4 matching "fat protein"~2)
    "phrase-2:" output((results from itemSearcher4)[0].name)

    navigate BooleanResultPage(personSearcher3) {"click"}
   // "customstopfilter-1:" output(count from ~itemSearcher.reset() matching nameCustomStop: "diet")
   // "customstopfilter-2:" output(count from ~itemSearcher.reset() matching nameCustomStop: "bottle")

  }


  test AdvancedSearch {
    IndexManager.clearAutoCompleteIndex("Item");
    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));

    var link := d.findElement(SelectBy.className("navigate"));
    link.click();

    var runTwice := 0;

    while (runTwice < 2){

        var pagePreFix := if (runTwice < 1) "[SearchPageNativeJava]" else "[SearchPageDSL]";
        var pagesource := d.getPageSource();
        assert(pagesource.contains("simplesearch-1:Bottle of dr Pepper"), pagePreFix + "Error in retrieving search results using default search fields");
        assert(pagesource.contains("embeddedsearch-1:Pepe Roni"), pagePreFix + "Error in retrieving search results, using embedded search field");
        assert(pagesource.contains("embeddedsearch-2:Pepe Roni"), pagePreFix + "Error in retrieving search results, using embedded search field");
        assert(pagesource.contains("nostopfilter-1:Bottle of dr Pepper"), pagePreFix + "Stopword 'of' should not be ignored for field 'nameFieldNoStop'");
        assert(pagesource.contains("stopfilter-1:OK"), pagePreFix + "Stopword 'of' should have been ignored for field 'nameField'");
        assert(pagesource.contains("morelikethis-1:2"), pagePreFix + "More like this should only match the Diet Coke and Dr Pepper items");
        assert(pagesource.contains("morelikethis-2-3:Diet Coke"), pagePreFix + "More like this did not match the Diet Coke item");
        assert(pagesource.contains("morelikethis-2-3:Bottle of dr Pepper"), pagePreFix + "More like this did not match the Dr Pepper item");
        assert(pagesource.contains("rangesearch-1:1"), pagePreFix + "Range query on exact birthday should return 1 result");
        assert(pagesource.contains("rangesearch-2:1"), pagePreFix + "Range query on range around birthday should return 1 result");
        assert(pagesource.contains("rangesearch-3:0"), pagePreFix + "Range query on range before birthday should return 0 results");
        assert(pagesource.contains("rangesearch-4:0"), pagePreFix + "Range query on range after birthday should return 0 results");
        assert(pagesource.contains("autocomplete-1:diet coke"), pagePreFix + "Autocompletion should have returned 'diet coke' on input 'diet'");
        assert(pagesource.contains("autocomplete-2:car"), pagePreFix + "Autocompletion should have returned 'car' on input 'ca'");
        assert(pagesource.contains("autocomplete-3:bottle of dr pepper"), pagePreFix + "Autocompletion should have returned 'bottle of dr pepper' on input 'pepf'");
        assert(pagesource.contains("autocomplete-4:bottle of dr pepper"), pagePreFix + "Autocompletion should have returned 'bottle of dr pepper' on input 'b'");
        assert(pagesource.contains("boolean-1:1"), pagePreFix + "Boolean query should return 1 result ( -(description:pepper) (description:color) )");
        assert(pagesource.contains("boolean-2:Diet Coke"), pagePreFix + "Boolean query should return Diet Coke ( -(description:pepper) (description:color) )");
        assert(pagesource.contains("boolean-3:2"), pagePreFix + "Boolean query should return 2 item results ( (-(description:italian) +(description:theend)) )");
        assert(pagesource.contains("boolean-4:3"), pagePreFix + "Boolean query should return 3 item results ( (-(description:italian) +(description:theend)) (description:italian) )");
        assert(pagesource.contains("boolean-5:0"), pagePreFix + "Boolean query on Persons should return 0 person results ( -birthday:(19540504 TO 19560504) (name:pepe) )");
        assert(pagesource.contains("boolean-6:1"), pagePreFix + "Boolean query on Persons should return 1 person result ( (-birthday:(19540504 TO 19560504)) (name:pepe) )");
        assert(pagesource.contains("phrase-1:1"), pagePreFix + "Phrase query (\"fat proteine\"~2) should only have matched 1 result");
        assert(pagesource.contains("phrase-2:Bottle of dr Pepper"), pagePreFix + "Phrase query (\"fat proteine\"~2) should only have matched item with name 'Bottle of dr Pepper'");

        // assert(pagesource.contains("customstopfilter-1:0"), pagePreFix + "Searching for a stopword defined in custom stopword list should give 0 results");
        // assert(pagesource.contains("customstopfilter-2:1"), pagePreFix + "Searching for 'bottle' defined in custom stopword list should give 1 results");

        link := d.findElement(SelectBy.className("navigate"));
        link.click();
        pagesource := d.getPageSource();
        assert(pagesource.contains("searcherPageArg:1"), pagePreFix + "PersonSearcher with a boolean query should have been encoded and decoded from page argument in URL");

        //Now navigate to page with same search actions, now specified using search DSL instead of native java
        if (runTwice < 1){
          link := d.findElement(SelectBy.className("navigate"));
          link.click();
        }
        runTwice := runTwice + 1;
        }


    d.close();
  }

