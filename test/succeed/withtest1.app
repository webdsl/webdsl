application withtest1

define page root() {
  test("wereld") with {
    hello() {
      showHello()
    }
    world(s: String) {
      world(s+"2")
    }		
  }
}
    
define template showHello() {
 "hello"
}

define template world(x: String) {
  output(x+"3")
}

define template test (wereld: String) requires hello(), world(String) {
  "the 'hello' template should appear here"
  break "> " hello() " <"
  spacer
  "and 'world123' should be just below"
  break "> " world(wereld+"1") " <"
} 
