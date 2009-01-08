//not defined

//this check is not really necessary anymore, see variablenotdefined.app

application test

entity User{name :: String}

principal is User with credentials name

access control rules

  rule page name(a:Bool)
  {
    a && b
  }