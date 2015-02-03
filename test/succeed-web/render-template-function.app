application test

  define page root(){
    rawoutput( rendertemplate( output(c1) ) )
    submit action {init();}{ "cache user output" }    
    submit action {c1.enableInvoke := true;}{ "enable invoke" }    
  }
  
  define no-span output(u:User){
    <span class="user-output">
      <b>output(u.name)</b>
      <i>output(u.address)</i>
    </span>
  }
  
  entity User{
    name :: String
    address :: String
  }
  
  var u1 := User{name:="userfirst" address:="address"}
  var u2 := User{name:="usersecond" address:="address2"}
  var c1 := CachedUserOutput{}

  function init(){
      c1.name := rendertemplate(output(u1));   
  }
  
  function init2(){
    if(c1.enableInvoke){
      c1.name := rendertemplate(output(u2));   
    }
  }
  
  entity CachedUserOutput{
    name :: String
    enableInvoke :: Bool
  }
  
  invoke init2() every 3 seconds
    
  test buttonclick {
    
    var d : WebDriver := getFirefoxDriver();
    d.get(navigate(root()));
    
    d.getSubmits()[0].click();
       
    assert(d.getPageSource().contains("userfirst"), "output of first cached template not found");
           
    d.getSubmits()[1].click();
    
    sleep(6000);
    
    d.get(navigate(root()));    
    assert(d.getPageSource().contains("usersecond"), "output of second cached template not found");
  }
