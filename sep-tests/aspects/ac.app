module ac

//imports
//  aspects

principal is User with credentials name

access control rules

  rule template main() { true }
  rule template main*(s : String *) { false && true }
  rule template main234(s : String *) { 3==4 || (8>4) }
 
access control rules

  rule page *() { "xxx"=="yyy" }
  rule page root() { "bla" == "sja" }
  