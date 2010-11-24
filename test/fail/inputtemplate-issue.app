//not defined

application inputtemplate

  define page root(){
    test()
    // was not reported by typechecker, related to obsolete inputtemplate code
  }

  define test(s:String){}