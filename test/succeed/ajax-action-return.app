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
        inputtest(t)
      }
      submit("save return",action{return red();})
      submit("save return (ajax)",action{return red();})[ajax]
      submit("save refresh (ajax)",action{refresh();})[ajax]
      submit("save do nothing else (ajax)",action{refresh();})[ajax]
      actionLink("link",action{})
      actionLink("link (ajax)",action{refresh();})[ajax]
      
    }
  }
  
  define page red(){
    "redirected"
  }
  
  define inputtest(t:Test){
    input(t.prop)
  }

   