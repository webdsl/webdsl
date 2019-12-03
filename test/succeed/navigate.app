application test

section datamodel

  entity Link{
    url :: URL

  }
  
  var globalLink : Link := Link { url := "http://webdsl.org" };
  
  define page root(){
    
    output(globalLink.url)
    
    navigate(testpage(45,"bla",globalLink)){"link to testpage"} 
    navigate testpage(45,"bla",globalLink) {"link to testpage"} 
    
    navigate("link to testpage", testpage(45,"bla",globalLink)) //sugar for button, syntax like action button
       
    navigatebutton(testpage(45,"bla",globalLink),"link to testpage") 
    
    form{
      input(globalLink.url)
      action("save",save())
    }
    form{
      input(globalLink.url)
      action("save",save())
    }
    action save()
    {
      globalLink.save();
    }
    
    
    form{
      action("test action return",save2())
    }
    action save2()
    {
      return testpage(43,"bla1",globalLink);
    }
    
    
    navigate(home2("bla2",globalLink,42)){"test redirect"} 
    navigate(root()){"root"}
    navigate(testpagenoarg()){"testpagenoarg"}

  }

  define page testpagenoarg(){
  
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

  
  var u1 := User{ name := "testuser"};

  define page root2(){
    navigate(test(u1,"")){"test"}
    navigate(test1(u1,"",0)){"test1"}
    navigate(test2(0,"",u1)){"test2"}
    navigate(test3(0,u1,"")){"test3"}
    navigate(test4(0,u1,"",0.0)){"test4"}
    navigate(root()){"root"}
    navigate(with-dash()){"test5"}
    navigate with-dash(){"test6"}
  }
  
  entity User {
    name :: String
  }
  
  define page test(u:User, s:String){
    output(u.name)
    output(s)
  }
  
  define page test1(u:User, s:String, i:Int){
    output(u.name)
    output(s)
    output(i)
  }
  
  define page test2(i:Int,s:String, u:User){
    output(u.name)
    output(s)
    output(i)
  }

  define page test3(i:Int, u:User,s:String){
    output(u.name)
    output(s)
    output(i)
  }
  
  define page test4(i:Int, u:User,s:String,f:Float){
    output(u.name)
    output(s)
    output(i)
  }
  
  define override page pagenotfound(){
   "PAGE NOT FOUND :/"
  }

  page with-dash(){
  	
  }