application test

  entity Test {
    prop :: String
    prop1 :: Text
  }
  
  var t_1 := Test{ prop := "werwrwergdgdgrgrg" }  
  
  define page root(){
    output(t_1.prop)
    output(t_1.prop1)
    form{
      input(t_1.prop)
      input(t_1.prop1)
      action("save",action{})
    }
  }

  type String { 
    validate(this.length() >= 10 , "input too short (minimum is 10 characters)") 
  }
