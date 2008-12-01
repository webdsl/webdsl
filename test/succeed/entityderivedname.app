application test

section datamodel

  entity User {
    username :: String
    name     :: String
    password :: Secret
    manager  -> User
  }

  entity PdpMeeting {
    employee -> User
    name :: String := this.employee.name + " PDP Form"
    name2 :: String := employee.name
    
    function name3():String {
      return employee.name;
    }
  }
  
  var u : User := User { name := "the user" };
  var p : PdpMeeting := PdpMeeting { employee := u };
  
  define page home() {
    output(u.name)
    output(p.name)
    output(p.name2)
    output(p.name3())
    
  } 