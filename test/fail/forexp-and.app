//should contain a collection of Bool type
application test

  define page home() {
    var list : Bool := And [ i | i : String in ["1","2"] ];
  }
