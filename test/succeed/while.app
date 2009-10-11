application test

  entity Result{
    number :: Int
    result :: Int
  }
  
  var globalresult := Result{ number := 1 result := 1 }
  
  define page root(){
    var r := globalresult  
  
    output(r.number)
    "!  =  "
    output(r.result)
    
    form{
      label("factorial: "){
        input(r.number){ validate(r.number > 0 && r.number < 13,"enter a value between 0 and 13") }
      }
      action("calc",calc())
    }  
    
    action calc(){
      r.result := 1;
      var i := r.number;
      while(i > 0){
        r.result := r.result * i;
        i := i - 1;
      }
    }
  }
  
  test intcount {
    var i := 5;
    while(i<10){
      i := i + 1;
    }
    assert(i == 10);
  }
  
  test list {
    var list := ["123","123","123"];
    var i := 0;
    while(i < list.length){
      assert(list.get(i) == "123");
      i := i + 1;
    }
  }
  
  test string {
    var s := "q23ef";
    while(s != "abc"){
      s := "abc";
    }
    assert(true);
  }

  