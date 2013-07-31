//#1 Synchronization framework requires at least one TopLevelEntity
application test

  entity User {
    name :: String
    
    synchronization configuration {}
  }
 

  define page root(){}