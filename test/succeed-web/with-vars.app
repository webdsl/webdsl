application withtest4
  
  define page root() {
     var s := "2"
     var i := 5
     helloowner("6","7") with {
        hello(s2:String, s3:String) { 
          "1" output(s) output(s2) output(s3) output(i) 
        } 
     }
  }   
      
  define template helloowner(s1:String, s2:String) requires hello(String,String) {
    hello("3", "4") output(s1) output(s2) "8" 
  } 

  test {
    var d := getHtmlUnitDriver();
    d.get(navigate(root()));
    assert(d.getPageSource().contains("12345678"));
  }
