application test

entity Letter {
  char : String (name)
}

var letterA := Letter{ char := "a" }

page root {
  dark

  request var prefix := letterA

  init {
    log( "init: " + prefix );  // bug: request var is null during init
  }

  form {
    submitlink action{ log( "action: " + prefix );}{ "click" }
  }

  ~prefix

  submitlink action{ replace( ph ); }{ "refresh" }
  placeholder ph { }
}



template dark{ <style>body { background-color: black; color: silver; }</style> }
