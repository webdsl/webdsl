application test

  define email testemail(to:String,from:String,subject:String) {
    to(to)
    from(from)
    subject(subject)
     
    div{
      "123"
    }
    foo() with{
      bar(s:String){ "5" output(s) }
    }
    //tmp()
    //define tmp(){ "7" }
  }
  
  define tmp(){
    "error"
  }
  
  define foo() requires bar(String){
    "4"
    bar("6")
  }
  
  define page root() {

  }

  test emailfail {
    
    var e := renderemail(testemail("1","2","3"));
    assert(e.body=="<div>123</div>456");
    
  }