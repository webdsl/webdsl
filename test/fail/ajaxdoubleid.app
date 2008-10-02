//Error: Templatecall with id "hoi" is defined multiple times
application test

section pages

define page home() {
  block[id:= "hoi"] { "hoi1"} 
  block[id:= "hoi"] { "hoi2"}
}
