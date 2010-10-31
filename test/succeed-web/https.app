application testhttps

  define page root(){
    navigate bla()[secure]{ "go to secure https" }
    <br />
    navigate bla(){ "stay in same protocol" }
    <br />
    navigate secure(){ "always secure, even without secure modifier" }
    <br />
    navigate notsecure(){ "never secure, even without not-secure modifier" }
    <br />
    
    form [secure]{
      input(test.i)
      submit action{ } { "save https mode" }
    }
    form [not-secure]{
      input(test.i)
      submit action{ } { "save http mode" }
    }
    form {
      input(test.i)
      submit action{ } { "save same mode" }
    }
    <br />
    navigate login() { "loginpage" }
    
  }
    
  define not-secure page login(){  
    form [secure]{
      submit action{ sestest.loggedin := test; } { "login" }
      submit action{ sestest.loggedin := null; } { "logout" }
    }
    print(sestest.loggedin.i)
    navigate root() {"root"}
  }
  
  define print(o:Object){
    output(""+o)
  }

  define page bla(){
    "bla"
    navigate root()[not-secure]{ "go to regular http" }
    <br />
    navigate root(){ "stay in same protocol" }
    
  }
  
  define secure page secure(){
    "secure"
  }
  
  define not-secure page notsecure(){
    "not secure"
  }
  
  var test := Test {}
  
  entity Test{
    i :: Int
  }
  
  session sestest{
    loggedin -> Test
  }
  
  
  //https mod on page -> submits inside page should all be https (automatic for relative urls in browser)
  //explicit https template attribute on navigate/navigatebutton/submit/submitlink
  //actually, form needs to be [secure], for regular submits the link is in the form action
  //TODO ajax + https will require some more work
  
  //navigate to page with secure mod is desugared to navigate with secure template call attribute
  
  //secure/not-secure forces to go to one or other but otherwise stay in same mode
  
  //convert wizard should copy .keystore and server.xml
  
  //need setting for both http and https port
  //defaults ports should be 80 and 443
  
  //there seems to be an issue when the user accesses an https page first, 
  //at that point the cookie gets created with secure property and wont be used when switching to http
  
  //update to java EE 6
  /*
        String sessionid = request.getSession().getId();
      Cookie cookie = new Cookie("JSESSIONID", sessionid);
      cookie.setSecure(false);
      cookie.
      response.setHeader("SET-COOKIE", "JSESSIONID=" + sessionid + "; HttpOnly");
  */
  
  