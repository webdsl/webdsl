application test

section functions

define page root() {
  init {
    goto firstPage(7);
  }
}

define page firstPage(i : Int) {
  text("Yeah")
}
