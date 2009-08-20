//collection in for-expression does not contain declared type
application test

  define page root() {
    var list : List<String> := [ i+"9" | i : String in {76.7,345.5} limit 5];
    for(item : String in list) {
      output(item)
    } 
  }
