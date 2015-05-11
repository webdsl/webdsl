application test

  page root(){
    var t1 := rendertemplate(something())
    var t2 := rendertemplate(output(globalsomething))

    output(t1)
    <br/>
    output(t2)
    <br/>
    testelems1{ "test-3" }
    <br/>
    testelems2{ "test-4" }
    <br/>
    output(rendertemplate(something5()))
    <br/>
    output(rendertemplate(output(globalsomething6)))
    <br/>
    output(rendertemplate(output("test-7")))
    <br/>
    bloglayout(Blog{name:="test-8"}){ "test-9" } 
    <br/>
    output(testfun1())
    <br/>
    output(testfun2())
    <br/>
    output(testfun3())
    <br/>
    testd()
    <br/>
    teste()
  }
  
  page unused(){
    something5
    rssLink
    tfun1
    output(TestEnt{})
  }
  
  template something(){
    "test-1"
  }
  entity Something{
    name : String
  }
  var globalsomething := Something{ name := "test-2" }

  
  template testelems1(){
    var s := rendertemplate(elements())
    output(s)
  }
  template testelems2(){
    output(rendertemplate(elements()))
  }
  
  template something5(){
    "test-5"
  }
  
  var globalsomething6 := Something{ name := "test-6" }
  
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
 
  template tfun1(){ "test-a"  } 
  function testfun1(): String{
    return rendertemplate(tfun1);	
  }
  
  var globaltestfun2 := Something{ name := "test-b" }
  function testfun2(): String{
    return rendertemplate(output(globaltestfun2));	
  }
  
  function testfun3(): String{
  	var a := "test-c";
    return rendertemplate(output(a));	
  }
  
  template testd(){
    var test := "test-"
    var d := "d"
    output(rendertemplate(showcontent(test){ output(d) } ))
  }
  template showcontent(a:String){
    output(a)
    elements
  }
  
  template teste(){
    var str := "test-e"
    output(globale)
    submit action{ globale.name := rendertemplate(showcontent(str)); } [class="testbtn"] {"click"}
  }
  var globale := Something{ name := "" }
  
  entity TestEnt{
  	url : String
  	title : String
  	
  	function getHtml() : String{
  		return rendertemplate(output(this));
  	}
  }
  
  template output(ent : TestEnt){
  	navigate( url(ent.url) ){ output(ent.title) }
  }
  test rendertemplatevariants {
  	var d : WebDriver := getFirefoxDriver();
	  d.get(navigate(root()));
    
    assert(d.getPageSource().contains("test-1"));
    assert(d.getPageSource().contains("test-2"));
    assert(d.getPageSource().contains("test-3"));
    assert(d.getPageSource().contains("test-4"));
    assert(d.getPageSource().contains("test-5"));
    assert(d.getPageSource().contains("test-6"));
    assert(d.getPageSource().contains("test-7"));
    assert(d.getPageSource().contains("test-8"));
    assert(d.getPageSource().contains("test-9"));
    assert(d.getPageSource().contains("test-a"));
    assert(d.getPageSource().contains("test-b"));
    assert(d.getPageSource().contains("test-c"));
    assert(d.getPageSource().contains("test-d"));
    d.findElement(SelectBy.className("testbtn")).click();
    assert(d.getPageSource().contains("teste"));
  }
  