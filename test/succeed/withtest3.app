application withtest3

define page root() {
  ietsowner()  {
    "hello"
  }
}
    
define template helloowner() requires hello() {
  "the 'hello' template should appear here"
  spacer
  break "> " hello() " <"
} 

define template ietsowner () {
  helloowner() with {
      hello() { 
        elements() //<- elements of ietsowner! 
      } 
  }
}