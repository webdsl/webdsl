application test

section datamodel

entity Author {
	name :: String (id, name)
	publication    -> Publication (inverse = Publication.author)
}

entity Publication {
	key :: String
	title :: String (name)
	author    -> Author 	
}

section pages/actions/vars


	define page root(){
	  	var a := Author{};
		var p := Publication{};
	    
	    "root page"
	    
	    var pub : Publication := Publication{}
	    init{
	    	var list := findPublicationByKey("123");
	    	if(list.length>0){
	    		pub := list[0];	
	    	}
	    }
	    
	    action create(){    
			a.name := "Jan Jansen"; a.save();
			p.author := a; p.title := "mytitle"; p.key := "123"; p.save();
			return root();
	    }
	    
	    action change(){
	    	pub.save();
	    	return root();
	    }
	    form{
	    	submit("create",create())
	    }	    	 
   	  	form{
   	  		input(pub.author, from Author)
      		submit("change",change())
    	}
	    
	    form{
	    	submit action{ pub.author := (from Author)[0]; pub.save();}{"set without inputfield"}
	    }
	      
		list{for(auth : Author) {
			if(auth.publication != null){
	           output(auth.publication)
	        }
	    }}
	    
	    

  
	}

section tests
 test one {
    
    var d : WebDriver := FirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(!(d.getPageSource().contains("404")), "root page may not produce a 404 error");
    assert(d.getPageSource().contains("root page"), "expected to be on root page");
    
    var elist : List<WebElement> := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 7, "expected <input> elements did not match");
    elist[1].click();
    assert(d.getPageSource().contains("root page"), "should have been redirected");
    assert(d.getPageSource().contains("mytitle"), "1 Title of publication owned by author should have been displayed");
    
    elist := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 7, "expected <input> elements did not match");
    elist[4].click();
    assert(d.getPageSource().contains("mytitle"), "2 Title of publication owned by author should still have been displayed");
    
    elist := d.findElements(SelectBy.tagName("input"));
    assert(elist.length == 7, "expected <input> elements did not match");
    elist[6].click();
    assert(d.getPageSource().contains("mytitle"), "3 Title of publication owned by author should still have been displayed");
    
    d.close();
  }