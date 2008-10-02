application test

section pages

define page home() {
  block[id:= "hoi", onclick := actie()] { "hoi"} 
  action actie () {
    replace hoi << @\ "hoi2" ;
    replace hoi << @{ "hoi2" "hoi3"}; 
  }
}

define mytemplate() {
  "hoi2"
}