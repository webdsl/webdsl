application test

imports imported

page root {
  templatedef tcallnotdefined
  templatedefimported
}

template templatedef {}

template example( key: String ){}
template example( num: Int ){}

function functioncalls {
  functioncalls();
  one( "", one( 1, 2 ) ); functioncalls();
  one( 2, 1 );
  testnotdefined();
}
function one( a: String, i: Int ){}
function one( j: Int, i: Int ): Int { return 1; }

entity User {
  function two( s: String ){}
  function two( i: Int, s: String ): String { return ""; }
  function two( b: Bool ): String { return ""; }
  function calls {
    var u := User{};
    u.two( u.two( 3, "1" ) ); u.two( true );
    u.two( 3, "1" );
  }
  function one( a: String, i: Int ){}  // overlaps with global function
  function thiscalls {
    two( "2" );
    one( "", 2 );
    this.two( 5, "" );
    morecalls();
  }
}
extend entity User {
  function morecalls {
    two( "" );
    morecalls();
  }
}

function vars( arg: String ){
  var abc := "";
  log( abc + arg );
}

var globaluser := User{}
request var requestscoped := ""

function morevars {
  log( globaluser.name + "!" );
  log( requestscoped.toString() );
  log( usersession.s );
}

session usersession { s : String }

function unresolved_var_completion( arg1: Int ){
  aaa;
}

extend entity User {
  function complete_entity_functions {
    aaa;
  }
  userprop : String
  derived : Int
}
entity SubUser : User {
  subprop : Bool
  subderived : User
}
function resolve_field_access {
  User{}.userprop;
  SubUser{}.userprop;
  SubUser{}.subprop;
  User{}.derived;
  SubUser{}.derived;
  SubUser{}.subderived;
}

function entity_prop_assign( s: String ){
  SubUser {
    userprop := s
    subprop := false
  };
}

page testpage( b: Bool, i: Int ){}
email testemail( b: Bool ){ from("") to("") subject("") }

template navigates {  // unused template should not get skipped when doing lsp analysis
  navigate testpage( false, 0 ){ "testpage" }
  navigate root { "root" }
  action send { email testemail( false ); }
}

template find_references {
  navigate testpage( true, 123 ){ "test 123" }
  navigate testpage( false, 456 ){ "test 456" }
}

template testwithargs( user: User, s1: String, t: Int){}
template inlay_hints {
  testwithargs( User{}, "", 123 )
  testwithargs( (from User)[0], "s", 456 )
}

function entity_incomplete_prop_assign( s: String ){
  SubUser {
    userprop
  };
}

function objectcreations {
  User{}.userprop;
  SubUser{};
}

