application test

section pages

define page home() {
  block[id:= hoi, onclick := { replace hoi << mytemplate(); }  ] { "hoi2"} 
}

define mytemplate() {
  "hoi2"
}