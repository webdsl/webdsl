application test

  page root(){
    var t1 := rendertemplate(something())
    var t2 := rendertemplate(output(globalsomething))

    output(t1)
    <br/>
    output(t2)
    <br/>
    testelems1{ "test3" }
    <br/>
    testelems2{ "test4" }
    <br/>
    output(rendertemplate(something5()))
    <br/>
    output(rendertemplate(output(globalsomething6)))
    <br/>
    output(rendertemplate(output("test7")))
    <br/>
    bloglayout(Blog{name:="test8"}){ "test9" } 
    <br/>
    output(testfun1())
    <br/>
    output(testfun2())
    <br/>
    output(testfun3())
  }
  
  template something(){
    "test1"
  }
  entity Something{
    name : String
  }
  var globalsomething := Something{ name := "test2" }

  
  template testelems1(){
    var s := rendertemplate(elements())
    output(s)
  }
  template testelems2(){
    output(rendertemplate(elements()))
  }
  
  template something5(){
    "test5"
  }
  
  var globalsomething6 := Something{ name := "test6" }
  
  entity Blog { name : String }
  template main() {
    output(rendertemplate(rssLink()))
    elements
  }
  template rssLink() { "ERROR" }
  template bloglayout(b: Blog) {  
    define rssLink() {
      output(b)
    }
    main{
    	<br/>
      elements
    }
  }
 
  template tfun1(){ "testa"  } 
  function testfun1(): String{
    return rendertemplate(tfun1);	
  }
  
  var globaltestfun2 := Something{ name := "testb" }
  function testfun2(): String{
    return rendertemplate(output(globaltestfun2));	
  }
  
  function testfun3(): String{
  	var a := "testc";
    return rendertemplate(output(a));	
  }
  
  test rendertemplatevariants {
  	var d : WebDriver := getFirefoxDriver();
	  d.get(navigate(root()));
    
    assert(d.getPageSource().contains("test1"));
    assert(d.getPageSource().contains("test2"));
    assert(d.getPageSource().contains("test3"));
    assert(d.getPageSource().contains("test4"));
    assert(d.getPageSource().contains("test5"));
    assert(d.getPageSource().contains("test6"));
    assert(d.getPageSource().contains("test7"));
    assert(d.getPageSource().contains("test8"));
    assert(d.getPageSource().contains("test9"));
    assert(d.getPageSource().contains("testa"));
    assert(d.getPageSource().contains("testb"));
    assert(d.getPageSource().contains("testc"));
  }
  