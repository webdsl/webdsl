application entitysetinverseprop

entity A {
  f -> B 
  function foo() {
    f := B{}; 
  }
}

entity B {
  g -> A (inverse=A.f)
}

define page root() { }

test one {
  var a := A{};
  a.foo();
  assert(a.f.g == a);
}
