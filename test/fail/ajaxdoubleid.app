//is defined multiple times
application test

section pages

define page root() {
  block[id:= hoi] { "hoi1"} 
  block[id:= hoi] { "hoi2"}
}
