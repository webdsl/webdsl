//Only one access control principal can be defined

application test

define page root() {
}

entity User {
	name :: String
}

section principal

  principal is User with credentials name

  principal is User with credentials name
  