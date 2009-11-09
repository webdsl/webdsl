
application test

  define page root() {
    var list : List<String> := [ i+"," | i : String in ["1","2","3","4","25"] where i != "25" order by i+i limit 3 offset 1];
    var b1 : Bool := And [ i == "1" | i : String in ["1","2"] ];
    var b2 : Bool := Or [ i == "25" | i : String in ["1","2","3","4","25"] offset 2];
    
    for(item : String in list) {
      output(item)
    } 
    "==2,3,4,"
    break
    output(b1) "== false"
    break
    output(b2) "== true"
  }

  
  test forexp {
  
    var list : List<String> := [ i+"," | i : String in ["1","2","3","4","25"] where i != "25" order by i+i limit 3 offset 1];
    var b1 : Bool := And [ i == "1" | i : String in ["1","2"] ];
    var b2 : Bool := Or [ i == "25" | i : String in ["1","2","3","4","25"] offset 2];
   
    assert(list == ["2,","3,","4,"]);
    assert(b1 == false);
    assert(b2 == true);
  }