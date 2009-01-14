//Id annotation not allowed in session entities

application test

section datamodel

  session SuperUser {
    fullname :: String (id)
  }
