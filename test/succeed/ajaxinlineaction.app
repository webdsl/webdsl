application test

section pages

define page home() {
  block[id:= hoi, onclick :=action { replace hoi << mytemplate(); }  ] { "hoi2"} 
}

define mytemplate() {
  "hoi2"
}