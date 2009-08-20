application test

section pages

define page root() {
  block[id:= hoi, onclick := actie()] { "hoi"} 
  action actie () {
    replace (hoi, template { "hoi2" "hoi3"}); 
  }
}
