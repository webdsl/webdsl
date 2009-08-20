application test

section functions

define page root() {
  init {
    goto firstPage(i);
  }
}

define page firstPage(i : Int) {
  text("Yeah")
}
