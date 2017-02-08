application test

page root(){}

entity Ent {
  i : String
}

function a( e: Ent ): Bool {
  return e is a Ent;
}

test {
  assert( null is a Ent == false );
  assert( a( null as Ent ) == false );
}
