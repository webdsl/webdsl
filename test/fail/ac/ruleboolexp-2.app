//^rule should contain a Bool expression
application test


define page root() {
}

entity User{ name :: String }

principal is User with credentials name

access control rules

  rule page name()
  {
    //should just complain about the expression, but not about the rule not having a Bool check
    1+true-4543+"45trgrt"
  }
