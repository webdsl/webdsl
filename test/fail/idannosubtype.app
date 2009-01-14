//Id annotation not allowed in subtypes

application test

section datamodel

  entity SuperUser {
    fullname :: String
  }
  entity User : SuperUser {
    name :: String (id)
  }
