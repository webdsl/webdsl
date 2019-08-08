application test

page root() {
  testtemplate
}

entity Tmp {
  name : String
  i : Int
  n : Tmp
  function get(): String {
    return name;
  }
  function interpInEntity(): String{
    return "~i~this.i~n~this.n~this.n.n~get()~this.get()";
  }
  derived : String := "~i~this.i~n~this.n~this.n.n~get()~this.get()"
  function navfun: String {
  log(navigate( navfun( this ) ));
    return "~navigate( navfun( this ) )";
  }
}

var t1 := Tmp { name := "t1" i := 1 }

template testtemplate() {
  var n : String := null
  var n1 : Tmp := null

  "[no-interp]"
  "~t1.name"
  "bla~(t1.name).foo"
  "~t1.i\~escape\\\\\~"
  
  output( "[no-interp]" )
  output( "~t1.name" )
  output( "bla~(t1.name).foo" )
  output( "~t1.i\~" )
  
  ~t1.name
  ~(t1.name)
  ~t1.i
  
  // null
  "test[~n~t1.n~n1.n]"
  output( "test[~n~t1.n~n1.n]" )

  ~n
  ~t1.n
  ~n1.n
  ~testfun()
  ~broken()

  output( t1.interpInEntity() )
  output( t1.derived )
  
  wrapper1(){ 
    "~n1.name" //bug: String interpolation in elements of call causes javac error: non-static variable n1_ cannot be referenced from a static context
  }
  
  javaclassrefs
  "~t1.navfun()"
}
template wrapper1(){
  "wrapper1[" elements "]"
}
template wrapper2(s : String){
  "~s"
}

function testfun(): String{
  var a := 1;
  var b := "2";
  return "test~a~b";
}

function broken(): String{
  var tmp : Tmp := null;
  return "~tmp.n";
}

template javaclassrefs {
  "~StringFunction.format( "%.02f", 0.12345f )"
}
native class java.lang.String as StringFunction { 
  static format(String, Float): String
}

page navfun( t: Tmp ){}

test {
  log( rendertemplate( testtemplate() ));
  assert( rendertemplate( testtemplate() ) == "[no-interp]t1blat1.foo1\~escape\\\\\~[no-interp]t1blat1.foo1\~t1t11test[]test[]test1211t1t111t1t1wrapper1[]0.12" + navigate( navfun( t1 ) ) );
  assert( rendertemplate( wrapper2("hey") ) == "hey" );
}
