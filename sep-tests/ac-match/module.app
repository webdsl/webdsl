module test2

entity User {
	name :: String
}

principal is User with credentials name



-- START ONLY 2 --

access control rules 

  // Exact match
  rule page root() { "bla" == "sja" }

  // Wildcard match
  rule page *() { "xxx"=="yyy" }

  // Partial wildcard match
  rule page roo*(*) { "abc"=="def"}

-- END ONLY 2 --


