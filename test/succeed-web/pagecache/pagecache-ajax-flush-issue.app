application foo

page root(){
 placeholder p foo(p)
}

entity A {
 i : Int
 a:A
}
var a := A{ i := 1 }

ajax template foo( p: Placeholder ){
 for( x :A ){
div{    output(x.i) }
 }
 form{
   input( a.i )
   submit action{
  a.a :=  A{i:=213};
     replace( p, foo( p ) );
   }{ "go" }
 }
}

  test rendertemplatevariants{
  	var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    d.getSubmit().click();
    assert(d.getPageSource().contains("213"));
    d.get(navigate(root()));
  	assert(d.getPageSource().contains("213"));
  }