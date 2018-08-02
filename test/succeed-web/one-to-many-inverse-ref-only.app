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
  }

  entity Submission{
    assignment : Assignment (inverse=Assignment.subs)
    extraInfo  : String
    key : String (id)
    keywords : String (default="somesub")
    
    extend function setAssignment( a : Assignment ){
      if(a != null && a.key != "a5"){ a.extraInfo :=  "set in Submission"; }
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
    "a1.subs.length: " output(a1.subs.length)
    "a2.subs.length: " output(a2.subs.length)
    "sub1.extraInfo: " output(sub1.extraInfo)
    "sub2.extraInfo: " output(sub2.extraInfo)
    "sub3.assignment == a3: " output(sub3.assignment == a3)
    "sub3.extraInfo == added to assignment: " output(sub3.extraInfo == "added to assignment")
    "a3.extraInfo == set in Submission: " output(a3.extraInfo == "set in Submission")
    "sub4.extraInfo == added to assignment: " output(sub4.extraInfo == "added to assignment")
    "a4.extraInfo == set in Submission: " output(a4.extraInfo == "set in Submission")
    "a4.subs.length == 0: " output(a4.subs.length == 0)
  }
  
  
  page test2(){
    var a5 := findAssignment("a5")
    var a6 := findAssignment("a6")
    var sub5 := findSubmission("sub5")
    
    "all subs.length: " output((from Submission).length)

    
    if(sub5.assignment == null && a5.subs.length == 0){
      "sub5.assignment == null and a5.subs.length == 0"
      submit action{
        goto test3(a5.version);
      }{"go to test 3"}
    } else { if(a6 == null){
      "a5.subs.length: " output(a5.subs.length)
      submit action{
        for(s : Submission where s != sub5){
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
      "a6.subs.length == 1: " output(a6.subs.length == 1)
      
      submit action{
        sub5.assignment := null;
      }{"do something 2"}
    } }
  }
  
page test3(oldVer : Int){
  var a5 := findAssignment("a5")
  var sub5 := findSubmission("sub5")
  var pass := false
  var a5version := a5.version
  var passVersion := false
  init{
    log("before - oldVer/a5.ver:" + oldVer + "/" + a5.version);
    if(sub5 != null){      
      sub5.assignment := a5;
      log("after assigning - oldVer/a5.ver:" + oldVer + "/" + a5.version);
      var len := a5.subs.length;
      pass := len == 1;
    }
    log("after reading subs - oldVer/a5.ver:" + oldVer + "/" + a5.version);
    passVersion := oldVer == a5.version;
    
  }
  if(pass){
    "PASSED INVERSE SET TEST"
  }
  if(passVersion){
    "PASSED VERSION TEST"
    submit action{ goto test3(a5.version); }{"refresh page"}
  }
  
}

page test4(){
  var msg := "PASSED"
  var subsInAssignments := -1
  init{
    var subs := from Submission;
    if(subs.length != 2){
      msg := "FAILED";
    }
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
  "subs in assignments: " output( subsInAssignments )
  output( msg )
}

  test inverseWithSkipVersionAnno {
    
    var d : WebDriver := getFirefoxDriver();
        
    // test1
    d.get(navigate(test1()));
    var src := d.getPageSource();
    assert(src.contains("a1.subs.length: 2"), "a1 should have 2 submissions");
    assert(src.contains("a2.subs.length: 0"), "a2 should have 0 submissions");
    assert(src.contains("sub1.extraInfo: added to assignment"), "extend function on Assignment side should have set extra info");
    assert(src.contains("sub2.extraInfo: added to assignment"), "extend function on Assignment side should have set extra info");
    
    
    assert(src.contains("sub3.assignment == a3: true"), "sub3.assignment should be a3");
    assert(src.contains("sub3.extraInfo == added to assignment: true"),  "extend function on Assignment side should have set extra info");
    
    assert(src.contains("a3.extraInfo == set in Submission: true"), "extend function on Assignment side should have set extra info" );
    
    assert(src.contains("sub4.extraInfo == added to assignment: true"), "extend function on Assignment side should have set extra info" );
    assert(src.contains("a4.extraInfo == set in Submission: true"), "extend function on Submission side should have set extra info" );
    assert(src.contains("a4.subs.length == 0: true"), "a4 should have 0 submission");
    
    // test2
    d.get(navigate(test2()));
    src := d.getPageSource();
    assert(src.contains("all subs.length: 5"), "There should be 5 submissions");
    assert(src.contains("a5.subs.length: 1"), "a5 should have 1 sub assigned");
    
    d.getSubmit().click();
    src := d.getPageSource();
    assert(src.contains("all subs.length: 2"), "There should be 2 submissions left");
    assert(src.contains("a6.subs.length == 1: true"), "a6 should have sub6 in it");
    
    d.getSubmit().click();
    src := d.getPageSource();
    assert(src.contains("sub5.assignment == null and a5.subs.length == 0"), "a5 should not be associated with sub5 in both directions" );
    d.getSubmit().click(); //go to test 3
    
    // test3
    src := d.getPageSource();
    assert( src.contains("PASSED INVERSE SET TEST"), "No error should have been thrown");
    assert( src.contains("PASSED VERSION TEST"), "Inverse version should not have increased");
    d.getSubmit().click();
    assert( src.contains("PASSED VERSION TEST"), "Inverse version should not have increased");
    d.getSubmit().click();
    assert( src.contains("PASSED VERSION TEST"), "Inverse version should not have increased");
        
    // test4
    d.get(navigate(test4()));
    src := d.getPageSource();
    assert( src.contains("subs in assignments: 0"), "All Assignment.subs collections should have been empty.");
    assert( src.contains("PASSED"), "page should load with PASSED msg");
        
  }