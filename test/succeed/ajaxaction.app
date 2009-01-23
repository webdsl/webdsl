application test

section pages

define page home() {
  var s: String := "hoi2"
  block[id := target] {}
  action("do",do2())
  action do2 () {
    replace target << templ(s);
    append  target << templ(s);
    
    relocate << apage(s);
    
    visibility target << hide;
    visibility target << show;
    visibility target << toggle;
    
    restyle target << "aclass";
    clear target <<; 
  }
}

define page apage(s: String) {
  output(s)
}

define templ(s: String) {
  "hoi"
  output(s)
}
