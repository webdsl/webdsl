//error: No function or page 'test' with this signature
application test

  function do() {
    var a := test(); //shouldn't break rename phase
    
  }
