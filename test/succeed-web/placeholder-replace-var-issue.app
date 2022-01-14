application test

var globalf := Foo1{ ref := Foo2{} }

page root {
  placeholder x {
    tmp( globalf.ref, x )
  }
}

template tmp( f: Foo1, x: Placeholder ){
  typecase( f as foo ){
    Foo3 { "Foo3" }
    Foo2 { "Foo2" }
    Foo1 { "Foo1" }
    default { "Foo4" }
  }
  submitlink action{ globalf.ref := Foo3{}; replace( x ); }{ "reload" }
}

entity Foo1 { ref : Foo1 }
entity Foo2 : Foo1 {}
entity Foo3 : Foo2 {}

test {
  var d: WebDriver := getFirefoxDriver();
  d.get( navigate( root() ) );
  assert( d.getPageSource().contains( "Foo2" ) );
  d.getSubmit().click();
  assert( d.getPageSource().contains( "Foo3" ) );
}
