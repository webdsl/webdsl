application test

entity Test {
 s: String (validate( s.length() > 0, ">0" ) )
}
var t1 := Test{}

page root{
  dark

  placeholder y {
    form {
      input( t1.s )
      submitlink action{ t1.s := t1.s + "!"; replace( y ); }{ "Broken 1" }
    }
  }
  // in firefox form data cached: renders without the !, need to do hard refresh or open page in new tab to show the !
  // chrome works as expected
  // https://superuser.com/questions/252993/how-to-disable-form-value-persistence-on-page-reload-for-firefox


  // suggested workaround: disable autocomplete, does not fix it
  placeholder x {
    form [ autocomplete="off" ]{  // still requires soft refresh to show the !
      input( t1.s )
      submitlink action{ t1.s := t1.s + "!"; replace( x ); }{ "Broken 2" }
    }
  }

}



template dark{ <style>body { background-color: black; color: silver; }</style> }
