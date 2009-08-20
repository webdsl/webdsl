application test

entity User { name :: String }

  function do():User {
    var a := 3;
    var b := User{name := "user 1"};
    
    a := a + a;
    return b;
    
  }

  define page root() {

  }
