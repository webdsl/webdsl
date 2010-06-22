//rule should contain a Bool expression
application test

define page root() {
}

entity User{ name :: String }

principal is User with credentials name

access control rules

  rule page name()
  {
    //Int
    1+1
  }
