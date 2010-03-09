//This element is not allowed to be nested in other template elements

application test

  entity Task {
    description    :: String
  }
  
  define page root()
  {
    for(t:Task){
      form {
        input(t.description)
        submit change() {"change"}
        action change() {
          t.save();
        }
      }
    }
  }
