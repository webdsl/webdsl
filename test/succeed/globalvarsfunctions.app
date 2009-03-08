application test

section datamodel

  define body() {
    "default body"
  }
  
  entity User{
    username :: String
  }

  function test1(a:Int):Int
  {
    return a+1;
  }
  function test2(a:Int,b:Int):Int
  {
    return a-b;
  }
  globals {
    function test3(a:Int,b:Int):Int
    {
      return a-b;
    }
  }
  globals {
    function test4(a:Int,b:Int):Int
    {
      return a+b;
    }
    function test5(a:Int,b:Int):Int
    {
      return a*b;
    }
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
      
      if(test1(5)+test2(5,6)+test3(2,6)+test4(4,3)+test5(7,9)>5)
      {
        "testfunctions"
      }
    }
   }