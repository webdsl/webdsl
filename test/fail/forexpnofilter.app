//should be a collection of type 

application test

section data
  entity Stringholder {
    string :: String
  }

section functions

globals {
  function do() {
    var list : List<String>;
    for(item : String in "fiets") {
      var a : String := "dinges";
    } 
  }
}