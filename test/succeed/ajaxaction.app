application test

section pages

define page home() {
  var s: String := "hoi2"
  block[id := "target"] {}
  action("do",do2())
  action do2 () {
    replace target << template(s);
    append  target << template(s);
    
    relocate this << apage(s);
    
    visibility target << "hide";
    visibility target << "show";
    visibility target << "toggle";
    
    restyle target << "iets dat niet getypechecked wordt";
    clear target << "iets dat niet uitmaakt"; 
  }
}

define page apage(s: String) {
  output(s)
}

define template(s: String) {
  "hoi"
  output(s)
}