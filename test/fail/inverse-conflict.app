//#2 Inverse annotation

application test

  entity A { 
    b -> B (optional)
  } 
  entity B { 
    a1 -> A (inverse=A.b) 
    a2 -> A (inverse=A.b) 
  }
    
  define page root(){}
