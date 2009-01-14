//Only one id annotation allowed in an entity

application test

section datamodel

  entity SuperUser {
    fullname :: String (id)
    name :: String (id)
  }
