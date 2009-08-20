application test

section pages

define page root() {
  block[id:= hoi, onclick :=action { replace (hoi , mytemplate()); }  ] { "hoi1"} 
}

define mytemplate() {
  "hoi2"
}
