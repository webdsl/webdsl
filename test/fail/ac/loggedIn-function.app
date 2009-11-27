//Function with name 'loggedIn' and 0 argument

application test

define page root() {}

function loggedIn(){}

entity User { name :: String} 

principal is User with credentials name
