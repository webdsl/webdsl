//collection in for-expression does not contain declared type
application test

  define page root() {
    var list : List<String> := [ entity | i : String in [1,2,3] ];
    for(item : String in list) {
      output(item)
    } 
  }
