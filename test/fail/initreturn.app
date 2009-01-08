// An init block can not contain a return statement

application test

section functions

define page home(i : Int) {
  init {
    return nonexistent(i);
  }
}
