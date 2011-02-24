//is not assignable

application test

  define page root() {
    for(day : Date in [Date("01/02/1999"),Date("03/04/2000"),Date("05/06/2001")]) {
      bla(day)
    }
  }
  
  define bla(s:Ref<Date>){}
  