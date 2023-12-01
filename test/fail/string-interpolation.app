//#2 Expression in String interpolation must return a value

application test

page root {
  ~foo()  // output call is skipped with no output
  "~foo()"
  var s := "~foo()"
}

function foo {}
