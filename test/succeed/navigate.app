application test

section datamodel

  entity Link{
    url :: URL

  }
  
  var l : Link := Link { url := "http://webdsl.org" };
  
  define page home(){
    
    output(l.url)
    
    navigate(testpage(45,"bla",l)){"link to testpage"} 
    
    form{
      inputURL(l.url)
      action(save(),"save")
    }
    form{
      input(l.url)
      action(save(),"save")
    }
    action save()
    {
      l.save();
    }

  }
  
  define page testpage(i:Int,s:String,li:Link)
  {
    output(i)
    output(s)
    output(li.url)
  
  }


