// run:  ab -c 10 -n 100 localhost:8080/test-session/
// should not cause  ERROR exception message: illegally attempted to associate a proxy with two open Sessions

application test

  page root(){
    init{
      securityContext.principal := u1;
    }
    output(principal())
    /*
    init{
      u1.name := u1.name +"1";
    }
    output(u1.name)
    */
 }
 
  var u1 := User{ name := "123" }
  
  entity User{  name : String }
 
  principal is User with credentials name
  
  function principal():User{
    return securityContext.principal;
  }
  
  access control rules
    rule page root(){true}
  
  