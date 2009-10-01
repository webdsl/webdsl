//The format string "mm.d/" is not allowed for Date types

application test

  entity Test {
    prop :: Date (format = "mm.d/")
    prop1 :: Date
  }
  
  var t_1 := Test{ }  
  
  define page root(){
    output(t_1.prop)
    form{
      input(t_1.prop)
      action("save",action{})
    }
  }

