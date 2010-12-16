module templates

define main() {
  <div id="pagewrapper">
     <div id="header">
        mainheader()
     </div>
     <div id="navbar">
       applicationmenu()
     </div>
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

define applicationmenu() {
  <ul>
    <li>navigate(root()){"Home"}</li>
    <li>navigate(managePerson()){ "Manage Person" }</li>
  </ul>
}
 
define ignore-access-control errorTemplateInput(messages : List<String>){
  validatedInput
  for(ve: String in messages){
    <tr style = "color: #FF0000;border: 1px solid #FF0000;">
      <td></td>
      <td> 
        output(ve)
      </td>
    </tr>
  }
}
 