application root

  override attributes navigate {
    class = "navclass"
    style = "navstyle"
    navbar = "navbar"
    navbar2 = "navbar2"
  }
  override attributes downloadlink{ 
    class = "navclass"
    style = "navstyle"
    navbar = "navbar"
    navbar2 = "navbar2"
  }
  override attributes outputimage{ 
    class = "navclass"
    style = "navstyle"
    navbar = "navbar"
    navbar2 = "navbar2"
  }
  override attributes submit{ 
    class = "navclass"
    style = "navstyle"
    navbar = "navbar"
    navbar2 = "navbar2"
  }
  override attributes submitlink{
    class = "navclass"
    style = "navstyle"
    navbar = "navbar"
    navbar2 = "navbar2"
  }
  override attributes form{
    class = "navclass"
    style = "navstyle"
    navbar = "navbar"
    navbar2 = "navbar2"
  }
  override attributes navigatebutton{ 
    class = "navclass"
    style = "navstyle"
    navbar = "navbar"
    navbar2 = "navbar2"
  }
  override attributes captcha{ 
    class = "navclass"
    style = "navstyle"
    navbar = "navbar"
    navbar2 = "navbar2"
  }
  override attributes image{    
    class = "navclass"
    style = "navstyle"
    navbar = "navbar"
    navbar2 = "navbar2"
  }
  override attributes inputInt{
    class = "navclass"
    style = "navstyle"
    navbar = "navbar"
    navbar2 = "navbar2"
  }  

  template attrs(){
    var i := 0
    form{
      downloadlink action{} {"123"}
      outputimage action{} {"123"}
      input(i)
      submit action{} {"123"}
      submit action{} {"123"}
      submitlink action{} {"123"}
      submitlink action{} {"123"}
    }
    captcha
    var s := "url"
    image(s)
    image("test")
    image("http://webdsl.org")
    navigate url("root"){"123"}
    navigate root(){"123"}
    navigatebutton(root(),"123")
    navigatebutton(url("root"),"123")
  }
  
  test{
    var source := rendertemplate(attrs());
    log(source);
    assert(source.split(" class=\"navclass\"").length == 17);
    assert(source.split(" style=\"navstyle\"").length == 17);
    assert(source.split(" navbar=\"navbar\"").length == 17);
    assert(source.split(" navbar2=\"navbar2\"").length == 17);
  }

  page root(){}
