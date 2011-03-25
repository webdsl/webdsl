application test

section bla
  
  function show():String{
    
    var s1:String := "";
    var s2:Secret := "";
    var s3:WikiText := "";
    var s4:Text := "";
    
    s1:=s2;
    s1:=s3;
    s1:=s4;
    
    s2:=s1;
    //s2:=s3;
    //s2:=s4;
    
    s3:=s1;
    //s3:=s2;
    //s3:=s4;
    
    s4:=s1;
    //s4:=s2;
    //s4:=s3;
    
   
    return "jdsfkljslfsd";
  }
  
  define page root(){
    output(show())

  }
