application entitysetinverseprop

entity A {
  f -> B 
  function foo() {
    f := B{}; 
  }
  function foo2() {
    this.f := B{}; 
  }
}

entity B {
  g -> A (inverse=A.f)
  function bar() {
    g := A{};
  }
  function bar2() {
    this.g := A{};
  }
}

define page root() { }

test one {
  var a := A{};
  a.foo();
  assert(a.f.g == a);
}
test two {
  var a := A{};
  a.foo2();
  assert(a.f.g == a);
}
test three {
  var b := B{};
  b.bar();
  assert(b.g.f == b);
}
test four {
  var b := B{};
  b.bar2();
  assert(b.g.f == b);
}
