application test

  entity Bla {
    name :: String
  }

access control rules

  principal is Bla with credentials name

  rule page root(){
  	true
    rule action *(*){false}	
  }

section test
  
  define page root(){
    var t := "submitbuttoninpage"
    form{
      submit(t+1,red())
      submitlink(t+2,red())
      action(t+3,red())
      actionLink(t+4,red())
      submit red() { output(t+5) }
      submitlink red() { output(t+6) }

      submit(t+7,red())[ajax]
      submitlink(t+8,red())[ajax]
      action(t+9,red())[ajax]
      actionLink(t+10,red())[ajax]
      submit red()[ajax] { output(t+11) }
      submitlink red()[ajax] { output(t+12) }
    }
    action red(){}
  }
  
  test one {
    
    var d : WebDriver := FirefoxDriver();
    
    //root first submit button
    d.get(navigate(root()));
    assert(!(d.getPageSource().contains("404")), "root page may not produce a 404 error");
    assert(!(d.getPageSource().contains("submitbuttoninpage")), "no button should be visible");
    
    d.close();
  }
  

  