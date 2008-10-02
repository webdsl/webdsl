//Error: Templatecall id's can only be strings. 
application test

section pages

define page home() {
  var s: String := "hoi"
  block[id:= s] { "hoi1"} 
}
