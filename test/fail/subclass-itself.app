//Entity name: "Entity" is not allowed
//#4 Entity may not inherit from itself.

application test

  define page root() {
  }
  
  entity User:User{
  }
  
  entity A:B{}
  entity B:C{}
  entity C:A{}
  
  entity Entity{}
