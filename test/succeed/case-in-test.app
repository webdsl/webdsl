application test

page root {}

test {
  case( "" ){
    "" { assert( true ); }
  }
}

entity Ent {}
entity Sub1 : Ent {}

test {
  var e: Ent := Sub1{};
  typecase( e ){
    Sub1 { assert( true ); }
    Ent  { assert( false ); }
  }
}
