application test

section datamodel

  entity Link{
    url :: URL

  }
  
  var l : Link := Link { url := "http://webdsl.org" };
  
  define page home(){
    
    output(l.url)
    
    navigate(testpage(45,"bla",l)){"link to testpage"} 
    
    navigate("link to testpage", testpage(45,"bla",l)) //sugar for button, syntax like action button
       
    navigatebutton(testpage(45,"bla",l),"link to testpage") 
    
    form{
      inputURL(l.url)
      action("save",save())
    }
    form{
      input(l.url)
      action("save",save())
    }
    action save()
    {
      l.save();
    }
    
    
    form{
      action("test action return",save2())
    }
    action save2()
    {
      return testpage(43,"bla1",l);
    }
    
    
    navigate(home2("bla2",l,42)){"test redirect"} 

  }
  
  define page testpage(i:Int,s:String,li:Link)
  {
    output(i)
    output(s)
    output(li.url)
  
  }

  define page home2(s:String,li:Link,i:Int)
  {
    init{
      goto testpage(i,s,li);
    }
  }
