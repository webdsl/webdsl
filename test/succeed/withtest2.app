application withtest2

define page root() {
  test2() with {
    iets() {
      showHello()
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

define template test2 () requires iets() {
  test("wereld") with {
    hello() {
  //TODO: needs to work    iets()
    }
    world(s: String) {
      world(s+"2")
    }		
  }
}