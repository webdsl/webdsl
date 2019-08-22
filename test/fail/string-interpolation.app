//#3 Expression in String interpolation must return a value

application test

page root {
  ~foo()
  "~foo()"
  var s := "~foo()"
}

function foo {}
