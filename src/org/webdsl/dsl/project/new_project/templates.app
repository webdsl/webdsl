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
    /* clear and push help to prevent footer from overlapping content when resizing */
    <div id="clear"></div>
    <div id="push"></div>
  </div>
  <div id="footer">
    <span id="footercontent">"powered by " <a href="http://webdsl.org">"WebDSL"</a></span>
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
  navbaritem{ navigate(root()){"Home"} }
  navbaritem{ navigate(managePerson()){ "Manage Person" } }
}

define navbaritem(){
  <span class="navbaritem">
    elements()
  </span>
}

//validation template override
 
define override errorTemplateInput(messages : List<String>){
  elements()
  for(ve: String in messages){
    <tr style = "color: #FF0000;border: 1px solid #FF0000;">
      <td></td>
      <td> 
        output(ve)
      </td>
    </tr>
  }
}
 