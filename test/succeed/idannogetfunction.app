application test

  entity Alias{
    key :: String(id)
  }

  var a1 := Alias { key := "Alice" }
  var a2 := Alias { key := "Bob" }
  
  define page root(){
    for(alias:Alias){
      navigate(profile(alias.key)){ output(alias.key) }
      
      form{
        input(alias.key)
        action("save",action{})
      }
    }
  }

  define page profile(s:String){
    output(s)
    
    form{
      action("find",find())
    }
    action find(){
     
      validate(findAlias(s)!= null,"cannot find alias");
    }
  }
