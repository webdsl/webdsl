//rule type unknown

application test

entity User{name :: String}

principal is User with credentials name

access control rules

  rule pag name()
  {
    true
  }
  
  