// employee, no such property name

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
    name :: String := employee.name + " PDP Form"
  }