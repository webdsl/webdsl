// first button after placeholder with render as ajax call causes action lookup failure
// only happens if it is in the same template
// after enabling template inlining, this bug triggered more easily, because workaround of wrapping it in a simple template did not work anymore

application test

  page root(){
    placeholder ph noise()
    submit a1(){ "Button 1" }
    submit a2(){ "Button 2" }
    action a1(){
      goto test1();
    }
    action a2(){
      goto test2();
    }
  }
  
  page simplewrap(){
    placeholder ph noise()
    div{ submit a1(){ "Button 1" } }
    div{ submit a2(){ "Button 2" } }
    action a1(){
      goto test1();
    }
    action a2(){
      goto test2();
    }
  }
  
  ajax template noise(){
    <div>"123"</div>
  }
  
  page test1(){ "test1" }
  page test2(){ "test2" }  

  test{
    var d : WebDriver := getFirefoxDriver();
    
    d.get(navigate(root()));
    d.getSubmits()[0].click();
    assert(d.getPageSource().contains("test1"));

    d.get(navigate(root()));
    d.getSubmits()[1].click();
    assert(d.getPageSource().contains("test2"));
    
    // same test, with extra surrounding div, which would trigger the same bug when it is inlined
    
    d.get(navigate(simplewrap()));
    d.getSubmits()[0].click();
    assert(d.getPageSource().contains("test1"));

    d.get(navigate(simplewrap()));
    d.getSubmits()[1].click();
    assert(d.getPageSource().contains("test2"));
  }
  