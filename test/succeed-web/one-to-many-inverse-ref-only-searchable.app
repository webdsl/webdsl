application test
section pages
page root(){
  
}
section datamodel
  entity Assignment{
    subs : Set<Submission> (inverse-reference-only)
    extraInfo  : String
    key : String (id)
    
    extend function addToSubs( s  : Submission ){
      s.extraInfo := "added to assignment";
    }
    
    search mapping{
      subs with depth 1
    }
  }

  entity Submission{
    assignment : Assignment (inverse=Assignment.subs)
    extraInfo  : String
    key : String (id)
    keywords : String (default="somesub")
    
    extend function setAssignment( a : Assignment ){
      if(a != null){ a.extraInfo :=  "set in Submission"; }
    }   
    
    search mapping{
      keywords
    }
  }

  override template output( b : Bool ){
  	if(b){
  		"true"
  	} else {
  		"false"
  	}
  }
  page test1(){
    var a1 := Assignment{ key := "a1"}
    var a2 := Assignment{ key := "a2"}
    var a3 := Assignment{ key := "a3"}
    var a4 := Assignment{ key := "a4"}
    var sub1 : Submission
    var sub2 : Submission
    var sub3 := Submission{ key := "sub3" }
    var sub4 := Submission{ key := "sub4" }
    init{
	    a1.save();
	    a2.save();
	    a3.save();
	    a4.save();
	    
	    sub1 := Submission{ key := "sub1" assignment := a1 };
	    sub2 := Submission{ key := "sub2" assignment := a1 };
	      
      a3.subs.add(sub3);
      sub4.save();
      sub4.assignment := a4;
      sub4.assignment := null;
      
      var a5 := Assignment{ key := "a5" };
      var sub5 := Submission{ key := "sub5" assignment := a5 };
      a5.save();      
    }
  }
  
  template checkCounts(){
    var searchCnt := count from search Assignment matching subs.keywords:"somesub" limit 100
    var hqlCnt := select count(*) from Assignment as a where not(a.subs is empty)
    if(searchCnt == hqlCnt){
      "COUNTS OKAY"
    }
  }
  
  page test2(){
    var a5 := findAssignment("a5")
    var a6 := findAssignment("a6")
    var sub5 := findSubmission("sub5")
    
  	checkCounts

  	if(a6 == null){
      submit action{
        for(s : Submission){
          s.assignment := null;
        }
        for(s : Submission where s != sub5){
          s.delete();      
        }
        var newA := Assignment{ key:="a6"};
        var sub6 := Submission{ key:="sub6" assignment := newA };
        if(newA.subs.length !=1 ){
          return pagenotfound();
        }
        newA.save();
      }{ "do something" }
      
  	} else{      
      submit action{
        sub5.assignment := null;
      }{"do something 2"}
    }
  }
  
page test3(){
  var a5 := findAssignment("a5")
  var sub5 := findSubmission("sub5")
  init{
    if(sub5 != null){      
      sub5.assignment := a5;
    }
    
  }
  checkCounts

  
}

page test4(){
	var subsInAssignments := -1
	init{
		var subs := from Submission;
    // for( a : Assignment ){
    //   a.subs.clear();
    //   a.delete();
    // }
    var assign : Assignment;
    for(s in subs){
      assign := s.assignment;
      s.assignment := null;
      s.delete(); 
    }
    for(a : Assignment){
      if(subsInAssignments < 0){
        subsInAssignments := 0;
      }
      subsInAssignments := subsInAssignments + a.subs.length;
    }
	}
	checkCounts
}

  test inverseWithSkipVersionAnno {
  	
    var d : WebDriver := getFirefoxDriver();    
    
    d.get(navigate(test1()));
    var src := d.getPageSource();
    
    // page2
    d.get(navigate(test2()));
    src := d.getPageSource();
    assert(src.contains("COUNTS OKAY"), "Search should result in same amount of assignments being found as is actually in the database");
    d.getSubmit().click();
    src := d.getPageSource();
    assert(src.contains("COUNTS OKAY"), "Search should result in same amount of assignments being found as is actually in the database");
    
    d.getSubmit().click();
    src := d.getPageSource();
    assert(src.contains("COUNTS OKAY"), "Search should result in same amount of assignments being found as is actually in the database");
    
    // page3
    d.get(navigate(test3()));
    d.get(navigate(test3())); //check counts after tx commit, by reloading page
    src := d.getPageSource();
    assert(src.contains("COUNTS OKAY"), "Search should result in same amount of assignments being found as is actually in the database");
        
    // page4
    d.get(navigate(test4()));
    d.get(navigate(test4())); //check counts after tx commit, by reloading page
    src := d.getPageSource();
    assert(src.contains("COUNTS OKAY"), "Search should result in same amount of assignments being found as is actually in the database");
        
  }