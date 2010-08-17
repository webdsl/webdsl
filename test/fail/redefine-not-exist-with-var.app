//Local template redefinition requires a template with signature

application test

  entity TestEntity{
    name :: String
  }

  define page root() {
    var i := "dfdfgfdg"
    define b(s:String,i:Int) = a(*,i)
  }

  define a(s:String,i:Int){output(s+i)}
  define b(s:String,i:Int){output(""+i+s)}
  
