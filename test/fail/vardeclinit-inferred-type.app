//No function
//#2 Expression has invalid type for variable declaration

application test

  function do() {
    var a := test(); //shouldn't break rename phase
    var b := String;
    var b := Foo;
    
  }
  
  entity Foo{}
