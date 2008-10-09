//Error: Properties are defined multiple times
application test

section pages

define page home() {
  block[id:= hoi, id:= hoi2] { "hoi1"} 
}
