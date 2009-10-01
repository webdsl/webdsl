application test

  entity Test {
    prop :: Date (format = "mm.dd.yyyy")
    prop1 :: Date
  }
  
  var t_1 := Test{ }  
  
  define page root(){
    output(t_1.prop)
    form{
      input(t_1.prop)
      action("save",action{})
    }
    
    break
    
    output(t_1.prop1)
    form{
      input(t_1.prop1)
      action("save",action{})
    }
  }

  type Date { 
    format = "dd-mm-yyyy"
  }
  
