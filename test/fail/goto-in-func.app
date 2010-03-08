//Goto can only be used inside an action

application test

section functions

function x() {
	goto otherPage();
}

define page root() {
  init {
    goto otherPage();
  }
  
}


define page otherPage() { }