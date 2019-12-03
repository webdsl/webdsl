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
  
  var u1 : User := User { name := "the user" };
  var p1 : PdpMeeting := PdpMeeting { employee := u1 };
  
  define page root() {
    output(u1.name)
    output(p1.name)
    output(p1.name2)
    output(p1.name3())
    
  } 
