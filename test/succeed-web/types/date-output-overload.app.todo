application test

  define foo(d:Ref<Date>){
    "second template chosen"
  }
  define foo(d:Date){
    "first template chosen"
  }
  
  define page root() {
    for(day : Date in [Date("01/02/1999"),Date("03/04/2000"),Date("05/06/2001")]) {
      foo(day)
    }
  }
  
  
  