//no page with signature

application test

section functions

define page home(i : Int) {
  init {
    goto nonexistent(i);
  }
}
