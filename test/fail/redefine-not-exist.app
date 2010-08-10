//Local template redefinition requires a template with signature

application test

  entity TestEntity{
    name :: String
  }

  define page root() {
    var i := "1"
    form{
      b(i,54)
      submit action{ TestEntity{ name := i }.save(); } {"save"}
    }
    
    for(t:TestEntity){
      output(t.name)
    }
    
    define b(s:String,i:Int) = a
  }

  //define a(s:String,i:Int){output(s+i)}
  define b(s:String,i:Int){output(""+i+s)}
  
