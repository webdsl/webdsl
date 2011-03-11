module test2

entity User {
	name :: String
}

// -- START ONLY 2 --

principal is User with credentials name

access control rules 

  // Exact match
  rule page root() { "bla" == "sja" }

  // Wildcard match
  rule page *() { "xxx"=="yyy" }

  // Partial wildcard match
  rule page roo*(*) { "abc"=="def"}

// -- END ONLY 2 --

