module templates

define main() {
  <div id="pagewrapper">
     <div id="header">
        mainheader()
     </div>
     <div id="navbar">
       applicationmenu()
     </div><br/>
     <div id="content">
       body()
     </div>
     <div id="footer">
       <p />"powered by " <a href="http://webdsl.org">"WebDSL"</a><p />
     </div>
  </div>
}

define body(){
  "default body"
}

define mainheader() {
  navigate(root()){
    image("/images/logosmall.png")
  }
}

define title(s : String) {
  output(s)
}

define applicationmenu() {
  <ul>
    <li>navigate(root()){"Home"}</li>
    if(loggedIn())
      {
	    <li>actionLink("Logout", logout())</li>
     } else {
        <li>navigate(login("")){ "login" }  </li>   
        <li>navigate(register("")){ "register" } </li>
     }   
  </ul>
        action logout(){
          securityContext.principal := null;
          return root();
        }
}


 
define ignore-access-control errorTemplateInput(messages : List<String>){
  validatedInput
  for(ve: String in messages){
    row[style := "color: #FF0000;border: 1px solid #FF0000;"]{
      column{}
      column{ 
        output(ve)
      }
    }
  }
}
 