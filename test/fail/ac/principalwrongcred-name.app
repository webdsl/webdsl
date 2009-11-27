//Principal credential type 'User' does not have a 'name' property, a property with 'name' annotation is not sufficient for use as credential.

application test

section principal

entity User{
  username :: String (name)
}

principal is User with credentials name

define page root(){}