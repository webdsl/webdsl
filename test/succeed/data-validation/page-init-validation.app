application labelinput

  //warning about validation fail in init should be shown in the log
  
  entity User {
    name :: String (validate(name.length() > 2,"Name should be longer than 2 characters."))
  }
  
  define page root() {
    init{
      var u := User { name := "a" };
    }

    "thepage"
    
  }
  
  define page home(){
    navigate(test(1,"abc")){"test"}
  }
  
  define page test(i:Int, s:String) {
    init{
      var u := User { name := "a" };
    }

    "thepage"
    
  }
 
