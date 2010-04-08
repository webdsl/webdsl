//Template with this signature not defined
application test

  entity User{
    username :: String
  }
  principal is User with credentials username
  define page login(){} //overrides default generated login and blocks generation of authentication template
  
  access control rules
    rule page root() { true }
    
  section pages
  
  define page root(){
    authentication()
    logout()
  }
  