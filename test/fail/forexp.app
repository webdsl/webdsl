// where clause should return a boolean

application test

section data
  entity Stringholder {
    string :: String
  }

section functions

globals {
  function do() {
    var list : List<String>;
    for(item : String in list where "blabla") {
      var a : String := "dinges";
    } 
  }
}