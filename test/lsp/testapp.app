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
}
