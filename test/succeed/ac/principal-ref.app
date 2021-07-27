application test

page root {
  tmp
}

template tmp {
  init {
    principal := testUser;
  }
  "selected: ~principal.name templateid: ~id"
  output( principal.name )
  "-"
  output( "~principal.name" )
  "-"
}

test {
  var result := rendertemplate( tmp() );
  log( result );
  assert( result.split( testUser.name ).length == 4 );
}

entity MyUser {
  name : String
  pass : Secret
}

var testUser := MyUser { name := "testUser123" }

principal is MyUser with credentials name, pass

access control rules
  rule page root { true }
