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
  }