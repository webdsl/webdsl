application test

section pages

define page root() {
  placeholder hoi {
    block[onclick = action { replace (hoi , mytemplate()); }  ] { "hoi1"}
  } 
}

define ajax mytemplate() {
  "hoi2"
}
