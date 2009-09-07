application withtest4

define page root() {
   helloowner() with {
      hello() { 
        "hello" 
      } 
   }
}
    
define inarrows() {
  "> " elements() "< "
}    
    
define template helloowner() requires hello() {
  "the 'hello' template should appear here"
  spacer
  break inarrows { hello() } //required template passed to elements() 
} 
