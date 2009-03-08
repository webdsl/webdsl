application test

section datamodel

  define body() {
    "default body"
  }
  
  entity User{
    username :: String
  }
  var alice : User := User { username := "Alice" };
  var bob : User := User { username := "Bob" };
  var charlie : User := User { username := "Charlie" };
  var dave : User := User { username := "Dave" };
  
  globals {
    var eve : User := User { username := "Eve" };
  }
  
  globals {
    var mallory : User := User { username := "Mallory" };
    var ivan : User := User { username := "Ivan" };
    var justin : User := User { username := "Justin" };  
  }

  define main() 
  {
    body()
  }
  
  define page home(){
    main()
    
    define body()
    {
      output(alice.username)
      output(bob.username)
      output(charlie.username)
      output(dave.username)
      output(eve.username)
      output(mallory.username)
      output(ivan.username)
      output(justin.username)
    }
   }