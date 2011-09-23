application test

  entity Publication{
    title	  :: String
    authors   -> Set<Author>
    tags 	  -> Set<Tag>
    bibs	  -> Set<Bibliography>	
    
	searchmapping {
		title;
		authors;
		tags;
		bibs;
  	}
  }
  
  entity Author{
  	name 		:: String
  	publications-> Set<Publication> (inverse=Publication.authors)

  	
  	searchmapping {
  		name
  	}
  }
  
  entity BaseTag{
  	name :: String
  	searchmapping{
  		name
  	}
  }
  
  entity Tag : BaseTag{
  	
  	publications -> Set<Publication> (inverse=Publication.tags)
  	
  	searchmapping{
  		publications with depth 2
  	}
  }
  
  entity Bibliography{
  	title :: String
  	publications -> Set<Publication> (inverse=Publication.bibs)
  	
  	searchmapping{
  		title
  		publications with depth 2
  	}
  }
  
  
  define page root(){
	init{
	  	var pub1 := Publication{title := "pub1"};
	  	var pub2 := Publication{title := "pub2"};
	  	var pub3 := Publication{title := "pub3"};
	  	var pub4 := Publication{title := "pub4"};
	  	var pub5 := Publication{title := "pub5"};
	  	var author1 := Author{name := "auth1" publications := {pub1} };
	  	var author2 := Author{name := "auth2" publications := {pub2} };
	  	var author3 := Author{name := "auth3" publications := {pub3} };
	  	var author4 := Author{name := "auth4" publications := {pub4} };
	  	var author5 := Author{name := "auth5" publications := {pub5} };
	  	var tag1 := Tag{name := "tag1" publications := {pub1} };
	  	var tag2 := Tag{name := "tag2" publications := {pub2} };
	  	var tag3 := Tag{name := "tag3" publications := {pub3} };
	  	var tag4 := Tag{name := "tag4" publications := {pub4} };
	  	var tag5 := Tag{name := "tag5" publications := {pub5} };
	  	var bib1 := Bibliography{title := "bib1" publications := {pub1} };
	  	var bib2 := Bibliography{title := "bib2" publications := {pub2} };
	  	var bib3 := Bibliography{title := "bib3" publications := {pub3} };
	  	var bib4 := Bibliography{title := "bib4" publications := {pub4} };
	  	var bib5 := Bibliography{title := "bib5" publications := {pub5, pub4} };
	  	pub1.save(); pub2.save(); pub3.save(); pub4.save(); pub5.save();
	  	author1.save(); author2.save(); author3.save(); author4.save(); author5.save();
	  	tag1.save(); tag2.save(); tag3.save(); tag4.save(); tag5.save();
	  	bib1.save(); bib2.save(); bib3.save(); bib4.save(); bib5.save();  
	}
  	output("TEST")
  	navigate searchPage() { "go to search" }
  }
  
  define page searchPage(){
    var pubSearcher := PublicationSearcher();
    var authorSearcher := AuthorSearcher();
    var tagSearcher := TagSearcher();
    var bibSearcher := BibliographySearcher();
    output("Search page:")
    
    "pub1:" output(pubSearcher.field("authors.name").query("auth1").list()[0].title)
    "pub2:" output(pubSearcher.field("authors.name").query("auth2").list()[0].title)
    "tag1:" output(tagSearcher.field("publications.authors.name").query("auth1").list()[0].name)
    "tag2:" output(tagSearcher.field("publications.title").query("pub2").list()[0].name)
    "bib2:" output(bibSearcher.field("publications.bibs.title").query("bib5").resultSize())
    "bib3:" output(bibSearcher.field("publications.bibs.title").query("bib3").list()[0].title)
    "bib4:" output(bibSearcher.field("publications.authors.name").query("auth4").list()[0].title)
    "bib5:" output(bibSearcher.field("publications.tags.name").query("tag5").list()[0].title)
    
    
  }
  
  test EmbeddedSearch {

    var d : WebDriver := FirefoxDriver();
    d.get(navigate(root()));
    
    var link := d.findElement(SelectBy.className("navigate"));
    link.click();
    var pagesource := d.getPageSource();
    assert(pagesource.contains("pub1:pub1"), "embedded search on Publication.authors failed");
    assert(pagesource.contains("pub2:pub2"), "embedded search on Publication.authors failed");
    assert(pagesource.contains("tag1:tag1"), "embedded search on Tag.publications.authors.name failed");
    assert(pagesource.contains("tag2:tag2"), "embedded search on Tag.publications.title failed");
    assert(pagesource.contains("bib2:2")   , "embedded search on Bibliography.publications.bibs.title failed, should find 2 results");
    assert(pagesource.contains("bib3:bib3"), "embedded search on Bibliography.publications.bibs.title failed");
    assert(pagesource.contains("bib4:bib4"), "embedded search on Bibliography.publications.authors.name failed");
    assert(pagesource.contains("bib5:bib5"), "embedded search on Bibliography.publications.tags.name failed");
    
    d.close();
  }