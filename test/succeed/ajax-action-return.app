application test

  entity Test {
    prop :: Bool
  }
  
  var t1 := Test { }
  var t2 := Test { }
  var t3 := Test { }
  var t4 := Test { }
  
  define page root() {
    for(t:Test){
      output(t.prop)
    }
    
    form{
      for(t:Test){
        in(t)
      }
      action("save return",action{return red();})
      action("save refresh",action{refresh();})
    }
  }
  
  define page red(){
    "redirected"
  }
  
  define in(t:Test){
    input(t.prop)
  }

   