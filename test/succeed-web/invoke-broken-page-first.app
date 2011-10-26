// regression test, invoking a broken page first should not break global var and init (resulting in failed deployment)

application test

  entity Foo:Bar{ s :: String}
  entity Bar{}
  
  define page broken(){
    init{
      var a := Bar{} as Foo; //invalid cast, causes the transaction to abort, should not interfere with global init
    }	
  }
  
  var globalFoo := Foo {
   s := "1234" 
  }
  
  init{
    globalFoo.s := globalFoo.s + "56789";
  }
  
  define page root(){
    output(globalFoo.s)
  }

  test {
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(broken()));
    d.get(navigate(root()));
    assert(d.getPageSource().contains(globalFoo.s),"global not properly initialized");
  }
  

  