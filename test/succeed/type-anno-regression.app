application test

  entity Pub {
    bibs -> Set<Bib> := getbibs()
    function getbibs() : Set<Bib> { return Set<Bib>(); }
  }
  
  entity Bib {
  }
 
  define page root(){}