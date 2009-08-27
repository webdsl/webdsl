application withtest2

define page root() {
  ietsowner() with {
    iets() {
      "hello"
    }
  }
}
    
define template helloowner() requires hello() {
  "the 'hello' template should appear here"
  spacer
  break "> " hello() " <"
} 

define template ietsowner () requires iets() {
  helloowner() with {
      hello() { 
        iets() 
      } 
  }
}