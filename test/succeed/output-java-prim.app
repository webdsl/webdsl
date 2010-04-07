// this causes a java compilation error in rev 3809 due to a comparison of primitive int and null in generated code "incomparable types: int and <nulltype>"

application test

  define page root(){
    <div class=[1].length />
  }