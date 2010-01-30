application entitysetinverseprop

entity A {
  f -> B 
  function foo() {
    f := B{}; 
  }
}

entity B {
  g -> A (inverse=A.f)
  function bar() {
    g := A{};
  }
}

define page root() { }

test one {
  var a := A{};
  a.foo();
  assert(a.f.g == a);
}
test two {
  var b := B{};
  b.bar();
  assert(b.g.f == b);
}
