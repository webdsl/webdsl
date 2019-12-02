// error: The field A.b is a derived property

application test

page root {}

entity A {
  b : B := B{}
}
entity B {
  a : A (inverse=b)
}