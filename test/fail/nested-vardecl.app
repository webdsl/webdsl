//#3 This element is not allowed to be nested in other template elements

application test

  entity Task {
    description    :: String
  }
  
  define page root()
  {
    for(t:Task){
      form {
        var u0 : Task
        var u1 : Task := Task{}
        var u2 := Task{}
      }
    }
  }
  